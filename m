Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbZJHQqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbZJHQqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbZJHQqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:46:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbZJHQqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:46:22 -0400
References: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com> <1254996199-17667-2-git-send-email-joerg.roedel@amd.com> <4ACE0F6C.3060103@redhat.com> <20091008162222.GG14073@amd.com> <4ACE127A.6040304@redhat.com> <20091008163234.GJ14073@amd.com> <4ACE1598.6050200@redhat.com>
Message-Id: <56DA32E3-04B4-4B4E-B364-1174AE4E3E50@suse.de>
From: Alexander Graf <agraf@suse.de>
To: Avi Kivity <avi@redhat.com>
In-Reply-To: <4ACE1598.6050200@redhat.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7A341)
Mime-Version: 1.0 (iPhone Mail 7A341)
Subject: Re: [PATCH 1/9] KVM: SVM: Notify nested hypervisor of lost event injections
Date: Thu, 8 Oct 2009 18:46:48 +0200
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 08.10.2009 um 18:38 schrieb Avi Kivity <avi@redhat.com>:

> On 10/08/2009 06:32 PM, Joerg Roedel wrote:
>> No. The L1 guest needs to execute VMRUN with an interrupt to inject  
>> to
>> the L2 guest with event_inj. On that VMRUN instruction emulation an
>> interrupt becomes pending which causes an immediate #vmexit from L2  
>> to
>> L2 again without even entering the L2 guest. The bug was that in this
>> case the event which the L1 tried to inject in the L2 was lost  
>> because
>> it was not copied to exit_int_info.
>>
>
> (from L1 to L0?)
>
> Wow.  Alex, how did you find this?

Hyper-V got stuck and I was trying to think of possible reasons  
looking at the logs :-).
Fortunately this patch also seemed to make things work better with KVM  
in KVM.

Doesn't really help with regression testing though...

Alex

>
> We can try to cause an interrupt using a signal from another thread,  
> but that's too difficult as the first test in a test suite.
>
> -- 
> error compiling committee.c: too many arguments to function
>
