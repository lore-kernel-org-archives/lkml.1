Return-Path: <linux-kernel-owner+w=401wt.eu-S1752330AbXL0BGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbXL0BGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 20:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbXL0BF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 20:05:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45607 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbXL0BF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 20:05:58 -0500
Message-ID: <4772F972.7070802@zytor.com>
Date: Wed, 26 Dec 2007 17:01:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Julia Lawall <julia@diku.dk>, tglx@linutronix.de, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] arch/x86: Use offsetof
References: <Pine.LNX.4.58.0712261712450.1185@pc-041.diku.dk> <20071226194718.GB8844@elf.ucw.cz>
In-Reply-To: <20071226194718.GB8844@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>>
>> diff -u -p a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
>> --- a/arch/x86/kernel/vm86_32.c	2007-10-22 11:25:00.000000000 +0200
>> +++ b/arch/x86/kernel/vm86_32.c	2007-12-26 16:27:15.000000000 +0100
>> @@ -215,7 +215,9 @@ asmlinkage int sys_vm86old(struct pt_reg
>>  	ret = -EFAULT;
>>  	if (tmp)
>>  		goto out;
>> -	memset(&info.vm86plus, 0, (int)&info.regs32 - (int)&info.vm86plus);
>> +	memset(&info.vm86plus, 0,
>> +	       offsetof(struct kernel_vm86_struct, regs32) -
>> +	       offsetof(struct kernel_vm86_struct, vm86plus));
> 
> I do not think this makes it more readable... (int) -> (char *) would
> make it portable and readable, AFAICT.
> 								Pavel

The right way to do it is:

	memset(&info.vm86plus, 0, sizeof info.vm86plus);

	-hpa
