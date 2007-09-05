Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbXIEUUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbXIEUUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 16:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbXIEUUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 16:20:06 -0400
Received: from il.qumranet.com ([82.166.9.18]:42048 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672AbXIEUUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 16:20:03 -0400
Message-ID: <46DF0EC2.7090408@qumranet.com>
Date: Wed, 05 Sep 2007 23:17:06 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kvm-devel@lists.sourceforge.net, general@lists.openfabrics.org
Subject: Re: [kvm-devel] [PATCH][RFC] pte notifiers -- support for external
 page tables
References: <11890207643068-git-send-email-avi@qumranet.com> <1189022183.10802.184.camel@localhost.localdomain>
In-Reply-To: <1189022183.10802.184.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wed, 2007-09-05 at 22:32 +0300, Avi Kivity wrote:
>   
>> [resend due to bad alias expansion resulting in some recipients
>>  being bogus]
>>
>> Some hardware and software systems maintain page tables outside the normal
>> Linux page tables, which reference userspace memory.  This includes
>> Infiniband, other RDMA-capable devices, and kvm (with a pending patch).
>>     
>
> And lguest.  I can't tell until I've actually implemented it, but I
> think it will seriously reduce the need for page pinning which is why
> only root can currently launch guests.
>
>   

Ah yes, lguest.

> My concern is locking: this is called with the page lock held, and I
> guess we have to bump the guest out if it's currently running.
>   

This will complicate kvm's locking too.  We usually take kvm->lock to do 
mmu ops, but that is now a mutex.


-- 
Any sufficiently difficult bug is indistinguishable from a feature.

