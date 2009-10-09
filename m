Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbZJINbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbZJINbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 09:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760685AbZJINbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 09:31:16 -0400
Received: from omr8.networksolutionsemail.com ([205.178.146.58]:41878 "EHLO
	omr8.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760342AbZJINbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 09:31:16 -0400
Message-Id: <449C2FDE-42DD-490C-8288-CF03224BDA34@kayser.net>
From: Donald Kayser <linux@kayser.net>
To: linuxkernel <linux-kernel@vger.kernel.org>
In-Reply-To: <7AD77164-8476-4138-A390-B604CD18A221@kayser.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: ppc_md.SMI replacement for 2.6
Date: Fri, 9 Oct 2009 08:30:30 -0500
References: <61241B44-32BD-4708-954F-AEE7560382DE@kayser.net> <7AD77164-8476-4138-A390-B604CD18A221@kayser.net>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On further comparison, this section of code has been added by the  
vendor that actually ported linux 2.4 to this PPC HPPB target. So, if  
anyone would like to lend a thought towards System Managment  
Exceptions on PPC, please cc me at linux@kayser.net. I will be  
stopping the subscription to this list shortly. Regards, Donald

On Oct 8, 2009, at 8:37 AM, Donald Kayser wrote:

> I have found the differences between the 2.4 and 2.6 kernel. It is  
> in linux-2.4/arch/ppc/kernel/traps.c and linux-2.6/arch/powerpc/ 
> kernel/traps.c in the function SMIException(). There is no longer  
> the code segment
>
> if (ppc_md.SMI)
> {
>  ppc_md.SMI(regs);
>  return;
> }
>
> There is now only a
>
> die("System Management Interrupt", regs, SIGABRT);
>
> I am guessing that the SMI callback is no longer needed by the linux  
> community at large, so I modified the code for my specific hardware  
> (HPPB) and acknowledged the exception as in the 2.4 kernel, and  
> returned from the exception without the call to die(). My problem  
> now is that it doesn't seem to work. Does anyone have a reason why  
> the SMI exception might hang the system when it has been provided a  
> handler?
>
> Thanks in advance.
>
> Donald Kayser
>
> On Oct 7, 2009, at 10:06 AM, Donald Kayser wrote:
>
>> I have ported the 2.6 kernel to an embedded PPC target (old stuff).  
>> I have managed to figure everything out, but can't find any  
>> replacement for a SMI handler. The original 2.4 version for this  
>> target has a bit of code ppc_md.SMI == SmiFuncHandler; I have not  
>> been able to find in the current source anything like this. I am  
>> not certain that I need to provide a handler at all, but the  
>> original developers saw some reason for including it. The  
>> particular handler does not do anything more than cancel a watchdog  
>> listener for this specific target. I have been living without the  
>> handler, but would like to find any kind of replacement if it is  
>> supported.
>>
>> Thanks,
>> Donald Kayser
>> linux@kayser.net
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

