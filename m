Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbXJGLa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbXJGLa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 07:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXJGLaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 07:30:16 -0400
Received: from barikada.upol.cz ([158.194.242.200]:50243 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbXJGLaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 07:30:14 -0400
Date: Sun, 7 Oct 2007 13:10:35 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:' usage"
Message-ID: <20071007111035.GO22435@flower.upol.cz>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071007060706.GA18768@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo, Ingo.

On Sun, Oct 07, 2007 at 08:07:07AM +0200, Ingo Molnar wrote:
> 
> * Oleg Verych <olecom@flower.upol.cz> wrote:
> 
> > > > * completely useless, if properly implemented in userspace (with 
> > > >   much reacher functionality).
> > > 
> > > that's hogwash. No user-space runs during early bootup. (and yes i 
> > > want a color code at glance if something hangs in early bootup) 
> > > Nothing will color-code crashes, etc., etc. Control of the _kernel_ 
> > > console by user-space is complete nonsense.
> > 
> > If it is so important for major kernel developer like you, Ingo, then 
> > why there's no scrollback at first place? Why nothing like that was 
> > not implemented up until now?

To clarify. `Scrollback' here is *useful* scrollback during early boot
and OOPs (which is absent, AFAIK), "nothing like that" is coloring of the
messages by loglevel.

> even if it were true (which it isnt), that is not an argument against 
> including a useful change that exists now and that people are interested 
> in.

Coloring isn't useful. If it was, it would be implemented ~16 years ago.

> (and yes, i have implemented kernel console improvements in the past 
> and vga scrollback support was in fact amongst one of my first ever 
> Linux kernel hacks so your comment is doubly wrong.)

This `scrollback' is usual late boot / console one. If fact useful,
until first tty switch or if `screen` cannot be used. But for some
reason if scrolling region (DECSTBM) is less than whole screen, nothing
works. And if width set to odd number of columns

`stty columns $((80-1))`

whole output becomes somewhat funny.

> > My first ever Linux hack was changing default console output color. I 
> > think it was seven years ago. I though, it was not serious, if nobody 
> > did that already (in the 2.2.14).
> > 
> > Please, don't mix important stuff here. I know, what kernel console 
> > is.
> 
> your arguments are not an answer to my technical points, which i'll 
> repeat here:
> 
> | | [...] No user-space runs during early bootup. (and yes i want a 
> | | color code at glance if something hangs in early bootup)

The kernel developer talks about what is important to him. This is not
technical point.

> | | Nothing will color-code crashes, etc., etc.

Because without userspace kernel panics. And if something is broken very
early, then time to do kernel development better (not to break working
early booting stuff for everybody), rather than to talk about importance
of the color. I think, same applies to kernel debugger, that still
is not in mainline (AFAIK).

> | | Control of the _kernel_ console by user-space is complete nonsense.

Not control, but flexible coloring (any kind of highlighting), selecting
of useful information, i.e. making output more user friendly. This are
things, which all *users* (not developers) expect in boot process of the
one's _machine_, as opposed to debugging (early boot) kernel bugs.

> today's console code development goes in exactly the opposite direction: 
> we are including (formerly-) user-space console functionality in the 
> kernel so that we can for example print oopses even if we are in X mode.

I'm not sure what kind of printing it is. I do not use X much, but when i
did, i recall MCE messages in xterm, when over-clocked CPU was going
crazy, though.

> > > this is nice and robust functionality that i personally welcome. The 
> > > default is not changed in any way.
> > > 
> > > (btw., i corrected the subject line to remove the 'NAK'. Why do you 
> > > think you can 'NAK' a patch in this field?)
> > 
> > I added comment (like this), so anyone can skip reading body, if 
> > headers are "Oleg Verych && NAK". In case if `NAK' have a magic 
> > meaning in the LKML, like control characters in the tty, i'm sorry.
> 
> yes, a 'NAK' has a particular meaning on lkml.

But what about (NAK && ! any_important_kernel_developer_name)?

> > But how to express opinion quickly and easily?
> 
> by writing a quick email expressing your opinion and waiting to see the 
> discussion play out itself ...

Quick is not for me (i did accepted "config NO" size reduction review,
btw), but for those, who reads LKML or looks on archive search results.

I just am amazed how `Subject' is miss-used. I personally like to have
most of the interesting information gathered from all that thousands of
(not only LKML) messages. But a thread with all-like-one subjects,
subjects that for some reason are taking place on the screen of
MUAs (empty space if they are the same). Thus, short (easy to get right)
summary in subject is more that welcome by me.

> but it is very rude to 'NAK' a patch and it should only be done 
> carefully.

That was a review of the implementation, an opinion on whole idea. Idea
of yet another ugly kernel functionality, just because *BSD kernels have
one.

I like highlighting, i like to make it very flexible, nice and
interesting[0]. This is possible only in the userspace, right after first
process ran from initramfs. This happens very quickly usually. And yes,
this is not acceptable/available for kernel developers/maintainers.

[0] not much, but something <ftp://flower.upol.cz/upload/debian.sh> 

> 	Ingo
____
