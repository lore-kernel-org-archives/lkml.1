Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbZD2QGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbZD2QGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbZD2QGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:06:13 -0400
Received: from outbound-mail-148.bluehost.com ([67.222.38.38]:46205 "HELO
	outbound-mail-148.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756065AbZD2QGK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:06:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=HrhyHqrL/M9wSig9bDr8WmCz6PN7rA+dPiOjBRHqXEV0hR285TNPf3Mdx/nbTFZp/KamhmLBstaRIMl9OpPadDMBiXrsXFDpBI2TlATOVk4LrUlR7GBz4pHfdajGPYSj;
Date: Wed, 29 Apr 2009 09:06:07 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Bennee <kernel-hacker@bennee.com>
Cc: Florian Mickler <florian@mickler.org>, xorg@freedesktop.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
Message-ID: <20090429090607.2d351545@hobbes>
In-Reply-To: <b2cdc9f30904290049k290a59bfh1265a66735b510e2@mail.gmail.com>
References: <b2cdc9f30904182327w12a3ec32t90c7c6c34980577b@mail.gmail.com>
	<20090427234947.394f774f@schatten>
	<b2cdc9f30904272237h3a815282h7e6b932e1c252d17@mail.gmail.com>
	<20090428095338.3e7b2062@hobbes>
	<b2cdc9f30904290049k290a59bfh1265a66735b510e2@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 08:49:47 +0100
Alex Bennee <kernel-hacker@bennee.com> wrote:

> 2009/4/28 Jesse Barnes <jbarnes@virtuousgeek.org>:
> > On Tue, 28 Apr 2009 06:37:10 +0100
> > Alex Bennee <kernel-hacker@bennee.com> wrote:
> >
> >> 2009/4/27 Florian Mickler <florian@mickler.org>:
> >> > On Sun, 19 Apr 2009 07:27:35 +0100
> >> > Alex Bennee <kernel-hacker@bennee.com> wrote:
> >> >
> >> >> Heading the warnings in the menuconfig I did try and ensure I
> >> >> have all the up to date parts of user-space. With KMS enabled
> >> >> GDM starts up but then corrupts the display with vertical lines.
> >> >> Disabling the kernel config and everything starts up fine, UXA
> >> >> acceleration seems OK and the speed of compiz is finally back up
> >> >> to ~60fps thanks to the A17 fix.
> >> >>
> >> >> Am I missing another bit of user space for KMS to work properly?
> >>
> >> Apparently I was missing a key bit and had to enable fbdev from the
> >> command line:
> >>
> >> kernel /kernel-2.6-drm root=/dev/sda2
> >> video=intelfb:mode=1440x900-32@75,accel,hwcursor
> >>
> >> However I still saw the same corruption kick in when GDM started. I
> >> couldn't switch mode either which kinda defeated the point.
> >
> > The above seems to indicate that you have some FB drivers built into
> > your kernel; that will likely fail in weird ways.  Try disabling all
> > the FB drivers, but keep CONFIG_FRAMEBUFFER_CONSOLE enabled.  Then
> > when you load the i915 driver you should get a nice console.
> 
> Ahh, I was under the (mistaken) impression that the kernel
> frame-buffer drivers where linked to the console frame buffer driver
> and needed for it to work well. Disabling them all and I do indeed get
> a lovely framebuffer console on boot up but still the same corruption
> when GDM starts. I'm also still not able to switch back to the console
> like I can with KMS disabled.
> 
> I've attached my .config, a dump of the dmesg of the failing case and
> a broken and working Xorg.log (working being no KMS and the Linus tree
> rather than the intel-drm tree, although I have tested the Linus tree
> fails with KMS enabled in the same way).

Ok so you're getting a good console, that's a start. :)

This really sounds like one of the tiling related issues that should be
fixed now, but if you're on the latest bits...

Can you try setting the tiling option to false in your xorg.conf?
Also, please file a bug for this at bugs.freedesktop.org with your X
log & dmesg from your latest config; you can just assign it to me.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
