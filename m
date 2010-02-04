Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447Ab0BDQkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:40:06 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:61323 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325Ab0BDQkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:40:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rZYwV92ktZ3Z/CzSEgn5YGiXD7myInK1TScYUca8iXG0sKNhP8BsNS1tnnsN99mWKD
         agwurTiHB4s14c9pAdc3KT5zk0SmGeqTS5Cr5Ueq75YdClXNTjq+2iIiq6YQYAdyf4xE
         jYp5u53o5AMgdYw8r7MzNW+po644jJ52KefHE=
Message-ID: <4B6AF85C.6050104@gmail.com>
Date: Thu, 04 Feb 2010 11:39:56 -0500
From: Chandra Shekhar Sah <edu4madh@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: port multiplier problem
References: <4B5885F7.2020007@gmail.com> <4B679EA9.6030203@kernel.org>	 <4B6833DD.1020001@gmail.com> <4B683581.7070708@kernel.org>	 <4B683DEF.3000302@gmail.com>	 <da824cf31002020844r12cada26x57f96b0aa24b59c6@mail.gmail.com>	 <4B686B2B.2080406@gmail.com>	 <da824cf31002021104v72efcd05ne639091042d5999d@mail.gmail.com>	 <4B687B7C.2070406@gmail.com> <da824cf31002031837t1cf2357bsbb53a3b4ea5e671f@mail.gmail.com>
In-Reply-To: <da824cf31002031837t1cf2357bsbb53a3b4ea5e671f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

I compared PMP part with Chris dmesg and here are some similarities:
=================================
Similarity
=================================
sata_sil24 0000:03:02.0: version 1.1
sata_sil24 0000:03:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
scsi3 : sata_sil24
scsi4 : sata_sil24
scsi5 : sata_sil24
scsi6 : sata_sil24
ata3: SATA max UDMA/100 host m128@0xea009000 port 0xea000000 irq 18
ata4: SATA max UDMA/100 host m128@0xea009000 port 0xea002000 irq 18
ata5: SATA max UDMA/100 host m128@0xea009000 port 0xea004000 irq 18
ata6: SATA max UDMA/100 host m128@0xea009000 port 0xea006000 irq 18
aic7xxx 0000:03:04.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
ata3.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
ata3.00: hard resetting link
ata3.00: SATA link down (SStatus 0 SControl 10)
ata3.01: hard resetting link
ata3.01: SATA link down (SStatus 0 SControl 320)
ata3.02: hard resetting link
ata3.02: SATA link down (SStatus 0 SControl 320)
ata3.03: hard resetting link
ata3.03: SATA link down (SStatus 0 SControl 320)
ata3.04: hard resetting link
ata3.04: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.05: hard resetting link
ata3.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
ata3.04: failed to IDENTIFY (I/O error, err_mask=0x11)
===============================================

However, I got some extra errors in my case (shown below):
===============================================
ata3.04: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xf
ata3.04: SError: { PHYRdyChg DevExch }

ata3.04: PHY status changed but maxed out on retries, giving up
ata3.04: Manully issue scan to resume this link
ata3.04: exception Emask 0x10 SAct 0x0 SErr 0x4050000 action 0xf t4
ata3.04: irq_stat 0x01060002, failed to transmit command FIS
ata3.04: SError: { PHYRdyChg CommWake DevExch }
ata3.04: limiting SATA link speed to 1.5 Gbps

ata4.15: hard resetting link
ata3.15: qc timeout (cmd 0xe4)
ata3.01: failed to read SCR 2 (Emask=0x4)
ata3.01: COMRESET failed (errno=-5)
ata3.01: failed to read SCR 0 (Emask=0x40)
ata3.01: reset failed, giving up

ata4.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
ata4: PMP SError.N set for some ports, repeating recovery
ata4.04: hard resetting link

ata4.15: hard resetting link
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
ata4.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)

ata4: PMP SError.N set for some ports, repeating recovery
==========================================

