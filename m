Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbYKLWlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbYKLWlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYKLWlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:41:35 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:48025 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYKLWle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:41:34 -0500
Message-ID: <491B5B97.2000407@codemonkey.ws>
Date: Wed, 12 Nov 2008 16:41:27 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "Chiang, Alexander" <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <greg@kroah.com>, "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
References: <20081106154351.GA30459@kroah.com>	<894107.30288.qm@web45108.mail.sp1.yahoo.com>	<20081106164919.GA4099@kroah.com>	<0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net>	<20081106183630.GD11773@parisc-linux.org>	<491371F0.7020805@codemonkey.ws> <87d4h7pnnm.fsf__4937.77150190926$1226071173$gmane$org@basil.nowhere.org>
In-Reply-To: <87d4h7pnnm.fsf__4937.77150190926$1226071173$gmane$org@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Anthony Liguori <anthony@codemonkey.ws> writes:
>> What we would rather do in KVM, is have the VFs appear in the host as
>> standard network devices.  We would then like to back our existing PV
>> driver to this VF directly bypassing the host networking stack.  A key
>> feature here is being able to fill the VF's receive queue with guest
>> memory instead of host kernel memory so that you can get zero-copy
>> receive traffic.  This will perform just as well as doing passthrough
>> (at least) and avoid all that ugliness of dealing with SR-IOV in the
>> guest.
> 
> But you shift a lot of ugliness into the host network stack again.
> Not sure that is a good trade off.
> 
> Also it would always require context switches and I believe one
> of the reasons for the PV/VF model is very low latency IO and having
> heavyweight switches to the host and back would be against that.

I don't think it's established that PV/VF will have less latency than 
using virtio-net.  virtio-net requires a world switch to send a group of 
packets.  The cost of this (if it stays in kernel) is only a few 
thousand cycles on the most modern processors.

Using VT-d means that for every DMA fetch that misses in the IOTLB, you 
potentially have to do four memory fetches to main memory.  There will 
be additional packet latency using VT-d compared to native, it's just 
not known how much at this time.

Regards,

Anthony Liguori


> -Andi
> 

