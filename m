Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYILMgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYILMgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 08:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYILMf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 08:35:57 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:64864 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYILMf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 08:35:56 -0400
Message-ID: <48CA60FC.8050501@linux.vnet.ibm.com>
Date: Fri, 12 Sep 2008 14:30:52 +0200
From: Pierre Morel <pmorel@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, gregkh@suse.de,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Cedric Le Goater <clg@fr.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 1/1] system call notification with self_ptrace
References: <48C51439.7000706@linux.vnet.ibm.com> <1221063574.6781.8.camel@nimitz>
In-Reply-To: <1221063574.6781.8.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Dave Hansen wrote:
> On Mon, 2008-09-08 at 14:02 +0200, Pierre Morel wrote:
>   
>> +       if (is_self_ptracing(regs->gprs[2])) {
>> +               if (!entryexit) {
>> +                       struct siginfo info;
>> +
>> +                       memset(&info, 0, sizeof(struct siginfo));
>> +                       info.si_signo = SIGSYS;
>> +                       info.si_code = SYS_SYSCALL;
>> +                       info.si_errno = regs->gprs[2];
>> +                       info.si_addr = (void *)regs->orig_gpr2;
>> +                       send_sig_info(SIGSYS, &info, current);
>> +                       regs->gprs[2] = -1;
>> +               }
>> +               return;
>> +       }
>>     
>
> I see you didn't like my suggestions for consolidating some of these
> repetitive code bits across all the architectures.  Did you give that a
>   
I have read your suggestion, but the actual ptrace() implementation uses 
explicit reference to the different architecture dependent registers and 
I think that this portion of code is more readable if the patch keeps 
the actual conventions used by Roland.
> a shot?  Would you like me to produce a patch on top of what you have
> here before this gets merged into mm?
>   
No Dave, thank you.

regards,

Pierre

> -- Dave
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   


-- 
=============
Pierre Morel
RTOS and Embedded Linux

