Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZCEVkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZCEVkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 16:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZCEVkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 16:40:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37673 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbZCEVkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 16:40:09 -0500
Date: Thu, 5 Mar 2009 18:39:13 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] kvm/x86: call kvm_lapic_sync_from_vapic with
	preemption disabled
Message-ID: <20090305213913.GC5660@amt.cnet>
References: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com> <1236255153-4432-6-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236255153-4432-6-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 01:12:32PM +0100, Joerg Roedel wrote:
> The function uses kmap_atomic. Calling it with preemption enabled is
> racy.

kmap_atomic disables preemption?

void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
{                       
        enum fixed_addresses idx;
        unsigned long vaddr;    
                        
        /* even !CONFIG_PREEMPT needs this, for in_atomic in  * do_page_fault */
        pagefault_disable();


