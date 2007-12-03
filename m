Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbXLCVjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbXLCVjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXLCVjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:39:13 -0500
Received: from smtp.ono.com ([62.42.230.12]:25250 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751914AbXLCVjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:39:12 -0500
Date: Mon, 3 Dec 2007 22:39:02 +0100
From: "J.A. =?ISO-8859-1?Q?Magall=F3n?=" <jamagallon@ono.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071203223902.1194aa69@werewolf>
In-Reply-To: <20071203211353.GA4009@1wt.eu>
References: <474EAD18.6040408@stellatravel.co.uk>
	<20071130143445.GA2310@csclub.uwaterloo.ca>
	<53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>
	<4751BE0D.3050609@argo.co.il>
	<p733aukyl8n.fsf@bingen.suse.de>
	<47539030.10600@argo.co.il>
	<20071203095022.GA28560@one.firstfloor.org>
	<4753ECA5.2010604@argo.co.il>
	<20071203211353.GA4009@1wt.eu>
X-Mailer: Claws Mail 3.1.0cvs49 (GTK+ 2.12.2; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 22:13:53 +0100, Willy Tarreau <w@1wt.eu> wrote:

...
> 
> It just depends how many times a second it happens. For instance, consider
> this trivial loop (fct is a two-function array which just return 1 or 2) :
> 
>         i = 0;
>         for (j = 0; j < (1 << 28); j++) {
>                 k = (j >> 8) & 1;
>                 i += fct[k]();
>         }
> 
> It takes 1.6 seconds to execute on my athlon-xp 1.5 GHz. If, instead of
> changing the function once every 256 calls, you change it to every call :
> 
>         i = 0;
>         for (j = 0; j < (1 << 28); j++) {
>                 k = (j >> 0) & 1;
>                 i += fct[k]();
>         }
> 
> Then it only takes 4.3 seconds, which is about 3 times slower. The number
> of calls per function remains the same (128M calls each), it's just the
> branch prediction which is wrong every time. The very few nanoseconds added
> at each call are enough to slow down a program from 1.6 to 4.3 seconds while
> it executes the exact same code (it may even save one shift). If you have
> such stupid code, say, to compute the color or alpha of each pixel in an
> image, you will certainly notice the difference.
> 
> And such poorly efficient code may happen very often when you blindly rely
> on function pointers instead of explicit calls.
> 
...
> 
> You are forgetting something very important : once you start stacking
> functions to perform the dirty work for you, you end up with so much
> abstraction that even new stupid code cannot be written at all without
> relying on them, and it's where the problem takes its roots, because
> when you need to write a fast function and you notice that you cannot
> touch a variable without passing through a slow pinhole, your fast
> function will remain slow whatever you do, and the worst of all is that
> you will think that it is normally fast and that it cannot be written
> faster.
> 

But don't forget that OOP is just another way to organize your code,
and let the language/compiler do some things you shouldn't de doing,
like fill an vtable pointer, that are error prone.

And of course everything depends on what language you choose and how
you use it.
You could write an equally effcient kernel in languages like C++,
using C++ abstractions as a high level organization, where
the fast paths could be coded the right way; we are not talking about
C# or Java, where even a sum is a call to an overloaded method.
Its the difference between doing school-book push and pops to lists,
and suddenly inventing the splice operator...

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam03 (gcc 4.2.2 (4.2.2-1mdv2008.1)) SMP Sat Nov
