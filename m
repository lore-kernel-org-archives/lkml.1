Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbXGXVcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbXGXVcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbXGXVcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:32:06 -0400
Received: from gw.goop.org ([64.81.55.164]:58041 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbXGXVcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:32:05 -0400
Message-ID: <46A66F9E.1030509@goop.org>
Date: Tue, 24 Jul 2007 14:31:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Trent Piepho <xyzzy@speakeasy.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered unnecessarily
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in> <46A578A1.5010504@yahoo.com.au> <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in> <46A5A929.4020706@yahoo.com.au> <Pine.LNX.4.58.0707240058370.30561@shell4.speakeasy.net> <alpine.LFD.0.999.0707241236020.3607@woody.linux-foundation.org> <p73myxlsfl4.fsf@bingen.suse.de> <alpine.LFD.0.999.0707241304560.3607@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707241304560.3607@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Sure, that's *one* thing that "volatile" guarantees (it guarantees that 
> gcc won't optimize away things where the end result isn't actually visibly 
> used).
>
> But gcc docs also talk about the other things volatile means, including 
> "not significantly moved".
>   

Actually, it doesn't.  In fact it goes out of its way to say that "asm
volatile" statements can be moved quite a bit, with respect to other
asms, other code, jumps, basic blocks, etc.  The only reliable way to
control the placement of an asm is have the right dependencies.

    The `volatile' keyword indicates that the instruction has important
    side-effects.  GCC will not delete a volatile `asm' if it is reachable.
    (The instruction can still be deleted if GCC can prove that
    control-flow will never reach the location of the instruction.)  Note
    that even a volatile `asm' instruction can be moved relative to other
    code, including across jump instructions.

also:

    An `asm' instruction without any output operands will be treated
    identically to a volatile `asm' instruction.

So there isn't anything very special about "asm volatile".  It's purely
to stop apparently useless code from being removed.

    J
