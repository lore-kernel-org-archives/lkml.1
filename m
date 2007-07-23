Return-Path: <linux-kernel-owner+w=401wt.eu-S933936AbXGWLcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936AbXGWLcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 07:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758238AbXGWLcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 07:32:14 -0400
Received: from il.qumranet.com ([82.166.9.18]:41051 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741AbXGWLcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 07:32:12 -0400
Message-ID: <46A491C4.8010302@qumranet.com>
Date: Mon, 23 Jul 2007 14:32:20 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 7/8]KVM: swap out guest pages
References: <1185173505.2645.71.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1185173505.2645.71.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> Make KVM guest pages be allocated dynamically and able to be swaped out.
>
> One issue: all inodes returned from anon_inode_getfd are shared,
> if one module changes field of the inode, other moduels might break.
> Should we introduce a new API to not share inode?
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  drivers/kvm/kvm.h      |    8 +
>  drivers/kvm/kvm_main.c |  220 +++++++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 211 insertions(+), 17 deletions(-)
>
> +
> +	/*
> +	 * We just zap vcpu 0's page table. For a SMP guest, we should zap all
> + 	 * vcpus'. It's better shadow page table is per-vm.
> +	 */
> +	if (PagePrivate(page))
> +		kvm_mmu_zap_pagetbl(&kvm->vcpus[0], page->index);
> +
>   

You're not removing any shadows of the page, in case that page is a 
guest page table.  But I don't see anything wrong with it -- the page 
won't change while it's in swap.

-- 
error compiling committee.c: too many arguments to function

