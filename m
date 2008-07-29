Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbYG2IFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbYG2IFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYG2IFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:05:36 -0400
Received: from gw.goop.org ([64.81.55.164]:59685 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbYG2IFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:05:34 -0400
Message-ID: <488ECF4A.6080200@goop.org>
Date: Tue, 29 Jul 2008 01:05:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 0/4] unify arch/x86/kernel/tlb.c
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series converts tlb_32.c and _64.c to use smp_call_function_mask.  
Having done that, their underlying similarity is plainly revealed, and 
they can be easily unified.

The result is the removal of ~270 lines of code, most of which was a 
pair of open-coded versions of what smp_call_function_mask does anyway.  
The remaining code is much clearer as a result.

I've given these patches some mild testing, and nothing exploded.  I'm 
actually fairly confident in them, since all the complex subtle stuff is 
now in smp_call_function_mask, so if anything breaks, it's probably 
going to be in there.

And though I dare not touch it, Voyager could probably be converted to 
use this code fairly simply as well.

    J

--
 arch/x86/kernel/Makefile      |    2 
 arch/x86/kernel/entry_64.S    |   15 --
 arch/x86/kernel/irqinit_64.c  |   10 -
 arch/x86/kernel/tlb.c         |  229 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/tlb_32.c      |  191 ----------------------------
 arch/x86/kernel/tlb_64.c      |  279 ------------------------------------------
 arch/x86/kernel/tlb_uv.c      |    5 
 include/asm-x86/irq_vectors.h |    4 
 include/asm-x86/uv/uv_bau.h   |    2 
 9 files changed, 234 insertions(+), 503 deletions(-)


