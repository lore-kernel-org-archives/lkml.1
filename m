Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbZGGLaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbZGGLaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZGGLaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:30:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33004 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbZGGLaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:30:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergio Luis <sergio@larces.uece.br>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] fix resume from suspend when CONFIG_CC_STACKPROTECTOR
Date: Tue, 7 Jul 2009 13:30:36 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Peter Chubb <peter.chubb@nicta.com.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <87r5wt6lsg.wl%peter@chubb.wattle.id.au> <430c4fa50907070118k6a053333pdf81ba8c016e2d23@mail.gmail.com>
In-Reply-To: <430c4fa50907070118k6a053333pdf81ba8c016e2d23@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071330.36649.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Sergio Luis wrote:
> Hi,
> 
> On Tue, Jul 7, 2009 at 3:37 AM, Peter Chubb<peter.chubb@nicta.com.au> wrote:
> >
> > Patch 08687aec71bc9134fe336e561f6did877bacf74fc0a (x86: unify
> > power/cpu_(32|64).c)  renamed cpu_32.c to cpu.c, but did not update
> > the special compilation flags for the file for the new name.
> >
> > This patch fixes the compilation flags, and therefore fixes resume
> > from suspend on my Acer Aspire One.
> >
> 
> yeah, I missed it, sorry for that. Thanks for catching it. CC'ing
> Rafael and Ingo, as they will know the best way to push the fix.

Thanks!

Ingo, do you want me to handle it?

Rafael

 
> > Signed-off-by: Peter Chubb <peterc@nicta.com.au>
> > ---
> >  arch/x86/power/Makefile |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Index: linux-2.6/arch/x86/power/Makefile
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/power/Makefile      2009-07-07 13:39:54.000000000 +1000
> > +++ linux-2.6/arch/x86/power/Makefile   2009-07-07 13:40:14.000000000 +1000
> > @@ -1,7 +1,7 @@
> >  # __restore_processor_state() restores %gs after S3 resume and so should not
> >  # itself be stack-protected
> >  nostackp := $(call cc-option, -fno-stack-protector)
> > -CFLAGS_cpu_$(BITS).o   := $(nostackp)
> > +CFLAGS_cpu.o   := $(nostackp)
> >
> >  obj-$(CONFIG_PM_SLEEP)         += cpu.o
> >  obj-$(CONFIG_HIBERNATION)      += hibernate_$(BITS).o hibernate_asm_$(BITS).o
> >
> > --
> > Dr Peter Chubb                                  peter DOT chubb AT nicta.com.au
> > http://www.ertos.nicta.com.au               ERTOS within National ICT Australia
> > All things shall perish from under the sky/Music alone shall live, never to die
> >
> 
> Sergio.
