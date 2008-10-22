Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYJVMs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYJVMs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYJVMr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:47:59 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:60520 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbYJVMr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:47:58 -0400
Message-ID: <48FF20F6.1040505@fr.ibm.com>
Date: Wed, 22 Oct 2008 14:47:50 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrey Mirkin <major@openvz.org>
CC: devel@openvz.org, Pavel Emelyanov <xemul@openvz.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [PATCH 08/10] Introduce functions to restart a process
References: <1224285098-573-1-git-send-email-major@openvz.org> <1224285098-573-9-git-send-email-major@openvz.org> <48FC4E0C.7050008@fr.ibm.com> <200810221249.55600.major@openvz.org>
In-Reply-To: <200810221249.55600.major@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +ENTRY(i386_ret_from_resume)
>>> +	CFI_STARTPROC
>>> +	pushl %eax
>>> +	CFI_ADJUST_CFA_OFFSET 4
>>> +	call schedule_tail
>>> +	GET_THREAD_INFO(%ebp)
>>> +	popl %eax
>>> +	CFI_ADJUST_CFA_OFFSET -4
>>> +	movl (%esp), %eax
>>> +	testl %eax, %eax
>>> +	jz    1f
>>> +	pushl %esp
>>> +	call  *%eax
>>> +	addl  $4, %esp
>>> +1:
>>> +	addl  $256, %esp
>>> +	jmp   ret_from_fork_tail
>>> +	CFI_ENDPROC
>>> +END(i386_ret_from_resume)
>> Could you explain why you need to do this
>>
>> 	call  *%eax
>>
>> is it related to the freezer code ?
> 
> It is not related to the freezer code actually.
> That is needed to restart syscalls. Right now I don't have a code in my 
> patchset which restarts a syscall, but later I plan to add it.
> In OpenVZ checkpointing we restart syscalls if process was caught in syscall 
> during checkpointing.

ok. I get it now. why 256 bytes of extra stack ? I'm sure it's not random. 

Thanks,

C.
