Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbYAIAPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbYAIAPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYAIAPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:15:00 -0500
Received: from gw.goop.org ([64.81.55.164]:36026 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYAIAO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:14:59 -0500
Message-ID: <47841194.2010208@goop.org>
Date: Tue, 08 Jan 2008 16:13:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
References: <patchbomb.1199829603@localhost> <20080108224244.GA3768@elte.hu> <20080108231226.GA10744@elte.hu> <478405DA.40303@goop.org> <20080108232803.GA19906@elte.hu> <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu>
In-Reply-To: <20080109000146.GA29095@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>>  #define __PAGE_KERNEL_EXEC						\
>> -	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
>> +	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
>>     

This shouldn't be necessary.  The old 64-bit code defined everything 
without _PAGE_GLOBAL, but then used a MAKE_GLOBAL() macro to OR it in 
later.  This seemed a bit roundabout to me, so I just put it in from the 
outset.

> btw., __PAGE_KERNEL_EXEC should probably be _PAGE_GLOBAL - but it wasnt 
> before.
>   

You mean _PAGE_KERNEL_EXEC, which is assigned to the 32-bit 
__PAGE_KERNEL_EXEC variable?  It gets ORed in when it determines that 
the processor has the global capability.

If not, I'm not sure what you mean.

    J
