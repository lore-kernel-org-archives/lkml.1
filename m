Return-Path: <linux-kernel-owner+w=401wt.eu-S1764824AbXGWQUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764824AbXGWQUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759402AbXGWQUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:20:38 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:58858 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717AbXGWQUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:20:37 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Mon, 23 Jul 2007 21:51:53 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Andi Kleen <ak@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/8] i386: bitops: Rectify bogus "Ir" constraints
In-Reply-To: <200707231810.08445.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0707232145270.22155@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160538.22137.35213.sendpatchset@cselinux1.cse.iitk.ac.in>
 <200707231810.08445.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,


On Mon, 23 Jul 2007, Andi Kleen wrote:

> On Monday 23 July 2007 18:05:38 Satyam Sharma wrote:
> > From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> > 
> > [2/8] i386: bitops: Rectify bogus "Ir" constraints
> > 
> > The "I" constraint (on the i386 platform) is used to restrict constants to
> > the 0..31 range, for use with instructions that must deal with bit numbers.
> 
> It means I or r, not I modified by r. This means either a immediate constant
> 0..31 or a register, which is correct.
> 
> % cat t18.c 
> 
> f()
> {
>         asm("xxx %0" :: "rI" (10));
>         asm("yyy %0" :: "rI" (100));
> }
> % gcc -O2 -S t18.c
> % cat t18.s
> ...
> f:
> .LFB2:
> #APP
>         xxx $10
> #NO_APP
>         movl    $100, %eax
> #APP
>         yyy %eax
> #NO_APP
>         ret
> .LFE2:
> ...


Whoa, thanks for explaining that to me -- I didn't know, obviously. I had
just written a test program that used "Ir" with an automatic variable
defined in the inline function (as is the case with these bitops) and
observed that even when I gave > 32 values, it would still work -- hence
my conclusion.

However, the patch still stands, does it not? [ I will modify the
changelog, obviously. ] The thing is that we don't want to limit
@nr to <= 31 in the first place, or am I wrong again? :-)

Thanks,
Satyam
