Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbXKVHbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbXKVHbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 02:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbXKVHbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 02:31:38 -0500
Received: from il.qumranet.com ([82.166.9.18]:40869 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbXKVHbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 02:31:38 -0500
Message-ID: <4745309B.8050404@qumranet.com>
Date: Thu, 22 Nov 2007 09:32:43 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Anthony Liguori <aliguori@us.ibm.com>, kvm-devel@lists.sourceforge.net,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       Eric Van Hensbergen <ericvanhensbergen@us.ibm.com>
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	 <11944900141678-git-send-email-aliguori@us.ibm.com>	 <11944900152750-git-send-email-aliguori@us.ibm.com>	 <11944900163817-git-send-email-aliguori@us.ibm.com>	 <4742F6B7.20503@qumranet.com>	<474300AD.4060509@us.ibm.com>	 <4743076F.8000105@qumranet.com> <47435CCB.1050506@us.ibm.com>	 <4743DAA4.70800@qumranet.com> <1195669377.6352.247.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1195669377.6352.247.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> On Wed, 2007-11-21 at 09:13 +0200, Avi Kivity wrote:
>
>   
>> Where the device is implemented is an implementation detail that should 
>> be hidden from the guest, isn't that one of the strengths of 
>> virtualization?  Two examples: a file-based block device implemented in 
>> qemu gives you fancy file formats with encryption and compression, while 
>> the same device implemented in the kernel gives you a low-overhead path 
>> directly to a zillion-disk SAN volume.  Or a user-level network device 
>> capable of running with the slirp stack and no permissions vs. the 
>> kernel device running copyless most of the time and using a dma engine 
>> for the rest but requiring you to be good friends with the admin.
>>
>> The user should expect zero reconfigurations moving a VM from one model 
>> to the other.
>>     
>
> I think that is pretty insightful, and indeed, is probably the only
> reason we would ever consider using a virtio based driver.
>
> But is this really a virtualization problem, and is virtio the right
> place to solve it?  Doesn't I/O hotplug with multipathing or NIC teaming
> provide the same infrastructure in a way that is useful in more than
> just a virtualization context?
>   

With the aid of a dictionary I was able to understand about half the 
words in the last sentence.  Moving from device to device using 
hotplug+multipath is complex to configure, available on only some 
guests, uses rarely-exercised paths in the guest OS, and only works for 
a few types of devices (network and block).  Having host independence in 
the device means you can change the device implementation for, say, a 
display driver (consider, for example, a vmgl+virtio driver, which can 
be implemented in userspace or tunneled via virtio-over-tcp to some 
remote display without going through userspace, without the guest 
knowing about it).

-- 
error compiling committee.c: too many arguments to function

