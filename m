Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbZF2XPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbZF2XPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbZF2XPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:15:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46915 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbZF2XPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:15:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
Date: Tue, 30 Jun 2009 01:15:26 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net>
In-Reply-To: <4A48F114.1010702@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906300115.26749.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Larry Finger wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13319
> > Subject		: Page allocation failures with b43 and p54usb
> > Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> > Date		: 2009-04-29 21:01 (61 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
> > 		  http://lkml.org/lkml/2009/6/7/136
> > Handled-By	: Johannes Berg <johannes@sipsolutions.net>
> 
> The cause of these failures has been determined. The wireless
> subsystem frequently requests buffers of size 4096, but when SLUB
> debugging is enabled and the debug info is added, the request becomes
> of order 1 and memory becomes fragmented.
> 
> A controversial "fix" in which SLUB debugging was disabled for
> allocations where adding such debugging info would increase the order
> was discussed and tried. With a quick look at the commit list for
> Linus's tree, I don't see that such a patch is available, but I will
> be corrected if I missed it.

Thanks for the update.

Hmm, isn't it suboptimal to use a slab allocator for allocations taking up an
entire page?  That's the case on some architectures and seems to be the root
cause of the issue at hand.

Best,
Rafael
