Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbXKJUfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbXKJUfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 15:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbXKJUfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 15:35:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47493 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbXKJUfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 15:35:43 -0500
Message-ID: <473615F5.5090908@zytor.com>
Date: Sat, 10 Nov 2007 12:35:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Jeff Garzik <jeff@garzik.org>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org> <20071110075444.GA5707@uranus.ravnborg.org> <20071110082152.GA18632@linux-sh.org> <47356AD5.4070102@garzik.org> <20071110084447.GA18780@linux-sh.org>
In-Reply-To: <20071110084447.GA18780@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> Indeed, that's what I was intending on keeping around as a convention,
> and simply overloading SRCARCH for the sh64 case. i386/x86_64 potentially
> has the same issue though, and if the intent is to have a single ARCH for
> both of them, I don't see how that would possibly work without
> sacrificing randconfig.. unless the intended x86 convention is that one
> compiler will happily handle both i386 and x86_64 without any difficulty?

Well, that *is* the normal thing on x86.

HOWEVER, I think the right thing for allyesconfig, allmodconfig, 
randconfig, etc. is to be able to override specific variables.  Right 
now, one has to use indirection via a file, which is a bit clumsy; it 
would be better if one could do "make allyesconfig CONFIG_X86_64=y" or 
somesuch.

In fact, we should be able to get rid of ARCH entirely;  CONFIG_ options 
have the huge advantage that they're saved in a file, and you don't have 
to type them on every make run. The only option that I can't see us 
getting rid of easily is HOSTCC, since it is used before config is run, 
but probably something clever can be done there, too.

	-hpa
