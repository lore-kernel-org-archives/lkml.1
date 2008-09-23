Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYIWOkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYIWOkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYIWOkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:40:11 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:41478 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYIWOkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:40:10 -0400
Date: Tue, 23 Sep 2008 17:37:14 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       Amit Shah <amit.shah@qumranet.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 6/9] x86/iommu: change Calgary to use dma_ops register
	interface
Message-ID: <20080923143714.GH7131@il.ibm.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <1222107681-8185-7-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222107681-8185-7-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 08:21:18PM +0200, Joerg Roedel wrote:
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/pci-calgary_64.c |   21 +++++++++++----------
>  1 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
> index fe7695e..e2f2f60 100644
> --- a/arch/x86/kernel/pci-calgary_64.c
> +++ b/arch/x86/kernel/pci-calgary_64.c
> @@ -525,6 +525,15 @@ static void calgary_free_coherent(struct device *dev, size_t size,
>  	free_pages((unsigned long)vaddr, get_order(size));
>  }
>  
> +static int calgary_device_supported(struct device *dev)
> +{
> +	struct iommu_table *tbl;
> +
> +	tbl = find_iommu_table(dev);
> +
> +	return translation_enabled(tbl);
> +}
> +

Whole patchset and this patch in particular looks very good. Will ack
after I get a chance to test it.

Cheers,
Muli
-- 
The First Workshop on I/O Virtualization (WIOV '08)
Dec 2008, San Diego, CA, http://www.usenix.org/wiov08/
                     and
SYSTOR 2009---The Israeli Experimental Systems Conference
http://www.haifa.il.ibm.com/conferences/systor2009/
