Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbYEMROm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbYEMROm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbYEMROe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:14:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:10825 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbYEMROd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=OkvgDUOx+BfvfBMpjpae5r4AqJtrj+v5YTxSJEvCRt+K41LC0o/W+d4uAeb09VyUE+YChM3QX97NlMGJgqPlratpwKsmk/neW57z05Se5ioJS2OLedOzYnID43f4BZ625+dgU5NSzUp1n3486NF6c1wIBS5ZEWGl6VjyStioKb4=
Date: Tue, 13 May 2008 21:14:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: [patch 1/2] x86: head_64.S cleanup - use straight move to CR4
	register
Message-ID: <20080513171422.GG6921@cvg>
References: <20080513165538.952646389@gmail.com>> <4829c921.0305560a.489b.07db@mx.google.com> <4829C9EE.7020306@zytor.com> <20080513170956.GF6921@cvg> <4829CBC6.2040202@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4829CBC6.2040202@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Tue, May 13, 2008 at 10:11:34AM -0700]
> Cyrill Gorcunov wrote:
>> [H. Peter Anvin - Tue, May 13, 2008 at 10:03:42AM -0700]
>>> Cyrill Gorcunov wrote:
>>>> There is no need for testing the values because we already know
>>>> what they should be. Just set them in straight way.
>>> He isn't testing them, he's setting individual bits.
>>>
>>> Either of these is pretty silly; the right way to do this is:
>>>
>>> 	movl	$(X86_CR4_PAE|X86_CR4_PGE), %eax
>>> 	movq	%rax, %cr4
>>>
>>> A movl in 64-bit mode zero extends.
>>>
>>> 	-hpa
>>>
>> Here is updated version
>> ---
>> [PATCH] x86: head_64.S cleanup - use straight move to CR4 register
>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>> ---
>> Index: linux-2.6.git/arch/x86/kernel/head_64.S
>> ===================================================================
>> --- linux-2.6.git.orig/arch/x86/kernel/head_64.S	2008-05-13 
>> 20:04:23.000000000 +0400
>> +++ linux-2.6.git/arch/x86/kernel/head_64.S	2008-05-13 21:08:20.000000000 
>> +0400
>> @@ -155,9 +155,7 @@ ENTRY(secondary_startup_64)
>>  	 */
>>   	/* Enable PAE mode and PGE */
>> -	xorq	%rax, %rax
>> -	btsq	$5, %rax
>> -	btsq	$7, %rax
>> +	movl	$(X86_CR4_PAE | X86_CR4_PGE), %rax
>>  	movq	%rax, %cr4
>>  
>
> Syntax error.  %eax, not %rax.
>
> 	-hpa
>


Oh my, what I'm doing... sorry
Here we go

---
[PATCH] x86: head_64.S cleanup - use straight move to CR4 register

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/head_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/head_64.S	2008-05-13 20:04:23.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/head_64.S	2008-05-13 21:12:39.000000000 +0400
@@ -155,9 +155,7 @@ ENTRY(secondary_startup_64)
 	 */
 
 	/* Enable PAE mode and PGE */
-	xorq	%rax, %rax
-	btsq	$5, %rax
-	btsq	$7, %rax
+	movl	$(X86_CR4_PAE | X86_CR4_PGE), %eax
 	movq	%rax, %cr4
 
 	/* Setup early boot stage 4 level pagetables. */

		- Cyrill -
