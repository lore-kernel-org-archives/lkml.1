Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbXGZBWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbXGZBWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 21:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbXGZBWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 21:22:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708AbXGZBWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 21:22:41 -0400
Date: Wed, 25 Jul 2007 18:22:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
 unnecessarily
In-Reply-To: <alpine.LFD.0.999.0707251811130.3442@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707251819160.3442@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A578A1.5010504@yahoo.com.au> <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in>
 <46A5A929.4020706@yahoo.com.au> <Pine.LNX.4.58.0707240058370.30561@shell4.speakeasy.net>
 <alpine.LFD.0.999.0707241236020.3607@woody.linux-foundation.org>
 <Pine.LNX.4.58.0707251731370.30561@shell4.speakeasy.net>
 <alpine.LFD.0.999.0707251811130.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Jul 2007, Linus Torvalds wrote:
> 
> Hmm. I really think you should take this up with the gcc people. That 
> looks like a gcc bug - because there really is nothing that guarantees 
> that the asm doesn't change the array that "x" points to, and the asm 
> clearly talks about clobbering memory.

Actually, I take that back. I think gcc does the right thing, and yes, 
it's explained by the memory clobber being just a blind "write to memory" 
rather than read memory. My bad.

It does leave us with very few ways of saying that an asm can *read* 
memory, and so it might be good to have it clarified that "volatile" 
implies that (at least with the memory clobber).

Your examples are good, I think.

		Linus
