Return-Path: <linux-kernel-owner+w=401wt.eu-S1757116AbYGJBuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbYGJBuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYGJBtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:49:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054AbYGJBtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:49:52 -0400
Date: Wed, 9 Jul 2008 18:43:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 04/34] AMD IOMMU: add data structures to manage the
 IOMMUs in the system
Message-Id: <20080709184342.1ffb0ff0.akpm@linux-foundation.org>
In-Reply-To: <1214508490-29683-5-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 21:27:40 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch adds the data structures which will contain the information read
> from the ACPI table.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/amd_iommu_init.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> index 6fce5ab..0ad8cf9 100644
> --- a/arch/x86/kernel/amd_iommu_init.c
> +++ b/arch/x86/kernel/amd_iommu_init.c
> @@ -99,3 +99,20 @@ struct ivmd_header {
>  	u64 range_length;
>  } __attribute__((packed));
>  
> +static int __initdata amd_iommu_disable;
> +
> +u16 amd_iommu_last_bdf;
> +struct list_head amd_iommu_unity_map;
> +unsigned amd_iommu_aperture_order = 26;
> +int amd_iommu_isolate;
> +
> +struct list_head amd_iommu_list;
> +struct dev_table_entry *amd_iommu_dev_table;
> +u16 *amd_iommu_alias_table;
> +struct amd_iommu **amd_iommu_rlookup_table;
> +struct protection_domain **amd_iommu_pd_table;
> +unsigned long *amd_iommu_pd_alloc_bitmap;
> +
> +static u32 dev_table_size;
> +static u32 alias_table_size;
> +static u32 rlookup_table_size;

hm, one would expect to see the header file which declares the globals in
the same patch as the .c file which defines them.  Whatever.

What locks the list_heads?  It would be good to add a code comment at the
definition site describing that locking.

