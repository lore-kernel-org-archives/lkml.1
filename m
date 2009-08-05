Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbZHEBmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbZHEBmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 21:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932967AbZHEBmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 21:42:11 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:61308 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbZHEBmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 21:42:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiYGAIOAeEqrR7O6/2dsb2JhbACDArkbiCmQMgWEGA
X-IronPort-AV: E=Sophos;i="4.43,325,1246838400"; 
   d="scan'208";a="360547264"
Date: Tue, 4 Aug 2009 18:42:10 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: David Brownell <david-b@pacbell.net>
Cc: Pierre Ossman <pierre@ossman.eu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl, ppisa@pikron.com,
       jarkko.lavinen@nokia.com, ben@fluff.org, saschasommer@freenet.de,
       avorontsov@ru.mvista.com, oakad@yahoo.com, ian@mnementh.co.uk,
       HaraldWelte@viatech.com, JosephChan@via.com.tw, adrian.hunter@nokia.com
Subject: Re: New MMC maintainer needed
Message-ID: <20090805014210.GA402@cuplxvomd02.corp.sa.net>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu> <20090728222334.0c543c47@mjolnir.ossman.eu> <20090731122623.254fd0f1@mjolnir.ossman.eu> <200908031851.24375.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908031851.24375.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 06:51:23PM -0700, David Brownell wrote:
> On Friday 31 July 2009, Pierre Ossman wrote:
> > Restoring back the system state from MMC after a successful hibernation
> > http://marc.info/?t=124818534700003&r=1&w=2
> > 
> > I don't agree with this approach. The point of the workqueue is so that
> > the kernel can do things in parallel, so this patch is a step back. The
> > problem is really with how the kernel doesn't properly cope with
> > asynchronous disk scanning during bootup. The root_delay parameter was
> > added for this for the "normal" case, but it seems more work is needed.
> 
> Doesn't handing of resumes needs more attention overall?
> 
> Example, root on eMMC (e.g. a 32-MByte non-removable chip) wouldn't
> resume at all well the last time I checked ... mounted file systems
> (not just root) made trouble.  Hardware that reliably reports card
> insert/remove was rude in the same ways.
> 
> - Dave

I've been half- (or less) watching this discussion, but I'm sort of thinking
that one piece of this might be a patch I just reposted that provides for
synchronizing the discovery/initialization of devices during start up with
their use. One thing I expect it to do is to largely eliminate the need for
root_delay. It currently knows nothing about resuming, but perhaps it should.

Since the patch touches USB and SCSI, as well as some core kernel pieces, it
was posted to a bunch of places, but by tomorrow you should be able to find it
by searching for "initdev" in the kernel mailing list archives.

David VomLehn
