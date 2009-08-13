Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbZHMPh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbZHMPh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZHMPh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:37:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36822 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbZHMPh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:37:28 -0400
Message-ID: <4A843331.1020402@redhat.com>
Date: Thu, 13 Aug 2009 18:37:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
References: <cover.1249930169.git.mst@redhat.com> <200908131548.35199.arnd@arndb.de> <20090813144129.GB5080@redhat.com> <200908131653.47029.arnd@arndb.de>
In-Reply-To: <200908131653.47029.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 05:53 PM, Arnd Bergmann wrote:
> On Thursday 13 August 2009, Michael S. Tsirkin wrote:
>    
>> The best way to do this IMO would be to add zero copy support to raw
>> sockets, vhost will then get it basically for free.
>>      
>
> Yes, that would be nice. I wonder if that could lead to security
> problems on TX though. I guess It will only bring significant performance
> improvements if we leave the data writable in the user space or guest
> during the operation. If the user finds the right timing, it could
> modify the frame headers after they have been checked using netfilter,
> or while the frames are being consumed in the kernel (e.g. an NFS
> server running in a guest).
>    

IIRC when the kernel consumes data it linearizes the skb.  We just need 
to make sure all the zerocopy data is in the nonlinear part, and the 
kernel will copy if/when it needs to access packet data.

-- 
error compiling committee.c: too many arguments to function

