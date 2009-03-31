Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZCaUMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZCaUMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 16:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbZCaUMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 16:12:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51727 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbZCaUMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 16:12:39 -0400
Message-ID: <49D27950.9020801@redhat.com>
Date: Tue, 31 Mar 2009 23:13:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, anthony@codemonkey.ws, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 15/17] kvm: add dynamic IRQ support
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <20090331184405.28333.59205.stgit@dev.haskins.net> <49D26CFE.1060700@redhat.com> <49D2718F.9070203@novell.com>
In-Reply-To: <49D2718F.9070203@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>> - works with all guests
>> - supports hotplug/hotunplug, udev, sysfs, module autoloading, ...
>> - supported in all OSes
>> - someone else maintains it
>>     
> These points are all valid, and I really struggled with this particular
> part of the design.  The entire vbus design only requires one IRQ for
> the entire guest,

Won't this have scaling issues?  One IRQ means one target vcpu.  Whereas 
I'd like virtio devices to span multiple queues, each queue with its own 
MSI IRQ.  Also, the single IRQ handler will need to scan for all 
potential IRQ sources.  Even if implemented carefully, this will cause 
many cacheline bounces.

>  so its conceivable that I could present a simple
> "dummy" PCI device with some "VBUS" type PCI-ID, just to piggy back on
> the IRQ routing logic.  Then userspace could simply pass the IRQ routing
> info down to the kernel with an ioctl, or something similar.
>   

Xen does something similar, I believe.

> I think ultimately I was trying to stay away from PCI in general because
> I want to support environments that do not have PCI.  However, for the
> kvm-transport case (at least on x86) this isnt really a constraint.
>
>   

s/PCI/the native IRQ solution for your platform/. virtio has the same 
problem; on s390 we use the native (if that word ever applies to s390) 
interrupt and device discovery mechanism.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

