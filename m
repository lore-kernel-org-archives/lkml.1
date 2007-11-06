Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbXKFRdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbXKFRdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 12:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbXKFRdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 12:33:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42255 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXKFRdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 12:33:41 -0500
Date: Tue, 6 Nov 2007 09:32:23 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Thomas =?UTF-8?B?QsOkY2hsZXI=?= <thomas@archlinux.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
Message-ID: <20071106093223.7e6f4f6c@laptopd505.fenrus.org>
In-Reply-To: <20071104020217.GJ12045@stusta.de>
References: <fg5kar$d70$1@ger.gmane.org>
	<alpine.LFD.0.9999.0710292310040.3186@localhost.localdomain>
	<47266BF6.6070206@archlinux.org>
	<alpine.LFD.0.9999.0710300033470.3186@localhost.localdomain>
	<4726F510.9060207@archlinux.org>
	<472C47B4.4030808@archlinux.org>
	<20071103121149.GA22149@uranus.ravnborg.org>
	<20071104020217.GJ12045@stusta.de>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2007 03:02:17 +0100
Adrian Bunk <bunk@kernel.org> wrote:

> On Sat, Nov 03, 2007 at 01:11:49PM +0100, Sam Ravnborg wrote:
> > On Sat, Nov 03, 2007 at 11:04:36AM +0100, Thomas Bächler wrote:
> > > Thomas Bächler schrieb:
> > > > 
> > > > I just remembered, a friend of mine got it to compile with the
> > > > exact same toolchain, but with a different configuration (which
> > > > I don't have). He used a snapshot tarball from yesterday
> > > > though, not the git tree.
> > > > 
> > > 
> > > I found the problem and eliminated it. While this is my own
> > > fault, it is still a bug in either the kernel or the build
> > > system: I had CFLAGS set to "-Wall -O3 -march=native -pipe". I
> > > always thought the kernel would ignore those and set its own
> > > CFLAGS, but I was wrong. Either the -O3 or the -march=native
> > > break the build process on gcc 4.2.2.
> > > 
> > The kernel will now honour the users CFLAGS setting as you just
> > discovered. The flags will be appended to the flags specified by
> > the kernel.
> >...

I think we can solve a ton of issues if we don't make the CFLAGS
*append* but just *prepend*. That way, if the KConfig overrides a
certain CFLAG, that sticks... since gcc picks the last one in case of
conflicting options. That gives us both the honoring of cflags, and the
principle of least surprise in that KConfig options are honored...


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
