Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbXITQdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbXITQdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbXITQdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:33:42 -0400
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:3125 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756210AbXITQdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:33:41 -0400
From: Frans Pop <elendil@planet.nl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.23-rc6: S4 and S5 no longer listed as supported on Toshiba Satellite A40
Date: Thu, 20 Sep 2007 18:33:38 +0200
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200709192014.08443.elendil@planet.nl> <20070920105312.GC12157@atrey.karlin.mff.cuni.cz> <200709201437.56431.elendil@planet.nl>
In-Reply-To: <200709201437.56431.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201833.38765.elendil@planet.nl>
X-OriginalArrivalTime: 20 Sep 2007 16:33:39.0119 (UTC) FILETIME=[FFAE1BF0:01C7FBA3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007, Frans Pop wrote:
> On Thursday 20 September 2007, you wrote:
> > > When compared with 2.6.22-4, dmesg no longer lists S4 and S5 as
> > > supported for my Toshiba Satellite A40 laptop (Mobile Intel Pentium
> > > 4, 2.8GHz).
> > >
> > > -Linux version 2.6.22-2-686 (Debian 2.6.22-4) (waldi@debian.org) ...
> > > +Linux version 2.6.23-rc6 (root@faramir) ...
> > >  [...]
> > > -ACPI: (supports S0 S3 S4 S5)
> > > +ACPI: (supports S0 S3)
> >
> > Unexpected, and potentially pretty serious. Something went wrong with
> > ACPI. Can you try to narrow down when it started happening?
>
> rc1 still had all 4 levels. I'll run a bisect between rc1 and rc6.

I've bisected it down to this trio of changes:
- b0cb1a19d05b8ea8 Replace CONFIG_SOFTWARE_SUSPEND with CONFIG_HIBERNATION
- 296699de6bdc7171 Introduce CONFIG_SUSPEND for suspend-to-Ram and standby
- 673d5b43daa00b42 ACPI: restore CONFIG_ACPI_SLEEP

The actual change is probably in the second of those.

I've seen the comment that the change may just be cosmetic, but I'll leave 
it to others to confirm that (and if so, judge if it is desirable or not).

Cheers,
Frans Pop
