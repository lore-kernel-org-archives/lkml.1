Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbZBJPj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbZBJPj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 10:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbZBJPjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 10:39:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:55735 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbZBJPjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 10:39:46 -0500
Message-ID: <49919FA2.9050309@kernel.org>
Date: Wed, 11 Feb 2009 00:39:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 11/11] x86: implement x86_32 stack protector
References: <1234186798-16820-1-git-send-email-tj@kernel.org>	 <1234186798-16820-12-git-send-email-tj@kernel.org> <73c1f2160902100725w2503d693v5a3d1ae93ada75de@mail.gmail.com>
In-Reply-To: <73c1f2160902100725w2503d693v5a3d1ae93ada75de@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Feb 2009 15:39:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> On Mon, Feb 9, 2009 at 8:39 AM, Tejun Heo <tj@kernel.org> wrote:
>> Impact: stack protector for x86_32
>>
>> Implement stack protector for x86_32.  GDT entry 28 is used for it.
>> It's set to point to stack_canary-20 and have the length of 24 bytes.
>> CONFIG_CC_STACKPROTECTOR turns off CONFIG_X86_32_LAZY_GS and sets %gs
>> to the stack canary segment on entry.  As %gs is otherwise unused by
>> the kernel, the canary can be anywhere.  It's defined as a percpu
>> variable.
>>
>> x86_32 exception handlers take register frame on stack directly as
>> struct pt_regs.  With -fstack-protector turned on, gcc copies the
>> whole structure after the stack canary and (of course) doesn't copy
>> back on return thus losing all changed.  For now, -fno-stack-protector
>> is added to all files which contain those functions.  We definitely
>> need something better.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> Am I missing something, or does this patch not actually implement the
> offset of the start of the segment by 20 from the stack_canary
> variable?

Yeah, it seems I forgot to subtract 20 from the address.  Will prep a
patch.  Thanks for spotting it.

-- 
tejun
