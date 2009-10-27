Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZJ0S5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZJ0S5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZJ0S5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:57:04 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55517 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbZJ0S5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:57:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oSa4m04vH8PbuM8DxX8IfNp5uj2VJEy2XnPVCMnzDziaDo57N7pfkjUTJU04wPQ3Up
         dQYsYfktxed8VOmEkv7FVJC0zszd6CVNVbAVANYvwKkLcrXniuKJeSj+xvTsqZdhOgbp
         QI7RRKICf2cLHCTWZz0L00z40qpdkldHToKlI=
Message-ID: <4AE74282.2000207@gmail.com>
Date: Tue, 27 Oct 2009 11:57:06 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2
 0
References: <4AE24009.4090408@gmail.com> <dd18b0c30910261134s76274dbbj9c1904e78c2b5a38@mail.gmail.com> <21504.1256588976@turing-police.cc.vt.edu>            <4AE611B2.1030409@gmail.com> <29209.1256624599@turing-police.cc.vt.edu>
In-Reply-To: <29209.1256624599@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Mon, 26 Oct 2009 14:16:34 PDT, "Justin P. Mattock" said:
>
>    
>>      
>
> Try this instead:
>
>
>                     printk(KERN_DEBUG "trying class=%d num=%d slot=%d func=%d\n",
>                               class, num, slot, func);
>                     if ((class == 0xffffffff)) {
>                         printk(KERN_DEBUG "No device here\n");
>                         continue; /* No device at this func */
>                     }
>
> The curly brackets are important.  This version will still panic, and it will
> probably spew a lot of msgs, but we'll hopefully find out which num/slot/func
> is giving it indigestion.
>
>
>    
O.K.thanks for the test printk.
(didn't even think of putting a curly bracket in there)

here's the results from your test printk:
(this goes on for some time during boot)

[    0.000000] trying class=-1 num=31 slot=30 func=7
[    0.000000] No device here
[    0.000000] trying class=-1 num=31 slot=31 func=0
[    0.000000] No device here
[    0.000000] trying class=-1 num=31 slot=31 func=1
[    0.000000] No device here
[    0.000000] trying class=-1 num=31 slot=31 func=2
[    0.000000] No device here
[    0.000000] trying class=-1 num=31 slot=31 func=3
[    0.000000] No device here
[    0.000000] trying class=-1 num=31 slot=31 func=4
[    0.000000] No device here
[    0.000000] trying class=-1 num=31 slot=31 func=5
[    0.000000] No device here
[    0.000000] trying class=-1 num=31 slot=31 func=6
[    0.000000] No device here
[    0.000000] trying class=-1 num=31 slot=31 func=7
[    0.000000] No device here
[    0.000000] init_ohci1394_dma: finished initializing OHCI DMA
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 000000003fefd1c0 00074 (v01 APPLE   Apple00
000000A5      01000013)
[    0.000000] ACPI: FACP 000000003fefb000 000F4 (v03 APPLE   Apple00
000000A5 Loki 0000005F)


I'm going to have a look at this today, and look to
see if I can fix this.(also the guys e-mail bk@suse.de
keeps giving me a fail to send message so I took it off
for now, and then later I'll try to find that person and
update his e-mail).

Justin P. Mattock

