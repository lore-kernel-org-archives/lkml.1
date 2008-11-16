Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbYKPQHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYKPQHY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYKPQGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:06:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56576 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbYKPQGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:06:46 -0500
Message-ID: <492044A7.3080107@redhat.com>
Date: Sun, 16 Nov 2008 18:04:55 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Andi Kleen <andi@firstfloor.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
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
References: <20081106154351.GA30459@kroah.com>	<894107.30288.qm@web45108.mail.sp1.yahoo.com>	<20081106164919.GA4099@kroah.com>	<0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net>	<20081106183630.GD11773@parisc-linux.org>	<491371F0.7020805@codemonkey.ws> <87d4h7pnnm.fsf__4937.77150190926$1226071173$gmane$org@basil.nowhere.org> <491B5B97.2000407@codemonkey.ws>
In-Reply-To: <491B5B97.2000407@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> I don't think it's established that PV/VF will have less latency than 
> using virtio-net.  virtio-net requires a world switch to send a group 
> of packets.  The cost of this (if it stays in kernel) is only a few 
> thousand cycles on the most modern processors.
>
> Using VT-d means that for every DMA fetch that misses in the IOTLB, 
> you potentially have to do four memory fetches to main memory.  There 
> will be additional packet latency using VT-d compared to native, it's 
> just not known how much at this time.

If the IOTLB has intermediate TLB entries like the processor, we're 
talking just one or two fetches.  That's a lot less than the cacheline 
bouncing that virtio and kvm interrupt injection incur right now.

-- 
error compiling committee.c: too many arguments to function

