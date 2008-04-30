Return-Path: <linux-kernel-owner+w=401wt.eu-S1759496AbYD3GC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbYD3GC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbYD3GCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:02:47 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:35979 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891AbYD3GCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:02:46 -0400
Date: Wed, 30 Apr 2008 09:05:13 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Amit Shah <amit.shah@qumranet.com>, Glauber Costa <gcosta@redhat.com>,
       kvm-devel@lists.sourceforge.net,
       virtualization@lists.linux-foundation.org,
       Ben-Ami Yassour1 <BENAMI@il.ibm.com>, chrisw@redhat.com,
       dor.laor@qumranet.com, allen.m.kay@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM x86: Handle hypercalls for assigned PCI devices
Message-ID: <20080430060513.GB7378@il.ibm.com>
References: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com> <1209465451-3758-3-git-send-email-amit.shah@qumranet.com> <48173440.304@redhat.com> <200804292128.52268.amit.shah@qumranet.com> <4817A5C6.7070704@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4817A5C6.7070704@qumranet.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 01:48:38AM +0300, Avi Kivity wrote:
> Amit Shah wrote:
>>
>>>> +	if (is_error_page(host_page)) {
>>>> +		printk(KERN_INFO "%s: gfn %p not valid\n",
>>>> +		       __func__, (void *)page_gfn);
>>>> +		r = -1;
>>>>       
>>> r = -1 is not really informative. Better use some meaningful error.
>>>     
>>
>> The error's going to the guest. The guest, as we know, has already
>> done a successful DMA allocation. Something went wrong in the
>> hypercall, and we don't know why (bad page). Any kind of error here
>> isn't going to be intelligible to the guest anyway. It's mostly a
>> host thing if we ever hit this.
>>   
>
> If the guest is not able to handle it, why bother returning an
> error?  Better to kill it.
>
> But in any case, -1 is not a good error number.

The guest should be able to deal with transient DMA mapping errors,
either by retrying, or quiescing the device. This is in line with how
HW IOMMUs work - they may run out of mappings for example and the
driver should be able to cope with it. Killing the guest is a last
resort.

Cheers,
Muli
