Return-Path: <linux-kernel-owner+w=401wt.eu-S1751287AbZL1IZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbZL1IZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZL1IZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:25:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53450 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbZL1IZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:25:47 -0500
Date: Mon, 28 Dec 2009 09:25:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2/2] x86/amd-iommu: Fix initialization failure panic
Message-ID: <20091228082509.GG28652@elte.hu>
References: <1261408929-6261-1-git-send-email-joerg.roedel@amd.com>
 <1261408929-6261-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261408929-6261-3-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> The assumption that acpi_table_parse passes the return value
> of the hanlder function to the caller proved wrong
> recently. The return value of the handler function is
> totally ignored. This makes the initialization code for AMD
> IOMMU buggy in a way that could cause a kernel panic on
> initialization. This patch fixes the issue in the AMD IOMMU
> driver.
> 
> Cc: stable@kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/amd_iommu_init.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> index 1dca9c3..fb490ce 100644
> --- a/arch/x86/kernel/amd_iommu_init.c
> +++ b/arch/x86/kernel/amd_iommu_init.c
> @@ -138,6 +138,11 @@ int amd_iommus_present;
>  bool amd_iommu_np_cache __read_mostly;
>  
>  /*
> + * Set to true if ACPI table parsing and hardware intialization went properly
> + */
> +static bool amd_iommu_initialized;

Btw., could this new variable be __init?

	Ingo
