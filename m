Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbYERUmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbYERUmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 16:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbYERUmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 16:42:46 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49048 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbYERUmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 16:42:45 -0400
Date: Sun, 18 May 2008 23:40:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Tom Spink <tspink@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
Message-ID: <20080518204045.GK8140@cs181133002.pp.htv.fi>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <482FD9F2.8080204@goop.org> <20080518180811.GI8140@cs181133002.pp.htv.fi> <Pine.LNX.4.55.0805181934220.16640@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0805181934220.16640@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 07:38:41PM +0100, Maciej W. Rozycki wrote:
> On Sun, 18 May 2008, Adrian Bunk wrote:
> 
> > Even more important:
> > How do you want to handle kconfig variables set to "m"?
> > 
> > Expand them to 0.5 ?  ;-)
> 
>  :-)
> 
>  Modules use a separate set of variables with _MODULE appended to their 
> names.  Thus for an option FOO, you'll get:
> 
> #undef CONFIG_FOO
> #undef CONFIG_FOO_MODULE
> 
> if it's set to "n",
> 
> #define CONFIG_FOO 1
> #undef CONFIG_FOO_MODULE
> 
> if it's set to "y", and
> 
> #undef CONFIG_FOO
> #define CONFIG_FOO_MODULE 1
> 
> if it's set to "m".  Individual tests may check these both as they find 
> appropriate.

I do know that.


But your suggestion was:

static inline unsigned int get_nmi_count(int cpu)
{
        return cpu_x86_64 ? cpu_pda(cpu)->__nmi_count : nmi_count(cpu);
}


And Jeremy said "It would be nice if CONFIG_* expanded to 0/1".


My point was simply that like most of the fun^Wproblems we already have 
in kconfig also here the tristate logic we need would make stuff more 
tricky.


>   Maciej

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