Chris's post remind me about the LED light. In my drives (all hot 
swappable), each has two LEDs: one for power (green light) and another 
(orange light) probably showing the activity of the drive and it is 
related with PMP because this orange light does not lit if I connect the 
drive to direct sata port (with direct sata connection, disks are 
working fine).

When the disk array was working fine (few months ago), the orange light 
lit for a very short time when the disk's power is switched on and then 
it turns off. It lit again when disk is working. However, now the orange 
light does not turn off. I saw similar thing in the manual of sil3726 
PMP, saying that some light turn off after disk is ready (I don't know 
which light).

Thanks,
CN


On 2/3/10 9:37 PM, Grant Grundler wrote:
> On Tue, Feb 2, 2010 at 11:22 AM, Chandra Shekhar Sah<edu4madh@gmail.com>  wrote:
>    
>> Hi Grant,
>>
>> Thank for reply.
>> Yes, PMP is sil3726. The backplane of the disk array has two PMP (each
>> 1-to-5 as you have mentioned) and two sata direct connection without PMP.
>> So, 10 disk are behind 2 PMP.
>>      
> Ah ok. That explains your "5-5-1-1" comment now. I tried to find a
> Data sheet for this board but only found one in Chinese:
>      www.norco.com.cn/UpLoadFile/Manual/DS-12X0-CN.pdf
>
> and I unfortunately don't speak/read chinese. Probably doesn't matter
> though since...
>
> This email thread looks like a duplicate of a previous bug report:
>     http://markmail.org/message/lp3ynvfefejpiy2r
>
> (or search for  "Ubuntu 9.04 (2.6.28-14) and eSATA Port Multiplier
> (PMP) Not working")
>
> Chandra, you might read through that thread and dmesg output (posted by Chris K)
> to see what else you have in common.
>
> I had two questions on that thread that never got answered:
>     http://markmail.org/message/snpekoj4qexrslk5
>
> | How can we find out if anyone has the SEMB properly wired up?
> | Would it be hard to make libata aware of "SEMB port not responding" case?
> | ie if the SEMB port times out or has no link, reduce the port count of
> | the sil3726 PMP by one.
> |
> | Maybe add a "enable_sil24_semb" flag to libata?
> | (avoid checking unless someone asks for it). I hate magic flags but also
> | don't want to subject most people to the timeout delay.
>
> I (or Gwendal) can post a patch (and lightly test) for any of the above.
> Just need to get some guidance so we don't waste our time.
>
> thanks,
> grant
>
>    
>> Total is 12 disks. The sata host controller is
>> sil3124. Picture of the backplane is attached.
>>
>> Thanks,
>> Chandra
>>
>> On 2/2/10 2:04 PM, Grant Grundler wrote:
>>      
>>> On Tue, Feb 2, 2010 at 10:12 AM, Chandra Shekhar Sah<edu4madh@gmail.com>
>>>   wrote:
>>>
>>>        
>>>> Hi Grant,
>>>>
>>>> There are 6 Seagate Barracuda and 6 Hitachi DeskStar.
>>>>
>>>>          
>>> I thought 0x1095/0x3726 was a Silicon Image part. Can you confirm this?
>>>
>>> If it is, this sounds like a broken implementation to me. Here is what
>>> the Silicon Image 3726 Data Sheet says in the introduction:
>>>      Silicon Image’s SiI3726 is 1-to-5 SATA Port Multiplier designed to
>>> provide a high performance link between a single SATA host port and 5
>>> SATA device ports.
>>>
>>> So I don't know where the 6th device is getting connected. Some
>>> explanation/data sheet from the HW vendor would be helpful at this
>>> point.
>>>
>>>
>>>        
>>>> Seagate Model: ST3750640AS
>>>> Firmware: 3.AAK
>>>>
>>>> Hitachi Model:HDS721075KLA330
>>>> Firmware: Not sure
>>>>
>>>>          
>>> Both of these drives work behind Sil3726. (First hand experience).
>>>
>>>
>>>        
>>>> I have attached pictures of both labels, in case.
>>>>
>>>>          
>>> Perfect - thanks for posting those.
>>>
>>> thanks,
>>> grant
>>>
>>>
>>>        
>>
>>      
>    

