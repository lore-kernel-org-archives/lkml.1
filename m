Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936042Ab0COJlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 05:41:14 -0400
Received: from 8bytes.org ([88.198.83.132]:50574 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934484Ab0COJlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 05:41:10 -0400
Date: Mon, 15 Mar 2010 10:41:09 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] KVM: MMU: Propagate the right fault back to the
	guest after gva_to_gpa
Message-ID: <20100315094109.GB13108@8bytes.org>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com> <1267643541-451-16-git-send-email-joerg.roedel@amd.com> <4B9DE394.2080401@redhat.com> <20100315090609.GA13108@8bytes.org> <4B9DFC7B.5050900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9DFC7B.5050900@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 11:23:07AM +0200, Avi Kivity wrote:
> On 03/15/2010 11:06 AM, Joerg Roedel wrote:
>> On Mon, Mar 15, 2010 at 09:36:52AM +0200, Avi Kivity wrote:
>>    
>>> On 03/03/2010 09:12 PM, Joerg Roedel wrote:
>>>      
>>>> This patch implements logic to make sure that either a
>>>> page-fault/page-fault-vmexit or a nested-page-fault-vmexit
>>>> is propagated back to the guest.
>>>>
>>>> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
>>>> ---
>>>>    arch/x86/kvm/mmu.h         |    1 +
>>>>    arch/x86/kvm/paging_tmpl.h |    2 ++
>>>>    arch/x86/kvm/x86.c         |   15 ++++++++++++++-
>>>>    3 files changed, 17 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>>>> index 64f619b..b42b27e 100644
>>>> --- a/arch/x86/kvm/mmu.h
>>>> +++ b/arch/x86/kvm/mmu.h
>>>> @@ -47,6 +47,7 @@
>>>>    #define PFERR_USER_MASK (1U<<   2)
>>>>    #define PFERR_RSVD_MASK (1U<<   3)
>>>>    #define PFERR_FETCH_MASK (1U<<   4)
>>>> +#define PFERR_NESTED_MASK (1U<<   31)
>>>>
>>>>        
>>>
>>> Why is this needed?  Queue an ordinary page fault page; the injection
>>> code should check the page fault intercept and #VMEXIT if needed.
>>>      
>> This is needed because we could have a nested page fault or an ordinary
>> page fault which need to be propagated.
>>    
>
> Right.
>
> Why is pio_copy_data() changed?  One would think that it would be an  
> all-or-nothing affair.

It was the only place I found where the PROPAGATE_FAULT value was
checked and actually propagated.

	Joerg

