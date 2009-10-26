Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbZJZI2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbZJZI2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 04:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZJZI2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 04:28:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54173 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbZJZI2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 04:28:17 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jan Beulich <JBeulich@novell.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: adjust ia32entry branches for better static	 prediction
From: Andi Kleen <andi@firstfloor.org>
References: <4ADD7E6C020000780001AD73@vpn.id2.novell.com>
	<4ADD64FC.3070006@gmail.com> <4ADD65C5.5000206@zytor.com>
Date: Mon, 26 Oct 2009 09:28:21 +0100
In-Reply-To: <4ADD65C5.5000206@zytor.com> (H. Peter Anvin's message of "Tue, 20 Oct 2009 16:24:53 +0900")
Message-ID: <878weyy2xm.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 10/20/2009 04:21 PM, Eric Dumazet wrote:
>>>
>>> --- linux-2.6.32-rc5/arch/x86/ia32/ia32entry.S	2009-10-19 13:12:43.000000000 +0200
>>> +++ 2.6.32-rc5-x86_64-ia32-syscall-trace-branch-dir/arch/x86/ia32/ia32entry.S	2009-10-19 09:36:39.000000000 +0200
>>> @@ -249,9 +249,9 @@ sysenter_tracesys:
>>>   	call	syscall_trace_enter
>>>   	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
>>>   	RESTORE_REST
>>> -	cmpl	$(IA32_NR_syscalls-1),%eax
>>> -	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
>>> -	jmp	sysenter_do_call
>>> +	cmpl	$IA32_NR_syscalls,%eax
>>> +	jb	sysenter_do_call
>>> +	jmp	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
>>>   	CFI_ENDPROC
>>
>> on cmov enabled build, we could use cmov instruction to load eax with number
>> that calls enosys_syscall(), to avoid loading -ENOSYS,RAX
>> and these branches...
>>
>
> It's x86-64, cmov is guaranteed.

But it's also not necessarily faster.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
