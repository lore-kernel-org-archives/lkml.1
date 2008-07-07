Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbYGGRVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbYGGRVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbYGGRVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:21:10 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:55477 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbYGGRVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:21:09 -0400
X-BigFish: VPS-35(zz1432R98dR7efV1805Mzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K3NC6T-03-V8V-01
Date: Mon, 7 Jul 2008 19:20:57 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] AMD IOMMU: initialize IOMMU when GART is detected
Message-ID: <20080707172057.GZ14977@amd.com>
References: <1215441770-10314-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1215441770-10314-1-git-send-email-joerg.roedel@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 07 Jul 2008 17:20:57.0519 (UTC) FILETIME=[D1B4D3F0:01C8E055]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 04:42:50PM +0200, Joerg Roedel wrote:
> One of the last IOMMU updates covered a bug in the AMD IOMMU code. The early
> detection code does not succeed if the GART is already detected. This patch
> fixes this by removing the check for iommu_detected in the early detect code.
> On AMD systems only the GART code sets this variable to one beside the AMD
> IOMMU driver.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/amd_iommu_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> index 2a13e43..71e13af 100644
> --- a/arch/x86/kernel/amd_iommu_init.c
> +++ b/arch/x86/kernel/amd_iommu_init.c
> @@ -828,7 +828,7 @@ static int __init early_amd_iommu_detect(struct acpi_table_header *table)
>  
>  void __init amd_iommu_detect(void)
>  {
> -	if (swiotlb || no_iommu || iommu_detected)
> +	if (swiotlb || no_iommu)
>  		return;
>  
>  	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {

Argh. I posted the wrong version of the patch. Please ignore this one. I
will send an updated one.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

