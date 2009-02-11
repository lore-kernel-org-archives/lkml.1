Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZBKOPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZBKOPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbZBKOP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:15:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:60509 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbZBKOP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:15:27 -0500
Message-ID: <4992DD63.5080308@kernel.org>
Date: Wed, 11 Feb 2009 23:14:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that	need
 it
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com> <1234277507-4987-3-git-send-email-brgerst@gmail.com> <4992812B.1050800@kernel.org> <20090211101846.GH20518@elte.hu>
In-Reply-To: <20090211101846.GH20518@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Feb 2009 14:15:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
>> Hello, Brian.
>>
>> Brian Gerst wrote:
>>> Some syscalls need to access the pt_regs structure, either to copy
>>> user register state or to modifiy it.  This patch adds stubs to load
>>> the address of the pt_regs struct into the %eax register, and changes
>>> the syscalls to regparm(1) to receive the pt_regs pointer as the
>>> first argument.
>> Heh... neat.  Just one question.
>>
>>> -asmlinkage long sys_iopl(unsigned long regsp)
>>> +ptregscall long sys_iopl(struct pt_regs *regs, unsigned int level)
>>>  {
>>> -	struct pt_regs *regs = (struct pt_regs *)&regsp;
>>> -	unsigned int level = regs->bx;
>> Here and at other places where the function takes more than one
>> arguments, wouldn't it be better to just take *regs and use other
>> parameters from regs?  That way we won't have to worry about gcc
>> corrupting register frame at all and I think it's cleaner that way.
> 
> Hm, gcc cannot corrupt register arguments only on-stack arguments - but
> your suggestion nevertheless makes sense as an optimization. I'd suggest
> this to be done as a separate patch though, both for regression analysis
> reasons (easier to bisect - the patch is large enough already) and from
> a size/performance analysis POV. (so we can see the benefits in isolation)

ptregscall is regparm(1) so arguments are on-stack from the second
one, so the callee can corrupt them.

Thanks.

-- 
tejun
