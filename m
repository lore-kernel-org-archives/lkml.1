Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbYDNGnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbYDNGnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 02:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758193AbYDNGnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 02:43:40 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:39791 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYDNGnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:43:39 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Mon, 14 Apr 2008 08:43:04 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200804040111.15255.rjw@sisk.pl> <200804140309.22057.rjw@sisk.pl> <1208143380.6958.105.camel@pasglop>
In-Reply-To: <1208143380.6958.105.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140843.06088.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. April 2008 05:23:00 schrieb Benjamin Herrenschmidt:
> 
> > To avoid breaking things (from the functional point of view) unnecessarily.
> > 
> > In short, I don't really see the difference between moving ->prepare() before
> > the freezer and droppig the freezer, which I'm not going to do right now.
> 
> I believe the use of prepare for things like request_firmware etc... is
> worth the effort of fixing the known breakage of not having the freezer
> while preventing insertion of new devices (mostly USB). In fact, it
> won't be such a big issue as the core should/will return an error from
> attempting to add the device in that case.

Which is the problem. Suspension is supposed to be transparent.
We cannot start returning error codes for operations which never
failed in practice (eg. switching configurations in USB), just because
the system is about to be suspended.

If you want to request firmware in a PM callback, which makes a certain
sense, as we should move to a comprehensive API, if we change the API
at all, we need a model with 3 callbacks.

	Regards
		Oliver
