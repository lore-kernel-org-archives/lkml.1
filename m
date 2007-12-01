Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbXLABLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbXLABLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 20:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbXLABLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 20:11:35 -0500
Received: from smtp.ono.com ([62.42.230.12]:29600 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755105AbXLABLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 20:11:34 -0500
Date: Sat, 1 Dec 2007 02:09:34 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071201020934.4f94e94f@werewolf>
In-Reply-To: <20071201003119.GB8181@ftp.linux.org.uk>
References: <474EAD18.6040408@stellatravel.co.uk>
	<9b06e8d20711300229r1ed570bfi9ecbb6466fd0a0ab@mail.gmail.com>
	<20071201001950.11100a32@werewolf>
	<20071201003119.GB8181@ftp.linux.org.uk>
X-Mailer: Claws Mail 3.1.0cvs44 (GTK+ 2.12.2; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2007 00:31:19 +0000, Al Viro <viro@ftp.linux.org.uk> wrote:

> On Sat, Dec 01, 2007 at 12:19:50AM +0100, J.A. Magall??n wrote:
> > An vtable in C++ takes exactly the same space that the function
> > table pointer present in every driver nowadays... and probably
> > the virtual method call that C++ does itself with
> > 
> > 	thing->do_something(with,this)
> > 
> > like
> > 	push thing
> > 	push with
> > 	push this
> > 	call THING_vtable+indexof(do_something) // constants at compile time
> 
> This is not what vtables are.  Think for a minute - all codepaths arriving
> to that point in your code will pick the address to call from the same
> location.  Either the contents of that location is constant (in which case
> you could bloody well call it directly in the first place) *or* it has to
> somehow be reassigned back and forth, according to the value of this.  The
> former is dumb, the latter - outright insane.
> 
> The contents of vtables is constant.  The whole point of that thing is
> to deal with the situations where we _can't_ tell which derived class
> this ->do_something() is from; if we could tell which vtable it is at
> compile time, we wouldn't need to bother at all.
> 

Yup, my mistake (that's why I said i will learn something). I was thinking
on non-virtual methods. For virtual ones you have to fetch the vtable
start address and index from it.

> It's a tradeoff - we pay the extra memory access (fetch vtable pointer, then 
> fetch method from vtable) for not having to store a slew of method pointers
> in each instance of base class.  But the extra memory access is very much
> there.  It can be further optimized away if you have several method calls
> for the same object next to each other (then vtable can be picked once),
> but it's still done at runtime.

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam03 (gcc 4.2.2 (4.2.2-1mdv2008.1)) SMP Sat Nov
09 F9 11 02 9D 74 E3 5B D8 41 56 C5 63 56 88 C0
