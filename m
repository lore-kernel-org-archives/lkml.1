Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0BAXu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 18:50:27 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:62547 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0BAXuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 18:50:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=F+xhPqzSUbhZOTmaqW5zQ5w8/1paUBSN/XAx/I2DR0uFRdkdSL7Awcb6y0CDKUp1wt
         Zs90ffXKFpm1rvBVxjrxAhXQC68Po9sEAkFkl/1IoD+AesCdED50U0T0YD7y7CnJqPw6
         RhPDP9BlGU88WcnEre7K2pxhBofrpO1w9xrBA=
Message-ID: <4B676917.2080506@gmail.com>
Date: Mon, 01 Feb 2010 15:51:51 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Dan Carpenter <error27@gmail.com>, linux1394-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug #14487] PANIC:
 early exception 08 rip 246:10 error	ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com> <4B675534.5070107@s5r6.in-berlin.de>
In-Reply-To: <4B675534.5070107@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/10 14:27, Stefan Richter wrote:
> Justin P. Mattock wrote:
>> (as for yesterdays 0xffffffffffffffff(just experimenting)Google gives me
>> no info on the differences between 8f's to 16f's, I was under the
>> impression that it's x86_32 and x86_64 for the pci address).
>
> As Dan noted,
> 	(class == 0xffffffff || 0xffffffffffffffff)
> is always true because it is logically the same as
> 	(class == whatever) || true
>
> If you really meant
> 	class == 0xffffffff || class == 0xffffffffffffffff

yeah that's what I was going for(just to see).

> then the latter half will never become true because class is declared as
> u32 and got its value from read_pci_config() which also returns u32.
>

That's what I was afraid of. I'm guessing there probably would be a lot 
of things to change for(if this correct) u64.

> BTW, whether a PCI device is capable of accessing 32 bit bus addresses
> or also 64 bit bus addresses depends on the device, not on the CPU.
> Originally, PCI only had a 32 bit addressing model.  OHCI 1394 1.0/1.1
> implementations only deal with 32 bit local bus addresses.
>
I haven't even looked at what the device was capable of doing.


> The 'class' however is not an address but merely a register value with
> 24 bits width.  (Defined in the PCI Local Bus spec which is not freely
> available, cited in OHCI 1394 annex A.3.)  This register is read as a 32
> bits wide register from which the excess byte is later discarded.  If
> all bits read are 1, the bus:slot:function is not actually populated.

So(correct me if I'm wrong), I'm generating a 64 bit register
and the kernel is looking for a 32 bit register causing the crash.


Justin P. Mattock


