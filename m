Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZEXS7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZEXS7Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 14:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZEXS7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 14:59:16 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:54831 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbZEXS7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 14:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cOe1lp4QakvGx2O+CiEiRP1lrsvmnKhjfHP4ry4NLfwndpa7UgxI1StxkS+yPFEXyT
         8N1dWVOFhCuG3q1dGWwF3NTb2Ix9N7vd8W+qiFuHM0NLmrYjve4dCAKXgHuskMA2fHbU
         3srjyXcR6v0+Y917Iah8WA0CT+Up/thbpMS1M=
Message-ID: <4A199902.2080705@gmail.com>
Date: Sun, 24 May 2009 12:59:14 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: lkml@MoreThan.org
CC: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
References: <200905221139.26941.lkml@morethan.org> <200905221453.41895.lkml@morethan.org> <20090522200536.GZ10166@const.famille.thibault.fr> <200905221532.43775.lkml@morethan.org>
In-Reply-To: <200905221532.43775.lkml@morethan.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick wrote:
> On Fri May 22 2009, Samuel Thibault wrote:
>> Michael S. Zick, le Fri 22 May 2009 14:53:39 -0500, a écrit :
>>> Ref: http://developer.intel.com/Assets/PDF/manual/253666.pdf
>>> Manual page: 3-590  PDF page: 638
>>> Summary: Processors prior to P-4 can take an interrupt between
>>> the read cycle and the write cycle. Which is why opcode 0xF0 exists.
>> Where do you see page 638/639 talking about interrupts?  It talks about
>> multi-processor machines.
>>
> 
> No - it talks about "exclusive memory access" - You got bus master DMA
> in your test machine? You also have an older than P-4 single processor?

It means that LOCK is required in multi-processor environment to ensure 
that an instruction executes atomically WRT memory operations being done 
on other CPUs. On a single processor, except for some weird exceptions 
(like rep instructions, which can't be LOCKed anyways), instructions are 
always atomic with respect to interrupts.

> 
> Look people, I just reported what I found from testing - 
> Please don't shoot the messanger.
> 
> If it: "Does not make a difference" then it "Should not make a difference"
> but it does, try it yourself.  Its safe (if LOCK_PREFIX is in the proper
> places) - the machine will ignore the opcode if is recent enough to not
> need it - just trust the cpu's micro-code.

What do you mean "recent enough to not need it?" There is no such thing. 
On any x86 machine it does something. It will slow things down, and 
there is no reason it should be required on uni-processor systems.

Quite likely that's the only effect adding the LOCK prefix is having, 
slowing things down, and covering up whatever is causing your issue, 
without having anything to do with the root cause.

> 
> Mike
>> Samuel
>>
>>
> 
> 

