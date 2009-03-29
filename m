Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbZC2Ncc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbZC2Ncc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZC2NcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:32:21 -0400
Received: from 8bytes.org ([88.198.83.132]:45268 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbZC2NcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:32:21 -0400
Date: Sun, 29 Mar 2009 15:32:18 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] kvm mmu: implement necessary data structures for
	second huge page accounting
Message-ID: <20090329133218.GL31080@8bytes.org>
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <1238164319-16092-5-git-send-email-joerg.roedel@amd.com> <49CF5F68.1020507@redhat.com> <20090329130353.GK31080@8bytes.org> <49CF745B.5010001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CF745B.5010001@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 04:15:07PM +0300, Avi Kivity wrote:
> Joerg Roedel wrote:
>>>     
>>>>  +static int has_wrprotected_largepage(struct kvm *kvm, gfn_t gfn)
>>>> +{
>>>> +	struct kvm_memory_slot *slot;
>>>> +	int *hugepage_idx;
>>>> +
>>>> +	gfn = unalias_gfn(kvm, gfn);
>>>> +	slot = gfn_to_memslot_unaliased(kvm, gfn);
>>>> +	if (slot) {
>>>> +		hugepage_idx = slot_hugepage_idx(gfn, slot);
>>>>         
>>> slot_largepage_idx() here?
>>>
>>> I don't think we ever write protect large pages, so why is this needed?
>>>     
>>
>> For 2mb pages we need to check if there is a write-protected 4k page in it
>> before we map a 2mb page for writing. If there is any write-protected 4k
>> page in a 2mb area this 2mb page is considered write-protected. These
>> 'write-protected' 2mb pages are accounted in the account_shadow()
>> function. This information is taken into account when we decide if we
>> can map a guest 1gb page as a 1gb page on the host too.
>>   
>
> account_shadowed() actually increments a hugepage write_count by 1 for  
> every 4K page, not 2M page, if I read the code correctly.  The code I  
> commented on is right though.
>
> The naming is confusing.  I suggest  
> has_wrprotected_page_in_{large,huge}page().  although with the a level  
> parameter we can keep has_wrprotected_page().

Yeah true, the name is a bit confusing. I think a level parameter for
has_wrprotected_page() is the best solution.

	Joerg
