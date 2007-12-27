Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbXL0Boo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbXL0Boo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 20:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXL0Bof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 20:44:35 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:47128 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbXL0Boe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 20:44:34 -0500
Date: Thu, 27 Dec 2007 02:44:33 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Pavel Machek <pavel@ucw.cz>, Julia Lawall <julia@diku.dk>,
       tglx@linutronix.de, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] arch/x86: Use offsetof
In-Reply-To: <4772F972.7070802@zytor.com>
Message-ID: <Pine.LNX.4.64.0712270243370.32714@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.58.0712261712450.1185@pc-041.diku.dk>
 <20071226194718.GB8844@elf.ucw.cz> <4772F972.7070802@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 26 2007 17:01, H. Peter Anvin wrote:
>> > @@ -215,7 +215,9 @@ asmlinkage int sys_vm86old(struct pt_reg
>> >   ret = -EFAULT;
>> >   if (tmp)
>> > 		goto out;
>> > -	memset(&info.vm86plus, 0, (int)&info.regs32 - (int)&info.vm86plus);
>> > +	memset(&info.vm86plus, 0,
>> > +	       offsetof(struct kernel_vm86_struct, regs32) -
>> > +	       offsetof(struct kernel_vm86_struct, vm86plus));
>> 
>> I do not think this makes it more readable... (int) -> (char *) would
>> make it portable and readable, AFAICT.
>>         Pavel
>
> The right way to do it is:
>
> 	memset(&info.vm86plus, 0, sizeof info.vm86plus);

Either way, downcasting a pointer to (int) is dangerous,
even if this one occurrence happens to be in 32-bit-only code.
