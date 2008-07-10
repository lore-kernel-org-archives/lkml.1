Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbYGJCVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbYGJCVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 22:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYGJCVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 22:21:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199AbYGJCVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 22:21:33 -0400
Date: Wed, 9 Jul 2008 19:14:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 22/34] AMD IOMMU: add domain allocation and deallocation
 functions
Message-Id: <20080709191459.673a9a4c.akpm@linux-foundation.org>
In-Reply-To: <1214508490-29683-23-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-23-git-send-email-joerg.roedel@amd.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 21:27:58 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:

> +static u16 domain_id_alloc(void)
> +{
> +	unsigned long flags;
> +	int id;
> +
> +	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
> +	id = find_first_zero_bit(amd_iommu_pd_alloc_bitmap, MAX_DOMAIN_ID);
> +	BUG_ON(id == 0);
> +	if (id > 0 && id < MAX_DOMAIN_ID)
> +		__set_bit(id, amd_iommu_pd_alloc_bitmap);
> +	else
> +		id = 0;
> +	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
> +
> +	return id;
> +}

Presumably this is not performance-critical.  If it is, an IDR
tree would help.
