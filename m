Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbXK3XUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbXK3XUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbXK3XUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:20:04 -0500
Received: from smtp.ono.com ([62.42.230.12]:28172 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751107AbXK3XUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:20:03 -0500
Date: Sat, 1 Dec 2007 00:19:50 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "=?UTF-8?B?TG/Dr2MgR3JlbmnDqQ==?=" <loic.grenie@gmail.com>
Cc: Ben.Crowhurst@stellatravel.co.uk, linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071201001950.11100a32@werewolf>
In-Reply-To: <9b06e8d20711300229r1ed570bfi9ecbb6466fd0a0ab@mail.gmail.com>
References: <474EAD18.6040408@stellatravel.co.uk>
	<9b06e8d20711300229r1ed570bfi9ecbb6466fd0a0ab@mail.gmail.com>
X-Mailer: Claws Mail 3.1.0cvs44 (GTK+ 2.12.2; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 11:29:55 +0100, "Loïc Grenié" <loic.grenie@gmail.com> wrote:

> 2007/11/29, Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>:
> > Has Objective-C ever been considered for kernel development?
> >
> > regards,
> > BPC
> 

Well, I really would like to learn some things here, could we
keep this off-topic thread alive just a bit, please ?
(I know, I'm going to gain a troll's fame because I can't avoid this
discussions, its one of my secret vices...)

>    No, it has not. Any language that looks remotely like an OO language
>   has not ever been considered for (Linux) kernel development and for
>   most, if not all, other operating systems kernels.
> 

I think BeOS was C++ and OSX is C+ObjectiveC (and runs on an iPhone).
Original MacOS (fron 6 to 9) was Pascal (and a mac SE was very near
to embedded hardware :) ).

I do not advocate to rewrite Linux in C++, but don't say a kernel written
in C++ can not be efficient.

>     Various problems occur in an object oriented language. One of them
>   is garbage collection: it provokes asynchronous delays and, during
>   an interrupt or a system call for a real time task, the kernel cannot
>   wait. 

C++ (and for what I read on other answer, nor ObjectiveC) has no garbage
collection. It does not anything you did not it to do. It just allows
you to change this

	struct buffer *x;
	x = kmalloc(...)
	x->sz = 128
	x->buff = kmalloc(...)
	...
	kfree(x->buff)
	kfree(x)
	
to
	struct buffer *x;
	x = new buffer(128); (that does itself allocates x->buff,
                              because _you_ programmed it,
                              so you poor programmer don't forget)
        ...
	delete x;            (that also was programmed to deallocate
                              x->buff itself, sou you have one less
                              memory leak to worry about)

>   Another is memory overhead: all the magic that OO languages
>   provide take space in memory and Linux kernel is used in embedded
>   systems with very tight memory requirements.
> 

An vtable in C++ takes exactly the same space that the function
table pointer present in every driver nowadays... and probably
the virtual method call that C++ does itself with

	thing->do_something(with,this)

like
	push thing
	push with
	push this
	call THING_vtable+indexof(do_something) // constants at compile time

is much more efficient that what gcc can mangle to do with

	thing->do_something(with,this,thing)

	push with
	push this
	push thing
	get thing+offsetof(do_something) // not constant at compile time
	dereference it
	call it

(that is, get a generic field on a structure and use it as jump address)

In short, the kernel is object oriented, implements OO programming by
hand, but the compiler lacks the knowledge that it is object oriented
programming so it could do some optimizations.

>     Lots of people will think of better reasons why ObjC is not used...

People usually complains about RTTI or exceptions, but benefits versus
memory space should be seriously considered (sure there is something
in current drivers to ask 'are you a SATA or an IDE disk?').


--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam03 (gcc 4.2.2 (4.2.2-1mdv2008.1)) SMP Sat Nov
09 F9 11 02 9D 74 E3 5B D8 41 56 C5 63 56 88 C0
