Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbYCMKMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbYCMKMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbYCMKLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:11:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35236 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbYCMKLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:11:33 -0400
Date: Thu, 13 Mar 2008 09:13:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Julian Blake Kongslie <jblake@omgwallhack.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Hang on suspend
Message-ID: <20080313081319.GD19808@elf.ucw.cz>
References: <1203553943.4422.25.camel@dukephillips.omgwallhack.org> <200802241223.46930.rjw@sisk.pl> <1203887415.4154.4.camel@dukephillips.omgwallhack.org> <200802242335.01800.rjw@sisk.pl> <1203893049.3983.6.camel@dukephillips.omgwallhack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203893049.3983.6.camel@dukephillips.omgwallhack.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-02-24 14:44:09, Julian Blake Kongslie wrote:
> On Sun, 2008-02-24 at 23:35 +0100, Rafael J. Wysocki wrote:
> > [Please don't drop the CC list from replies.]
> 
> Yeah, sorry, I accidentally whacked the wrong reply button.
> 
> > On Sunday, 24 of February 2008, Julian Blake Kongslie wrote:
> > > On Sun, 2008-02-24 at 12:23 +0100, Rafael J. Wysocki wrote:
> > > > Can you please check what's at the address platform_suspend_late+0x19?
> > > 
> > > 0xc0253ca9 is in platform_suspend_late (drivers/base/platform.c:579).
> > > 574	{
> > > 575		struct platform_driver *drv = to_platform_driver(dev->driver);
> > > 576		struct platform_device *pdev;
> > > 577		int ret = 0;
> > > 578	
> > > 579		pdev = container_of(dev, struct platform_device, dev);
> > > 580		if (dev->driver && drv->suspend_late)
> > > 581			ret = drv->suspend_late(pdev, mesg);
> > > 582	
> > > 583		return ret;
> > 
> > That's strange, it looks like the container_of() accessing beyond the
> > structure.
> > 
> > Is this 100% reproducible?
> 
> Yes, it is. I've had this hang on suspend since at least some time in
> early 2.6.24-rc, although because I have to transcribe the oops manually
> I haven't had enough incentive to get it reported until now.
> Unfortunately, I just don't need to suspend very often, so it may have
> been introduced some time before then.
> 
> If you don't have any other ideas, I can try to bisect and find the
> change that introduced it, but it'll probably take me a day or two; I
> have other things I need to use my computer for, so it's a bit difficult
> to do the constant-reboot-and-test cycle.

Any news on this? Did bisect show something interesting?



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
