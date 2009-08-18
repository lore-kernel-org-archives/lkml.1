Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbZHRWGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbZHRWGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZHRWGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:06:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49550 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZHRWGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:06:40 -0400
Message-ID: <4A8B25F5.7050806@redhat.com>
Date: Wed, 19 Aug 2009 01:06:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [Alacrityvm-devel] [PATCH v3 3/6] vbus: add a "vbus-proxy" bus
 model for vbus_driver objects
References: <4A8965E0.8050608@gmail.com> <20090817174142.GA11140@redhat.com> <4A89BAC5.9040400@gmail.com> <20090818084606.GA13878@redhat.com> <20090818155329.GD31060@ovro.caltech.edu> <4A8ADC09.3030205@redhat.com> <20090818172752.GC17631@ovro.caltech.edu> <4A8AE918.5000109@redhat.com> <20090818182735.GD17631@ovro.caltech.edu> <4A8AF880.6080704@redhat.com> <20090818205919.GA1168@ovro.caltech.edu> <4A8B1C7F.4060008@redhat.com>
In-Reply-To: <4A8B1C7F.4060008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2009 12:26 AM, Avi Kivity wrote:
>>
>> Off the top of my head, I would think that transporting userspace
>> addresses in the ring (for copy_(to|from)_user()) vs. physical addresses
>> (for DMAEngine) might be a problem. Pinning userspace pages into memory
>> for DMA is a bit of a pain, though it is possible.
>
>
> Oh, the ring doesn't transport userspace addresses.  It transports 
> guest addresses, and it's up to vhost to do something with them.
>
> Currently vhost supports two translation modes:
>
> 1. virtio address == host virtual address (using copy_to_user)
> 2. virtio address == offsetted host virtual address (using copy_to_user)
>
> The latter mode is used for kvm guests (with multiple offsets, 
> skipping some details).
>
> I think you need to add a third mode, virtio address == host physical 
> address (using dma engine).  Once you do that, and wire up the 
> signalling, things should work.


You don't need in fact a third mode.  You can mmap the x86 address space 
into your ppc userspace and use the second mode.  All you need then is 
the dma engine glue and byte swapping.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

