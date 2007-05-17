Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbXEQBjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbXEQBjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 21:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbXEQBjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 21:39:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:49753 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbXEQBjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 21:39:45 -0400
Message-ID: <464BB252.8010008@cv-sv.de>
Date: Thu, 17 May 2007 03:39:30 +0200
From: Christian <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.2) Gecko/20070218 SUSE/1.1.1-5.1 SeaMonkey/1.1.1
MIME-Version: 1.0
CC: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com>
In-Reply-To: <20070517004209.GE16810@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19amNADcxeNxRUfLUrSMkAwscGCbG7jeRDvzw1
 uZNbBzMvwVqWiCtGtByhXwz1xDu06E60dp3De04u0glQQyg+WJ
 3UM9Jc32WgkW2+/bxMYhw==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> The C3s all have cx8, but it needs to be enabled in an MSR first.
> (See arch/i386/kernel/cpu/centaur.c , search for CX8)
> 
> Did we add code that uses cmpxchg8b before identify_cpu() gets run ?
> I've not been paying attention to .22rc (busy trying to beat .21 into shape for F7)
> so I may have missed something obvious. Andi?
> 
> 	Dave
> 

May I brought up a wrong reason with the command cmpxchg64.
But disabling CONFIG_X86_CMPXCHG64 helps.


The via C3 EBGA datasheet R1.9 tells me this command works always:
>The CMPXCHG8B instruction is provided and always enabled, however, it appears disabled in the corresponding
>CPUID function bit 0 to avoid a bug in an early version of Windows NT. However, this default can be changed
>via a bit in the FCR MSR.


Hmm, I should be able to add a few small "here I am" to
the my local boot code with a little hint.

Anyway I will try tomorrow to find this on my own.
printfs for debugging are more friendly than assembler.

H. Peter Anvin wrote:
> Andi added code to verify that we can actually execute on the processor
> before protected mode (so we can still get a message out through the
> BIOS.)  That code presumably doesn't know of the MSR that needs to be
> touched.


Best regards,

Christian
