Return-Path: <linux-kernel-owner+w=401wt.eu-S1765067AbXGWVso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765067AbXGWVso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbXGWVse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:48:34 -0400
Received: from alnrmhc15.comcast.net ([204.127.225.95]:47821 "EHLO
	alnrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbXGWVsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:48:32 -0400
Subject: Re: [PATCH 7/8] i386: bitops: Kill needless usage of __asm__
	__volatile__
From: Nicholas Miell <nmiell@comcast.net>
To: Andi Kleen <ak@suse.de>
Cc: Trent Piepho <xyzzy@speakeasy.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200707232330.41876.ak@suse.de>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <46A4F360.2000905@goop.org>
	 <Pine.LNX.4.58.0707231325050.5535@shell2.speakeasy.net>
	 <200707232330.41876.ak@suse.de>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 14:48:28 -0700
Message-Id: <1185227309.2763.5.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 23:30 +0200, Andi Kleen wrote:
> > gcc also tries to count the number of instructions, to guess how large in
> > bytes the asm block is, as it could make a difference for near vs short
> > jumps, etc.
> 
> Are you sure? I doubt it. It would need a full asm parser to do this
> properly and then even it could be wrong 
> (e.g. when the sections are switched like Linux does extensively)  
> 
> gcc doesn't have such a parser.
> 
> Also on x86 gcc doesn't need to care about long/short anyways because
> the assembler takes care of this and the other instructions who cared
> about this (loop) isn't generated anymore.
> 
> You're probably confusing it with some other compiler, who sometimes
> do this. e.g. the Microsoft inline asm syntax requires assembler parsing
> in the compiler.
> 
> > I wonder it it also affects the instruction count the inline heuristics
> > use?
> 
> AFAIK it counts like one operand.
> 
> -Andi

GCC counts newlines and semicolons and uses that number as the likely
instruction count.

See asm_insn_count() in gcc/gcc/final.c

-- 
Nicholas Miell <nmiell@comcast.net>

