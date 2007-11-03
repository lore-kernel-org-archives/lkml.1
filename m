Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbXKCMKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbXKCMKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 08:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbXKCMKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 08:10:15 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42935 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbXKCMKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 08:10:13 -0400
Date: Sat, 3 Nov 2007 13:11:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
Message-ID: <20071103121149.GA22149@uranus.ravnborg.org>
References: <fg5kar$d70$1@ger.gmane.org> <alpine.LFD.0.9999.0710292310040.3186@localhost.localdomain> <47266BF6.6070206@archlinux.org> <alpine.LFD.0.9999.0710300033470.3186@localhost.localdomain> <4726F510.9060207@archlinux.org> <472C47B4.4030808@archlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <472C47B4.4030808@archlinux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2007 at 11:04:36AM +0100, Thomas Bächler wrote:
> Thomas Bächler schrieb:
> > 
> > I just remembered, a friend of mine got it to compile with the exact
> > same toolchain, but with a different configuration (which I don't have).
> > He used a snapshot tarball from yesterday though, not the git tree.
> > 
> 
> I found the problem and eliminated it. While this is my own fault, it is
> still a bug in either the kernel or the build system: I had CFLAGS set
> to "-Wall -O3 -march=native -pipe". I always thought the kernel would
> ignore those and set its own CFLAGS, but I was wrong. Either the -O3 or
> the -march=native break the build process on gcc 4.2.2.
> 
The kernel will now honour the users CFLAGS setting as you just discovered.
The flags will be appended to the flags specified by the kernel.

So the kernel change is on purpose but this does not explain why it 
fails for you.
It should be trivial to investigate which of the options that makes
it fail.

	Sam 

