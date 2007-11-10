Return-Path: <linux-kernel-owner+w=401wt.eu-S1751666AbXKJIp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbXKJIp0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 03:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbXKJIpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 03:45:16 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:7193 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750695AbXKJIpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 03:45:13 -0500
Date: Sat, 10 Nov 2007 17:44:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
Message-ID: <20071110084447.GA18780@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jeff Garzik <jeff@garzik.org>, Sam Ravnborg <sam@ravnborg.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org> <20071110075444.GA5707@uranus.ravnborg.org> <20071110082152.GA18632@linux-sh.org> <47356AD5.4070102@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47356AD5.4070102@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 03:24:53AM -0500, Jeff Garzik wrote:
> Paul Mundt wrote:
> >This is one of the things I've been wondering about with an sh/sh64
> >unification, as we have no option but having completely different
> >toolchains, and CONFIG_64BIT=y won't work there when they are both
> >using a 32-bit ABI.
> 
> 
> IMO it seems like you ought to be able to do
> 
> 	make ARCH=sh
> 		or
> 	make ARCH=sh64
> 
> and have it do the right thing.  Ditto for ppc/ppc64, etc.
> 
> Sane, straightforward, simple, consistent with existing practice...
> 
Indeed, that's what I was intending on keeping around as a convention,
and simply overloading SRCARCH for the sh64 case. i386/x86_64 potentially
has the same issue though, and if the intent is to have a single ARCH for
both of them, I don't see how that would possibly work without
sacrificing randconfig.. unless the intended x86 convention is that one
compiler will happily handle both i386 and x86_64 without any difficulty?

The idea of a single SRCARCH and differing ARCHs for adjusting the build
semantics as we have now is quite straightforward and seems clean enough
without pushing for ARCH unification.
