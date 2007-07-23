Return-Path: <linux-kernel-owner+w=401wt.eu-S935803AbXGWU3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935803AbXGWU3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765537AbXGWU3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:29:46 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:41861 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759535AbXGWU3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:29:45 -0400
Date: Mon, 23 Jul 2007 13:29:44 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 7/8] i386: bitops: Kill needless usage of __asm__
 __volatile__
In-Reply-To: <46A4F360.2000905@goop.org>
Message-ID: <Pine.LNX.4.58.0707231325050.5535@shell2.speakeasy.net>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160603.22137.16516.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A4D612.9050209@goop.org> <Pine.LNX.4.64.0707232202580.22155@cselinux1.cse.iitk.ac.in>
 <46A4E7E3.8090105@goop.org> <Pi <46A4F360.2000905@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Jeremy Fitzhardinge wrote:
> Satyam Sharma wrote:
> > The (3) as I had originally written / meant was that multiple
> > instructions in a volatile asm would not get _individually_
> > interspersed with the rest of the code i.e. be emitted out
> > _consecutively_. I don't think we need any such guarantees for
> > the non-atomic variants of those operations, so it's good to
> > let the compiler have a free hand with what it wants to do,
> > and optimize/combine multiple bitops as necessary / possible,
> > which was the original intention.
> >
>
> No, a single asm statement is always emitted in one piece.  Gcc doesn't
> parse the string other than to do %-substitution to insert arguments, so
> it has no way to meaningfully split it up.

gcc also tries to count the number of instructions, to guess how large in
bytes the asm block is, as it could make a difference for near vs short
jumps, etc.

I wonder it it also affects the instruction count the inline heuristics
use?
