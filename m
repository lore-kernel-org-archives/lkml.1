Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbZFWKsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbZFWKsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZFWKsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:48:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38833 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbZFWKsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:48:36 -0400
Date: Tue, 23 Jun 2009 13:48:12 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
Message-ID: <20090623104812.GB17635@redhat.com>
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090623085633.GA16294@redhat.com> <4A40A721.3020901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A40A721.3020901@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 12:57:53PM +0300, Avi Kivity wrote:
> On 06/23/2009 11:56 AM, Michael S. Tsirkin wrote:
>> On Thu, Jun 18, 2009 at 08:30:46PM -0400, Gregory Haskins wrote:
>>    
>>> +static int
>>> +iosignalfd_group_in_range(struct kvm_io_device *this, gpa_t addr, int len,
>>> +			  int is_write)
>>> +{
>>> +	struct _iosignalfd_group *p = to_group(this);
>>> +
>>> +	return ((addr>= p->addr&&  (addr<  p->addr + p->length)));
>>> +}
>>>      
>>
>> I think I see a problem here. For virtio, we do not necessarily want all
>> virtqueues for a device to live in kernel: there might be control
>> virtqueues that we want to leave in userspace. Since this claims all
>> writes to a specific address, the signal never makes it to userspace.
>>    
>
> Userspace could create an eventfd for this control queue and wait for it  
> to fire.

What if guest writes an unexpected value there?
The value it simply lost ... that's not very elegant.

-- 
MST
