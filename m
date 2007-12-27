Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbXL0B4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbXL0B4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 20:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbXL0B4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 20:56:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37513 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbXL0B4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 20:56:34 -0500
Message-ID: <477304C3.9060409@zytor.com>
Date: Wed, 26 Dec 2007 17:49:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Pavel Machek <pavel@ucw.cz>, Julia Lawall <julia@diku.dk>,
       tglx@linutronix.de, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] arch/x86: Use offsetof
References: <Pine.LNX.4.58.0712261712450.1185@pc-041.diku.dk> <20071226194718.GB8844@elf.ucw.cz> <4772F972.7070802@zytor.com> <Pine.LNX.4.64.0712270243370.32714@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0712270243370.32714@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Dec 26 2007 17:01, H. Peter Anvin wrote:
>>>> @@ -215,7 +215,9 @@ asmlinkage int sys_vm86old(struct pt_reg
>>>>   ret = -EFAULT;
>>>>   if (tmp)
>>>> 		goto out;
>>>> -	memset(&info.vm86plus, 0, (int)&info.regs32 - (int)&info.vm86plus);
>>>> +	memset(&info.vm86plus, 0,
>>>> +	       offsetof(struct kernel_vm86_struct, regs32) -
>>>> +	       offsetof(struct kernel_vm86_struct, vm86plus));
>>> I do not think this makes it more readable... (int) -> (char *) would
>>> make it portable and readable, AFAICT.
>>>         Pavel
>> The right way to do it is:
>>
>> 	memset(&info.vm86plus, 0, sizeof info.vm86plus);
> 
> Either way, downcasting a pointer to (int) is dangerous,
> even if this one occurrence happens to be in 32-bit-only code.

Actually, it would be safe (although stupid) in this case since the 
difference would still be 32 bits or less.

Doesn't make it any less wrong.

	-hpa
