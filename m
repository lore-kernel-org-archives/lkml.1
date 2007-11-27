Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbXK0JZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbXK0JZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbXK0JZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:25:49 -0500
Received: from il.qumranet.com ([82.166.9.18]:51112 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbXK0JZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:25:48 -0500
Message-ID: <474BE319.502@qumranet.com>
Date: Tue, 27 Nov 2007 11:27:53 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: carsteno@de.ibm.com
CC: Eric Van Hensbergen <ericvanhensbergen@us.ibm.com>,
       kvm-devel@lists.sourceforge.net, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com>	<11944900163817-git-send-email-aliguori@us.ibm.com>	<4742F6B7.20503@qumranet.com>	<474300AD.4060509@us.ibm.com>	<4743076F.8000105@qumranet.com>	<47435CCB.1050506@us.ibm.com>	<4743DAA4.70800@qumranet.com>	<4747051C.3090903@us.ibm.com> <4747122F.1070905@qumranet.com>	<474B1BF3.20901@us.ibm.com> <474BDD28.7050801@qumranet.com> <474BDEDE.6060603@de.ibm.com>
In-Reply-To: <474BDEDE.6060603@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten Otte wrote:
> Avi Kivity wrote:
>   
>> No, definitely not define a hypercall ABI.  The feature bit should say 
>> "this device understands a hypervisor-specific way of kicking.  consult 
>> your hypervisor manual and cpuid bits for further details.  should you 
>> not be satisfied with this method, port io is still available".
>>     
> ...unless you're lucky enough to be on s390 where pio is not available.
> I don't see why we'd have two different ways to talk to a virtio 
> device. I think we should use a hypercall for interrupt injection, 
> without support for grumpy old soldered pci features other than 
> HPA-style Lguest PCI bus organization. There are no devices that we 
> want to be backward compatible with.
>   

pio is useful for qemu, for example, and as a fallback against changing 
hypervisor calling conventions.  As Anthony points out, it makes a 
qemu-implemented device instantly available to Xen at no extra charge.

My wording was inappropriate for s390, though.  The politically correct 
version reads "this device understands a hypervisor-specific way of 
kicking. consult your hypervisor manual and platform-specific way of 
querying hypervisor information for further details. should you not be 
satisfied with this method, the standard method of kicking virtio 
devices on your platform is still available".

On s390, I imagine that "the standard method" is the fabled diag 
instruction (which, with the proper arguments, will cook your steak to 
the exact shade of medium-rare you desire).  So you will never need to 
set the "hypervisor-specific way of kicking" bit, as your standard 
method is already optimal.

Unfortunately, we have to care for platform differences, subarch 
differences (vmx/svm), hypervisor differences (with virtio), and guest 
differences (Linux/Windows/pvLinux, 32/64).  Much care is needed when 
designing the ABI here.

[actually thinking a bit, this is specific to the virtio pci binding; 
s390 will never see any of it]

-- 
error compiling committee.c: too many arguments to function

