Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbZIAFFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbZIAFFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 01:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZIAFFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 01:05:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:12452 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbZIAFFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 01:05:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,310,1249282800"; 
   d="scan'208";a="444448189"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Avi Kivity <avi@redhat.com>
CC: "mst@redhat.com" <mst@redhat.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "gregory.haskins@gmail.com" <gregory.haskins@gmail.com>
Date: Tue, 1 Sep 2009 13:04:58 +0800
Subject: RE: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
Thread-Topic: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
Thread-Index: AcoqY7mA5RNIRFyZSru0eVC4UTcAHgAW8eWA
Message-ID: <C85CEDA13AB1CF4D9D597824A86D2B9006AEB9477C@PDSMSX501.ccr.corp.intel.com>
References: <E88DD564E9DC5446A76B2B47C3BCCA150219600F9B@pdsmsx503.ccr.corp.intel.com>
 <C85CEDA13AB1CF4D9D597824A86D2B9006AEB944B8@PDSMSX501.ccr.corp.intel.com>
 <4A9C0DC2.6080704@redhat.com>
In-Reply-To: <4A9C0DC2.6080704@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One way to share the effort is to make vmdq queues available as normal 
kernel interfaces.  It would take quite a bit of work, but the end 
result is that no other components need to be change, and it makes vmdq 
useful outside kvm.  It also greatly reduces the amount of integration 
work needed throughout the stack (kvm/qemu/libvirt).

Yes. The common queue pair interface which we want to present will also apply to normal hardware, and try to leave other components unknown.

Thanks
Xiaohui

-----Original Message-----
From: Avi Kivity [mailto:avi@redhat.com] 
Sent: Tuesday, September 01, 2009 1:52 AM
To: Xin, Xiaohui
Cc: mst@redhat.com; netdev@vger.kernel.org; virtualization@lists.linux-foundation.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org; mingo@elte.hu; linux-mm@kvack.org; akpm@linux-foundation.org; hpa@zytor.com; gregory.haskins@gmail.com
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server

On 08/31/2009 02:42 PM, Xin, Xiaohui wrote:
> Hi, Michael
> That's a great job. We are now working on support VMDq on KVM, and since the VMDq hardware presents L2 sorting based on MAC addresses and VLAN tags, our target is to implement a zero copy solution using VMDq. We stared from the virtio-net architecture. What we want to proposal is to use AIO combined with direct I/O:
> 1) Modify virtio-net Backend service in Qemu to submit aio requests composed from virtqueue.
> 2) Modify TUN/TAP device to support aio operations and the user space buffer directly mapping into the host kernel.
> 3) Let a TUN/TAP device binds to single rx/tx queue from the NIC.
> 4) Modify the net_dev and skb structure to permit allocated skb to use user space directly mapped payload buffer address rather then kernel allocated.
>
> As zero copy is also your goal, we are interested in what's in your mind, and would like to collaborate with you if possible.
>    

One way to share the effort is to make vmdq queues available as normal 
kernel interfaces.  It would take quite a bit of work, but the end 
result is that no other components need to be change, and it makes vmdq 
useful outside kvm.  It also greatly reduces the amount of integration 
work needed throughout the stack (kvm/qemu/libvirt).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

