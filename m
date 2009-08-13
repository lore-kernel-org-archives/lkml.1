Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbZHMIrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbZHMIrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbZHMIrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:47:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50221 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbZHMIrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:47:05 -0400
Date: Thu, 13 Aug 2009 11:45:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Arnd Bergmann <arnd@arndb.de>, virtualization@lists.linux-foundation.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
Message-ID: <20090813084512.GA4401@redhat.com>
References: <cover.1249930169.git.mst@redhat.com> <20090810185340.GC13924@redhat.com> <200908121903.22325.arnd@arndb.de> <20090812172141.GA29966@redhat.com> <4A83167E.2080701@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A83167E.2080701@codemonkey.ws>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 02:22:38PM -0500, Anthony Liguori wrote:
> Michael S. Tsirkin wrote:
>>>
>>> We discussed this before, and I still think this could be directly derived
>>> from struct virtqueue, in the same way that vring_virtqueue is derived from
>>> struct virtqueue.
>>>     
>>
>> I prefer keeping it simple. Much of abstraction in virtio is due to the
>> fact that it needs to work on top of different hardware emulations:
>> lguest,kvm, possibly others in the future.  vhost is always working on
>> real hardware, using eventfd as the interface, so it does not need that.
>>   
>
> Actually, vhost may not always be limited to real hardware.

Yes, any ethernet device will do. What I mean is that vhost does not
deal with emulation at all. All setup is done in userspace.

>
> We may on day use vhost as the basis of a driver domain.  There's quite  
> a lot of interest in this for networking.

You can use veth for this. This works today.

> At any rate, I'd like to see performance results before we consider  
> trying to reuse virtio code.
> 
> Regards,
>
> Anthony Liguori
