Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbXITVS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbXITVS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbXITVSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:18:48 -0400
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:15701 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937AbXITVSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:18:47 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.23-rc6: S4 and S5 no longer listed as supported on Toshiba Satellite A40
Date: Thu, 20 Sep 2007 23:18:43 +0200
User-Agent: KMail/1.9.7
Cc: Alexey Starikovskiy <aystarik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Maciek Rutecki <maciej.rutecki@gmail.com>
References: <200709192014.08443.elendil@planet.nl> <200709202207.13101.rjw@sisk.pl> <200709202232.33309.elendil@planet.nl>
In-Reply-To: <200709202232.33309.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709202318.44676.elendil@planet.nl>
X-OriginalArrivalTime: 20 Sep 2007 21:18:47.0473 (UTC) FILETIME=[D50DC210:01C7FBCB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007, Frans Pop wrote:
> On Thursday 20 September 2007, Rafael J. Wysocki wrote:
> > On Thursday, 20 September 2007 20:33, Alexey Starikovskiy wrote:
> > > Frans Pop wrote:
> > > > Maybe S0 should be taken outside the #ifdef and the loop as that
> > > > state is also basically always there?
> > >
> > > Don't think it is worth the trouble. We already have this loop almost
> > > completely unrolled, let's not make it complete mess...
> >
> > Well, you could use "(supports S0" instead of just "(supports". ;-)
>
> After thinking about this a bit more, I think this does make sense for
> three (admittedly minor) reasons:
> - consistency between messages with and without CONFIG_SUSPEND
> - consistency with /proc/acpi/sleep
> - avoiding unnecessary change from previous versions.

One additional reason...

With current code, sleep_states(0) will not be set if compiled without 
CONFIG_SUSPEND, which means that S0 will also disappear from
/proc/acpi/sleep. With pre-2.6.23 code it would be listed there.

I think that is even a more relevant change than the display issue and could 
possibly even be considered a user-space interface regression.
My proposed patch fixes that too.

Note that the patch currently does not call acpi_get_sleep_type_data for S0, 
but (partially from Rafael's comment) I was assuming that for S0 that does 
not really matter. If it does, then the patch could easily be adjusted to 
include that.
