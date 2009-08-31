Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZHaPZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZHaPZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 11:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbZHaPZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 11:25:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56333 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZHaPZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 11:25:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Xin, Xiaohui" <xiaohui.xin@intel.com>
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
Date: Mon, 31 Aug 2009 17:23:33 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-6-generic; KDE/4.3.0; x86_64; ; )
Cc: "mst@redhat.com" <mst@redhat.com>,
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
References: <E88DD564E9DC5446A76B2B47C3BCCA150219600F9B@pdsmsx503.ccr.corp.intel.com> <C85CEDA13AB1CF4D9D597824A86D2B9006AEB944B8@PDSMSX501.ccr.corp.intel.com>
In-Reply-To: <C85CEDA13AB1CF4D9D597824A86D2B9006AEB944B8@PDSMSX501.ccr.corp.intel.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908311723.34067.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Xt/hCqSps3LS2+cNOTRqY1rex6deK4P56z2N
 V6Ww6EEvj5GPS8d+6PNKum5c1qtm6WX3vjUMTMjzu+uEJA1t6H
 ncHds8YCWV0lw8b7l8U8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 August 2009, Xin, Xiaohui wrote:
> 
> Hi, Michael
> That's a great job. We are now working on support VMDq on KVM, and since the VMDq hardware presents L2 sorting
> based on MAC addresses and VLAN tags, our target is to implement a zero copy solution using VMDq.

I'm also interested in helping there, please include me in the discussions.

> We stared
> from the virtio-net architecture. What we want to proposal is to use AIO combined with direct I/O:
> 1) Modify virtio-net Backend service in Qemu to submit aio requests composed from virtqueue.

right, that sounds useful.

> 2) Modify TUN/TAP device to support aio operations and the user space buffer directly mapping into the host kernel.
> 3) Let a TUN/TAP device binds to single rx/tx queue from the NIC.

I don't think we should do that with the tun/tap driver. By design, tun/tap is a way to interact with the
networking stack as if coming from a device. The only way this connects to an external adapter is through
a bridge or through IP routing, which means that it does not correspond to a specific NIC.

I have worked on a driver I called 'macvtap' in lack of a better name, to add a new tap frontend to
the 'macvlan' driver. Since macvlan lets you add slaves to a single NIC device, this gives you a direct
connection between one or multiple tap devices to an external NIC, which works a lot better than when
you have a bridge inbetween. There is also work underway to add a bridging capability to macvlan, so
you can communicate directly between guests like you can do with a bridge.

Michael's vhost_net can plug into the same macvlan infrastructure, so the work is complementary.

> 4) Modify the net_dev and skb structure to permit allocated skb to use user space directly mapped payload
> buffer address rather then kernel allocated.

yes.

> As zero copy is also your goal, we are interested in what's in your mind, and would like to collaborate with you if possible.
> BTW, we will send our VMDq write-up very soon.

Ok, cool.

	Arnd <><
