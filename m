Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbZHXTCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbZHXTCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 15:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZHXTCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 15:02:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:14526 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZHXTCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 15:02:14 -0400
Message-ID: <4A92E3B1.5080002@codemonkey.ws>
Date: Mon, 24 Aug 2009 14:02:09 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: alacrityvm-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: vbus design points: shm and shm-signals
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <4A8965E0.8050608@gmail.com> <4A89FF08.30509@codemonkey.ws> <4A8AA9BD.2070909@gmail.com> <4A8AB076.6080906@redhat.com> <4A8ACE1F.6020402@gmail.com> <20090818161434.GA15884@elte.hu> <4A8B7F17.6050100@gmail.com> <4A8E7D32.8040209@gmail.com>
In-Reply-To: <4A8E7D32.8040209@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Gregory Haskins wrote:
>   
>> Ingo Molnar wrote:
>>     
>>> We all love faster code and better management interfaces and tons 
>>> of your prior patches got accepted by Avi. This time you didnt even 
>>> _try_ to improve virtio.
>>>       
>> Im sorry, but you are mistaken:
>>
>> http://lkml.indiana.edu/hypermail/linux/kernel/0904.2/02443.html
>>
>>     
>
> BTW: One point that I forgot to point out in this most recent thread
> that I am particularly proud of here is the design of the vbus
> shared-memory model.  Despite some claims to the contrary; not only is
> it possible to improve virtio with vbus (as evident by the patch
> referenced above)...I specifically designed vbus with virtio
> considerations in mind from the start!  In fact, the design is conducive
> to accelerating a variety of other models as well.  Read on for details.
>
> Vbus was designed it to be _agnostic_ to the shm algorithm in general.
> This allows you to, of course, run ring algorithms (such as virtqueues,
> or IOQs), but really any other designs as well, such as shared-tables, etc.
>
> A guest driver sees the following interface:
>
> struct vbus_device_proxy_ops {
> 	int (*open)(struct vbus_device_proxy *dev, int version, int flags);
> 	int (*close)(struct vbus_device_proxy *dev, int flags);
> 	int (*shm)(struct vbus_device_proxy *dev, int id, int prio,
> 		   void *ptr, size_t len,
> 		   struct shm_signal_desc *sigdesc, struct shm_signal **signal,
> 		   int flags);
> 	int (*call)(struct vbus_device_proxy *dev, u32 func,
> 		    void *data, size_t len, int flags);
> 	void (*release)(struct vbus_device_proxy *dev);
> };
>
> note the ops->shm() method.  This allows the driver to register some
> arbitrary pointer (ptr, len) with the host, optionally embedding a
> shm_signal_desc object in the memory.  If "sigdesc" is non-null, the
> connector will allocate and return a fully formed shm_signal object in
> **signal.
>   

Fundamentally, how is this different than the virtio->add_buf concept?

virtio provides a mechanism to register scatter/gather lists, associate 
a handle with them, and provides a mechanism for retrieving notification 
that the buffer has been processed.

vbus provides a mechanism to register a single buffer with an integer 
handle, priority, and a signaling mechanism.

So virtio provides builtin support for scatter/gathers whereas vbus 
models priority.  But fundamentally, they seem like almost identical 
concepts.

If we added priority to virtio->add_buf, would it be equivalent in your 
mind functionally speaking?

What does one do with priority, btw?

Is there something I'm overlooking?

Regards,

Anthony Liguroi
