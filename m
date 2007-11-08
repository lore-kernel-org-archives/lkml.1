Return-Path: <linux-kernel-owner+w=401wt.eu-S1761636AbXKHQlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761636AbXKHQlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759989AbXKHQlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 11:41:03 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46713 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbXKHQlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 11:41:01 -0500
Message-ID: <47333C0C.7020705@us.ibm.com>
Date: Thu, 08 Nov 2007 10:40:44 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Avi Kivity <avi@qumranet.com>,
       Gregory Haskins <gregory.haskins.ml@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Use of virtio device IDs
References: <4730A15A.6070001@us.ibm.com> <4730B753.2000901@us.ibm.com> <4731334A.6090405@gmail.com> <47314FBD.1070505@qumranet.com> <47322262.8000101@gmail.com> <4732AE9A.4070701@qumranet.com> <4732D439.3020703@redhat.com>
In-Reply-To: <4732D439.3020703@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
> Avi Kivity wrote:
>   
>>> You are
>>> probably better off designing something that is PV specific instead of
>>> shoehorning it in to fit a different model (at least for the things I
>>> have in mind).  
>>>       
>> Well, if we design our pv devices to look like hardware, they will fit
>> quite well.  Both to the guest OS and to user's expectations.
>>     
>
> Disclaimer: Havn't looked at the virtio code much.
>
> I think we should keep the door open for both models and don't nail the
>  virtio infrastructure to one of them.
>
> For pure pv devices I don't see the point in trying to squeeze it into
> the PCI model.  Also s390 has no PCI, so there effecticely is no way
> around that, we must be able have some pure virtual bus like xenbus.
>   

I don't really agree with this assessment.  There is no performance 
advantage to using a pure virtual bus.  If you have a pure pv device 
that looks and act like a PCI device, besides the obvious advantage of 
easy portability to other guest OSes (since everything support PCI, but 
porting XenBus--event to Linux 2.4.x was a royal pain), it is also very 
easy to support the device on other VMMs.

For instance, the PCI device that I just posted would allow virtio 
devices to be used trivially with HVM on Xen.  In fact, once the 
backends are complete and merged into QEMU, the next time Xen rebases 
QEMU they'll get the virtio PV-on-HVM drivers for free.  To me, that's a 
pretty significant advantage.

> Uhm, well, yea.  Guess you are refering to the pv-on-hvm drivers.  Been
> there, dealt with it.  What exactly do you think is messy there?
>
> IMHO the most messy thing is the boot problem.  hvm bios can't deal with
> pv disks, so you can't boot with pv disks only.  "fixed" by having the
> (boot) disk twice in the system, once via emulated ide, once as pv disk.
>  Ouch.
>   

I have actually addressed this problem with a PV option rom for QEMU.  I 
expect to get time to submit the QEMU patches by the end of the year.  
See http://hg.codemonkey.ws/extboot

Regards,

Anthony Liguori
