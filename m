Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZFWQvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZFWQvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbZFWQui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:50:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37516 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbZFWQug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:50:36 -0400
Date: Tue, 23 Jun 2009 13:49:20 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] kvm: change memslot data structures for multiple
	hugepage sizes
Message-ID: <20090623164920.GC3651@amt.cnet>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com> <1245417389-5527-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245417389-5527-3-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 03:16:23PM +0200, Joerg Roedel wrote:
>  /*
> @@ -724,11 +724,11 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
>  		end = start + (memslot->npages << PAGE_SHIFT);
>  		if (hva >= start && hva < end) {
>  			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
> +			int idx = gfn_offset /
> +			          KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL);
>  			retval |= handler(kvm, &memslot->rmap[gfn_offset]);
>  			retval |= handler(kvm,
> -					  &memslot->lpage_info[
> -						  gfn_offset /
> -						  KVM_PAGES_PER_HPAGE].rmap_pde);
> +					&memslot->lpage_info[0][idx].rmap_pde);
>  		}

Cannot find where you update this function to reflect 1GB pages in the
series?

