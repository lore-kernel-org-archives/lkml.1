Return-Path: <linux-kernel-owner+w=401wt.eu-S1759704AbZEGP0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704AbZEGP0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZEGP0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:26:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50701 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbZEGP0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:26:07 -0400
Message-ID: <4A02FD8D.50002@redhat.com>
Date: Thu, 07 May 2009 18:26:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>, viro@ZenIV.linux.org.uk,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A0175F0.1090705@novell.com> <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com> <4A01AEC1.8020201@novell.com> <alpine.DEB.1.10.0905061834080.32606@makko.or.mcafeemobile.com> <4A02AE65.3000800@redhat.com> <20090507134607.GA25311@amt.cnet> <4A02E9C5.7020704@novell.com> <4A02F160.7080907@redhat.com> <4A02F63B.60104@novell.com>
In-Reply-To: <4A02F63B.60104@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:

  

>> This is my preferred option.  For a virtio-net-server in the kernel,
>> we'd service its eventfd in qemu, raising and lowering the pci
>> interrupt in the traditional way.
>>
>> But we'd still need to know when to lower the interrupt.  How?
>>     
>
> IIUC, isn't that  usually device/subsystem specific, and out of scope of
> the GSI delivery vehicle?  For instance, most devices I have seen with
> level ints have a register in their device register namespace for acking
> the int.  

Yes it is.

> As an aside, this is what causes some of the grief in dealing
> with shared interrupts like KVM pass-through and/or threaded-isrs:  
> There isn't a standardized way to ACK them.
>   

So we'd need a side channel to tell userspace to lower the irq.  Another 
eventfd likely.

Note we don't support device assignment for devices with shared interrupts.

> You may also see some generalization of masking/acking in things like
> the MSI-X table.  But again, this would be out of scope of the general
> GSI delivery path IIUC.
>
> I understand that there is a feedback mechanism in the ioapic model for
> calling back on acknowledgment of the interrupt.  But I am not sure what
> is how the real hardware works normally, and therefore I am not
> convinced that is something we need to feed all the way back (i.e. via
> irqfd or whatever).  In the interest of full disclosure, its been a few
> years since I studied the xAPIC docs, so I might be out to lunch on that
> assertion. ;)
>   

Right, that ack thing is completely internal, used for catching up on 
time drift, and for shutting down level triggered assigned interrupts.

-- 
error compiling committee.c: too many arguments to function

