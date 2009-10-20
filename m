Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZJTHZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZJTHZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 03:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbZJTHZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 03:25:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57727 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbZJTHZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 03:25:57 -0400
Message-ID: <4ADD65C5.5000206@zytor.com>
Date: Tue, 20 Oct 2009 16:24:53 +0900
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Jan Beulich <JBeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: adjust ia32entry branches for better static	
 prediction
References: <4ADD7E6C020000780001AD73@vpn.id2.novell.com> <4ADD64FC.3070006@gmail.com>
In-Reply-To: <4ADD64FC.3070006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2009 04:21 PM, Eric Dumazet wrote:
>>
>> --- linux-2.6.32-rc5/arch/x86/ia32/ia32entry.S	2009-10-19 13:12:43.000000000 +0200
>> +++ 2.6.32-rc5-x86_64-ia32-syscall-trace-branch-dir/arch/x86/ia32/ia32entry.S	2009-10-19 09:36:39.000000000 +0200
>> @@ -249,9 +249,9 @@ sysenter_tracesys:
>>   	call	syscall_trace_enter
>>   	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
>>   	RESTORE_REST
>> -	cmpl	$(IA32_NR_syscalls-1),%eax
>> -	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
>> -	jmp	sysenter_do_call
>> +	cmpl	$IA32_NR_syscalls,%eax
>> +	jb	sysenter_do_call
>> +	jmp	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
>>   	CFI_ENDPROC
>
> on cmov enabled build, we could use cmov instruction to load eax with number
> that calls enosys_syscall(), to avoid loading -ENOSYS,RAX
> and these branches...
>

It's x86-64, cmov is guaranteed.

	-hpa
