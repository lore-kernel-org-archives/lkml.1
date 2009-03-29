Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbZC2Mu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbZC2Mu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZC2Mup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:50:45 -0400
Received: from 8bytes.org ([88.198.83.132]:55395 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398AbZC2Muo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:50:44 -0400
Date: Sun, 29 Mar 2009 14:50:41 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: add support for 1GB pages in shadow paging
	code
Message-ID: <20090329125041.GI31080@8bytes.org>
References: <1238164518-16261-1-git-send-email-joerg.roedel@amd.com> <49CF629E.9080403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CF629E.9080403@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 02:59:26PM +0300, Avi Kivity wrote:
> Joerg Roedel wrote:
>>  	return write_protected;
>>  }
>>  @@ -789,11 +797,14 @@ static int kvm_handle_hva(struct kvm *kvm, 
>> unsigned long hva,
>>  		if (hva >= start && hva < end) {
>>  			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
>>  			unsigned long lidx = gfn_offset / KVM_PAGES_PER_2M_PAGE;
>> +			unsigned long hidx = gfn_offset / KVM_PAGES_PER_1G_PAGE;
>>  			retval |= handler(kvm, &memslot->rmap[gfn_offset],
>>  					  KVM_PAGE_SIZE_4k);
>>  			retval |= handler(kvm,
>>  					  &memslot->lpage_info[lidx].rmap_pde,
>>  					  KVM_PAGE_SIZE_2M);
>> +			retval |= handler(kvm, &memslot->hpage_info[hidx].rmap_pde,
>> +					  KVM_PAGE_SIZE_1G);
>>  		}
>>  	}
>>   
>
> Isn't this needed for tdp as well?

Hmm, yes. But it may be no problem not doing it because large pages are
never swapped out. Anyway, I will move this to the tdp patch

	Joerg
