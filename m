Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYKFLe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYKFLe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 06:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbYKFLeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 06:34:20 -0500
Received: from vs02.svr02.mucip.net ([83.170.6.69]:46902 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbYKFLeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 06:34:20 -0500
Date: Thu, 6 Nov 2008 12:34:16 +0100
From: Bernhard Schmidt <berni@birkenwald.de>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.28-rc3] regression when switching TTY->X, input related?
Message-ID: <20081106113416.GA6449@schleppi.birkenwald.de>
References: <20081105220419.GA15685@pest> <20081106041517.1C7FE143D4EA@smtp02.mtu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106041517.1C7FE143D4EA@smtp02.mtu.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 07:15:11AM +0300, Andrey Borzenkov wrote:

> > I have a pretty weird issue with 2.6.28-rc3 that I originally thought to
> > be related with suspend2ram, then with intel's xorg driver and now it
> > looks like something related to the input subsystem.
> > 
> > I have a Dell Latitude D630 (Intel GM965 graphics) running Ubuntu 8.10
> > amd64. Since the included (heavily patched by Ubuntu) 2.6.27 is
> > extremely unstable in iwlagn I've been trying my luck with 2.6.28-rc3.
> > 
> > One thing that did not work anymore was suspend2ram and resume. It would
> > suspend just fine and resume as well, but then I would sit in front of a
> > black screen with an unmovable mouse cursor and not be able to do
> > anything, not even switch vtys or kill X with ctrl-alt-backspace. Magic
> > Sysrq to reboot did usually work though.
> > 
> > I've been following a few threads about similar issues in here, among
> > others this one: http://lkml.org/lkml/2008/11/5/217 . However, the
> > workaround mentioned in there (switch to a textmode console prior to
> > suspend) didn't work, in fact when switching back to X without
> > suspending I had the same problem. After sitting there and scratching my
> > head for a couple of minutes the screensaver unlock dialog suddenly
> > appeared and I could enter my password and "work", but the touchpad
> > didn't work. 
> 
> Cannot comment on input stuff, but I noticed that you are using driver
> that requests firmware:
> 
> [   39.735183] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ
> 17
> [   39.735272] iwlagn 0000:0c:00.0: restoring config space at offset 0x1
> (was 0x100102, writing 0x100106)
> [   39.735379] iwlagn 0000:0c:00.0: irq 42 for MSI/MSI-X
> [   39.735448] iwlagn 0000:0c:00.0: firmware: requesting
> iwlwifi-4965-2.ucode
> 
> If it tries to do it during resume in ->resume method, this won't work and
> will timeout; symptoms are exactly as you describe (sitting there for 180
> seconds and suddenly start to work). Do you have WiFi connection on resume?

Yes. In fact the WiFi connection is reestablished immediately after
resume (with NetworkManager) and I can ping the box through WiFI, while
X hangs and waits for something.

Bernhard
