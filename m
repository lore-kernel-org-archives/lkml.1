Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZD2ITu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZD2ITu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 04:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZD2ITd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 04:19:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60780 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbZD2ITb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 04:19:31 -0400
Message-ID: <49F80D67.8030008@redhat.com>
Date: Wed, 29 Apr 2009 11:18:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v3 0/2] irqfd
References: <20090427182540.6646.96740.stgit@dev.haskins.net> <20090428231002.919419dd.akpm@linux-foundation.org>
In-Reply-To: <20090428231002.919419dd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 27 Apr 2009 14:33:24 -0400 Gregory Haskins <ghaskins@novell.com> wrote:
>
>   
>> (Applies to kvm.git 41b76d8d0487c26d6d4d3fe53c1ff59b3236f096)
>>
>> This series implements a mechanism called "irqfd".  It lets you create
>> an eventfd based file-desriptor to inject interrupts to a kvm guest.  We
>> associate one gsi per fd for fine-grained routing.
>>     
>
> It'd be nice if the KVM weenies amongst us were to be told why one
> would want to inject interrupts into a KVM guest.  Monosyllabic words
> would be preferred ;)
>   

Interrupts are injected (better word, raised) into a guest because real 
hardware has interrupts. This patchset does not add the ability to raise 
interrupts (that existed from day 1); it adds an eventfd interface to do so.

An eventfd interface is useful, because it allows components to talk to 
kvm guests without being tied to kvm internals; they signal an eventfd; 
if the eventfd is terminated in kvm, it injects an interrupt. If the 
eventfd is terminated in userspace, it returns from epoll().

>> We do not have a user of this interface in this series, though note
>> future version of virtual-bus (v4 and above) will be based on this.
>>     
>
> So I assume that this patchset will be merged if/when a user of it is
> merged?
>   

This interface is applicable to both the kernel and userspace; userspace 
users won't be merged.

But I certainly want to see how the whole thing works.

>> The first patch will require mainline buy-in, particularly from Davide
>> (cc'd).  The last patch is kvm specific.
>>     
>
> Three EXPORT_SYMBOL_GPL()s.  Once the shouting has subsided I'd suggest
> that this be merged via the KVM tree.
>   

I think eventfd makes tons of sense as a generic 'wake me up' mechanism 
that can be used from both sides of the kernel/user line.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

