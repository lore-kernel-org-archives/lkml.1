Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbXJWNYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbXJWNYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 09:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXJWNYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 09:24:33 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59263 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751841AbXJWNYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 09:24:32 -0400
Date: Tue, 23 Oct 2007 15:25:01 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Al Viro <viro@ftp.linux.org.uk>,
       WANG Cong <xiyou.wangcong@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Nix <nix@esperi.org.uk>, Jeff Dike <jdike@addtoit.com>,
       Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in
	2.6.23-final.
Message-ID: <20071023132501.GT30533@stusta.de>
References: <20071022065943.GC10864@uranus.ravnborg.org> <20071022074823.GJ2998@hacking> <20071022113600.GA8181@ftp.linux.org.uk> <20071022122504.GL2998@hacking> <20071022124322.GB8181@ftp.linux.org.uk> <20071022124551.GA7438@elte.hu> <471D2ECC.6090209@goop.org> <20071022231927.GA30814@elte.hu> <471D389E.40609@goop.org> <20071023084546.GA17007@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071023084546.GA17007@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 10:45:46AM +0200, Ingo Molnar wrote:
> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > >> Should we re-add them for the function pointers in 
> > >> asm-x86/paravirt.h?
> > >
> > > yes, yes, yes. :-) It was a nightmare to sort it out in -rt (and 
> > > still is).
> > 
> > Do you have a patch to do this already?
> 
> yes, attached. Ack?
> 
> 	Ingo
> 
> ---------------------------->
> Subject: [patch] paravirt: mark assembly dependencies as fastcall
> From: Ingo Molnar <mingo@elte.hu>
> 
> the 'fastcall removal' changes to paravirt.c were over-eager: they
> removed fastcall annotations from functions that are (or might be)
> implemented in assembly. So if someone changes the compiler model,
> such as -pg which disables regparm, the kernel breaks in nasty ways.
> 
> so this patch adds back fastcall annotations. This serves as
> documentation for assembly calling-convention dependencies as
> well.
>...

I see a point in annotating all C code called from assembler code with 
either fastcall or asmlinkage, but how will these annotations be 
maintained?

Without anything giving at least a warning these annotations will simply 
bitrot.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

