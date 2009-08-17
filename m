Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbZHQNy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbZHQNy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 09:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbZHQNy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 09:54:28 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:41023 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZHQNy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 09:54:27 -0400
Message-ID: <4A896112.9030407@codemonkey.ws>
Date: Mon, 17 Aug 2009 08:54:26 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for vbus_driver
 objects
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <20090816071607.GB29537@elte.hu>
In-Reply-To: <20090816071607.GB29537@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> I think the reason vbus gets better performance for networking 
>> today is that vbus' backends are in the kernel while virtio's 
>> backends are currently in userspace.  Since Michael has a 
>> functioning in-kernel backend for virtio-net now, I suspect we're 
>> weeks (maybe days) away from performance results.  My expectation 
>> is that vhost + virtio-net will be as good as venet + vbus.  If 
>> that's the case, then I don't see any reason to adopt vbus unless 
>> Greg things there are other compelling features over virtio.
>>     
>
> Keeping virtio's backend in user-space was rather stupid IMHO. 
>   

I don't think it's quite so clear.

There's nothing about vhost_net that would prevent a userspace 
application from using it as a higher performance replacement for tun/tap.

The fact that we can avoid userspace for most of the fast paths is nice 
but that's really an issue of vhost_net vs. tun/tap.

 From the kernel's perspective, a KVM guest is just a userspace 
process.  Having new userspace interfaces that are only useful to KVM 
guests would be a bad thing.

Regards,

Anthony Liguori
