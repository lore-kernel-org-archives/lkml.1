Return-Path: <linux-kernel-owner+w=401wt.eu-S1759856AbXGWVcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856AbXGWVcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbXGWVb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:31:59 -0400
Received: from mail.suse.de ([195.135.220.2]:35456 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbXGWVb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:31:58 -0400
From: Andi Kleen <ak@suse.de>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH 7/8] i386: bitops: Kill needless usage of __asm__ __volatile__
Date: Mon, 23 Jul 2007 23:30:41 +0200
User-Agent: KMail/1.9.1
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <46A4F360.2000905@goop.org> <Pine.LNX.4.58.0707231325050.5535@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0707231325050.5535@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707232330.41876.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> gcc also tries to count the number of instructions, to guess how large in
> bytes the asm block is, as it could make a difference for near vs short
> jumps, etc.

Are you sure? I doubt it. It would need a full asm parser to do this
properly and then even it could be wrong 
(e.g. when the sections are switched like Linux does extensively)  

gcc doesn't have such a parser.

Also on x86 gcc doesn't need to care about long/short anyways because
the assembler takes care of this and the other instructions who cared
about this (loop) isn't generated anymore.

You're probably confusing it with some other compiler, who sometimes
do this. e.g. the Microsoft inline asm syntax requires assembler parsing
in the compiler.

> I wonder it it also affects the instruction count the inline heuristics
> use?

AFAIK it counts like one operand.

-Andi
