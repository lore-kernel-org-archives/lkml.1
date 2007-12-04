Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbXLDVY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbXLDVY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbXLDVYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:24:48 -0500
Received: from smtp.ono.com ([62.42.230.12]:52184 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751901AbXLDVYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:24:47 -0500
Date: Tue, 4 Dec 2007 22:24:38 +0100
From: "J.A. =?ISO-8859-1?Q?Magall=F3n?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071204222438.3325d6a3@werewolf>
In-Reply-To: <20071204175413.GD2310@csclub.uwaterloo.ca>
References: <474EAD18.6040408@stellatravel.co.uk>
	<9b06e8d20711300229r1ed570bfi9ecbb6466fd0a0ab@mail.gmail.com>
	<20071201001950.11100a32@werewolf>
	<20071204175413.GD2310@csclub.uwaterloo.ca>
X-Mailer: Claws Mail 3.1.0cvs49 (GTK+ 2.12.2; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 12:54:13 -0500, lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> On Sat, Dec 01, 2007 at 12:19:50AM +0100, J.A. Magall??n wrote:
> > I think BeOS was C++ and OSX is C+ObjectiveC (and runs on an iPhone).
> > Original MacOS (fron 6 to 9) was Pascal (and a mac SE was very near
> > to embedded hardware :) ).
> > 
> > I do not advocate to rewrite Linux in C++, but don't say a kernel written
> > in C++ can not be efficient.
> 
> Well I am pretty sure the micro kernel of OS X is in C, and certainly
> the BSD layer is as well.  So the only ObjC part would be the nextstep
> framework and other parts of the Mac GUI and other Mac APIs they
> provide, which all at some point probably end up calling down into the C
> stuff below.
> 

Yup, thanks.

> > C++ (and for what I read on other answer, nor ObjectiveC) has no garbage
> > collection. It does not anything you did not it to do. It just allows
> > you to change this
> > 
> > 	struct buffer *x;
> > 	x = kmalloc(...)
> > 	x->sz = 128
> > 	x->buff = kmalloc(...)
> > 	...
> > 	kfree(x->buff)
> > 	kfree(x)
> > 	
> > to
> > 	struct buffer *x;
> > 	x = new buffer(128); (that does itself allocates x->buff,
> >                               because _you_ programmed it,
> >                               so you poor programmer don't forget)
> >         ...
> > 	delete x;            (that also was programmed to deallocate
> >                               x->buff itself, sou you have one less
> >                               memory leak to worry about)
> 
> But kmalloc is implemented by the kernel.  Who implements 'new'?
> 

Help yourself... as kmalloc() is a replacement for userspace glibc's
malloc, you can write your replacements for functions/operators in
libstdc++ (operators are just cosmetic, as many other features in C++)
In fact, for someone who dared to write a kernel C++ framework, the
very first function he has to write could be something like:

void* operator new(size_t sz)
{
	return kmalloc(sz,GPF_KERNEL);
}

And could write alternatives like

operator new(size_t sz,int flags) -> x = new(GPF_ATOMIC) X;

operator new(size_t sz,MemPool& pl) -> x = new(pool) X;

If you are curious, this page http://www.osdev.org/wiki/C_PlusPlus
has some clues about what should you implement to get rid of
libstdc++.

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam03 (gcc 4.2.2 (4.2.2-1mdv2008.1)) SMP Sat Nov
