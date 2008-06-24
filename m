Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYFXVl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYFXVl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYFXVlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:41:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:39374 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbYFXVlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:41:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jIFzsGNsfJ4SZFxuoQ+rOBtl2ZfF39SQ5eYWt2RDvil9r3r3lLIjvHtIazxwE78yuc
         kAM80d/8Hu1CBmR4nKRJ5F0VzQuB+HHNm+tYDLFNFyQqTx8RRE5iCfkQ68UB56tIuVxP
         hncQLGQLy7Y3ZNGpPMKrxF3XybaQr1VVox/Jg=
Message-ID: <86802c440806241441v5f2c0870g379695cacd5dfb9b@mail.gmail.com>
Date: Tue, 24 Jun 2008 14:41:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: fix pte allocation in "x86: introduce init_memory_mapping for 32bit"
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48616800.8030603@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48616800.8030603@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 2:32 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> The patch "x86: introduce init_memory_mapping for 32bit" does not allocate
> enough space for PTEs if the CPU does not implement PSE.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Yinghai Lu <yhlu.kernel@gmail.com>
> ---
> arch/x86/mm/init_32.c |    5 +++++
> 1 file changed, 5 insertions(+)
>
> ===================================================================
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -733,6 +733,11 @@
>        pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
>        tables += PAGE_ALIGN(pmds * sizeof(pmd_t));
>
> +       if (!cpu_has_pse) {
> +               int ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +               tables += PAGE_ALIGN(ptes * sizeof(pte_t));
> +       }
> +
>        /*
>         * RED-PEN putting page tables only on node 0 could
>         * cause a hotspot and fill up ZONE_DMA. The page tables
>
thanks.

my test system never use the area from table_start to table_end. and I
wonder why init_pgtable is that big..

YH
