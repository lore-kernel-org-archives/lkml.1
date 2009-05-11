Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbZEKSTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbZEKSTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZEKSTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:19:14 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:36638 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbZEKSTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:19:13 -0400
Message-ID: <4A086C07.7050103@codemonkey.ws>
Date: Mon, 11 May 2009 13:18:47 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Hollis Blanchard <hollisb@us.ibm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net>	 <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com>	 <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com>	 <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com>	 <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com>	 <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws>	 <4A0570B1.30401@novell.com> <4A071F1A.1090702@codemonkey.ws>	 <4A0824C2.4000109@gmail.com> <1242059712.29194.12.camel@slate.austin.ibm.com> <4A085B06.4080803@redhat.com> <4A086590.4040602@codemonkey.ws> <4A086835.5020400@redhat.com>
In-Reply-To: <4A086835.5020400@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Anthony Liguori wrote:
>>>
>>> It's a question of cost vs. benefit.  It's clear the benefit is low 
>>> (but that doesn't mean it's not worth having).  The cost initially 
>>> appeared to be very low, until the nested virtualization wrench was 
>>> thrown into the works.  Not that nested virtualization is a reality 
>>> -- even on svm where it is implemented it is not yet production 
>>> quality and is disabled by default.
>>>
>>> Now nested virtualization is beginning to look interesting, with 
>>> Windows 7's XP mode requiring virtualization extensions.  Desktop 
>>> virtualization is also something likely to use device assignment 
>>> (though you probably won't assign a virtio device to the XP instance 
>>> inside Windows 7).
>>>
>>> Maybe we should revisit the mmio hypercall idea again, it might be 
>>> workable if we find a way to let the guest know if it should use the 
>>> hypercall or not for a given memory range.
>>>
>>> mmio hypercall is nice because
>>> - it falls back nicely to pure mmio
>>> - it optimizes an existing slow path, not just new device models
>>> - it has preexisting semantics, so we have less ABI to screw up
>>> - for nested virtualization + device assignment, we can drop it and 
>>> get a nice speed win (or rather, less speed loss)
>>
>> If it's a PCI device, then we can also have an interrupt which we 
>> currently lack with vmcall-based hypercalls.  This would give us 
>> guestcalls, upcalls, or whatever we've previously decided to call them.
>
> Sorry, I totally failed to understand this.  Please explain.

I totally missed what you meant by MMIO hypercall.

In what cases do you think MMIO hypercall would result in a net benefit?

I think the difference in MMIO vs hcall will be overshadowed by the 
heavy weight transition to userspace.  The only thing I can think of 
where it may matter is for in-kernel devices like the APIC but that's a 
totally different path in Linux.

Regards,

Anthony Liguori
