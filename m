Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbXFAARQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbXFAARQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 20:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbXFAARF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 20:17:05 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.133]:52356 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbXFAARE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 20:17:04 -0400
Date: Thu, 31 May 2007 17:16:35 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 2/5] console: console handover to preferred console
In-reply-to: <20070531170200.3738f834.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <465F6563.7060804@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=US-ASCII
Content-transfer-encoding: 7BIT
References: <200705311358.26559.yinghai.lu@sun.com>
 <20070531170200.3738f834.akpm@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 31 May 2007 13:58:26 -0700
> Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
>> [PATCH 2/5] console: console handover to preferred console
>>
>> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
>>
>> diff --git a/kernel/printk.c b/kernel/printk.c
>> index 0bbdeac..7b96cae 100644
>> --- a/kernel/printk.c
>> +++ b/kernel/printk.c
>> @@ -985,12 +1007,15 @@ void register_console(struct console *console)
>>  	if (!(console->flags & CON_ENABLED))
>>  		return;
>>  
>> -	if (bootconsole) {
>> +	if (bootconsole && (console->flags & CON_CONSDEV)) {
>>  		printk(KERN_INFO "console handover: boot [%s%d] -> real [%s%d]\n",
>>  		       bootconsole->name, bootconsole->index,
>>  		       console->name, console->index);
>>  		unregister_console(bootconsole);
>>  		console->flags &= ~CON_PRINTBUFFER;
>> +	} else {
>> +		printk(KERN_INFO "console [%s%d] enabled\n",
>> +		       console->name, console->index);
>>  	}
>>  
>>  	/*
> 
> What does this change do, and what is the reason for it??

for earlyprintk=ttyS0,9600 console=tty0 console=ttyS0,9600n8

the handover will happen from earlyser0 to tty0. but what we want is to ttyS0.

later with patch4,
console=tty0 console=uart8250,io,0x3f8,9600n8
will handover to ttyS0 instead of tty0.

Maybe can put above lines into commit log.

YH

