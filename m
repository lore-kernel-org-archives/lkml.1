Return-Path: <linux-kernel-owner+w=401wt.eu-S933079AbYEFUsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbYEFUsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760745AbYEFUr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:47:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758495AbYEFUry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:47:54 -0400
Date: Tue, 6 May 2008 13:46:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: nix@esperi.org.uk, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 11/19] UML - Track and make up lost ticks
Message-Id: <20080506134655.4cac1014.akpm@linux-foundation.org>
In-Reply-To: <20080429202924.GA13602@c2.user-mode-linux.org>
References: <20080425175613.GA11192@c2.user-mode-linux.org>
	<877iegcx11.fsf@hades.wkstn.nix>
	<20080429202924.GA13602@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 16:29:25 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> On Tue, Apr 29, 2008 at 07:54:02PM +0100, Nix wrote:
> > On 25 Apr 2008, Jeff Dike stated, in part:
> > > Index: linux-2.6-git/arch/um/os-Linux/time.c
> > > ===================================================================
> > > --- linux-2.6-git.orig/arch/um/os-Linux/time.c	2008-04-25 10:42:12.000000000 -0400
> > > +++ linux-2.6-git/arch/um/os-Linux/time.c	2008-04-25 11:19:26.000000000 -0400
> > > +	alarm_handler(SIGVTALRM, NULL);
> > > +		alarm_handler(SIGVTALRM, NULL);
> > > -extern void alarm_handler(int sig, struct sigcontext *sc);
> > > -		alarm_handler(SIGVTALRM, NULL);
> > 
> > Yet, in arch/um/include/process.h, we see, unchanged since the year dot, the
> > obviously wrong prototype:
> > 
> > extern void alarm_handler(int sig, struct sigcontext sc);
> > 
> > Hence:
> > 
> >   CC      arch/um/os-Linux/time.o
> > arch/um/os-Linux/time.c: In function ‘deliver_alarm’:
> > arch/um/os-Linux/time.c:119: error: incompatible type for argument 2 of ‘alarm_handler’
> > make[1]: *** [arch/um/os-Linux/time.o] Error 1
> > make: *** [arch/um/os-Linux] Error 2
> > 
> > Fix trivial:
> > 
> > Signed-off-by: Nick Alcock <nix@esperi.org.uk>
> > -- 
> > Index: linux/arch/um/include/process.h
> > ===================================================================
> > --- linux.orig/arch/um/include/process.h	2006-07-09 14:19:52.000000000 +0100
> > +++ linux/arch/um/include/process.h	2008-04-29 19:49:49.000000000 +0100
> > @@ -8,8 +8,8 @@
> >  
> >  #include <signal.h>
> >  
> > -extern void sig_handler(int sig, struct sigcontext sc);
> > -extern void alarm_handler(int sig, struct sigcontext sc);
> > +extern void sig_handler(int sig, struct sigcontext *sc);
> > +extern void alarm_handler(int sig, struct sigcontext *sc);
> >  
> >  #endif
> 
> Crap, I fixed that, but forgot to quilt add it, I guess.
> 
> ACK.
> 

This fix was already present in your "[PATCH 4/19] UML - Random driver fixes".

Perhaps we broke bisection?
