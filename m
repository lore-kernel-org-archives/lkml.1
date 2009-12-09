Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbZLIFEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbZLIFEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbZLIFEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:04:36 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50859 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZLIFEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:04:35 -0500
MIME-Version: 1.0
In-Reply-To: <20091209005901.GX10295@tux1.beaverton.ibm.com>
References: <20091209005901.GX10295@tux1.beaverton.ibm.com>
Date: Tue, 8 Dec 2009 23:04:40 -0600
Message-ID: <61b968730912082104q7e47576am6b330ae19d732bf2@mail.gmail.com>
Subject: Re: [PATCH] calgary: Increase the maximum PHB bus number
From: Jon Mason <jdmason@kudzu.us>
To: djwong@us.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, discuss@x86-64.org,
       Corinna Schultz <coschult@us.ibm.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks fine, but please change the comment to be similar to the
other multi-line comments in the code.  This would look like:

/*
 * The maximum PHB bus number.
 * x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
 * x3950M2: 4 chassis, 48 PHBs per chassis           = 192
 * x3950 (PCIE): 8 chassis, 32 PHBs per chassis     = 256
 * x3950 (PCIX): 8 chassis, 16 PHBs per chassis     = 128
 */

Thanks,
Jon

On Tue, Dec 8, 2009 at 6:59 PM, Darrick J. Wong <djwong@us.ibm.com> wrote:
> Newer systems (x3950M2) can have 48 PHBs per chassis and 8 chassis, so bump the
> limits up and provide an explanation of the requirements for each class.
>
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
>
>  arch/x86/kernel/pci-calgary_64.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
>
>
> diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
> index e6ec8a2..a693037 100644
> --- a/arch/x86/kernel/pci-calgary_64.c
> +++ b/arch/x86/kernel/pci-calgary_64.c
> @@ -102,10 +102,15 @@ int use_calgary __read_mostly = 0;
>  #define PMR_SOFTSTOPFAULT      0x40000000
>  #define PMR_HARDSTOP           0x20000000
>
> -#define MAX_NUM_OF_PHBS                8 /* how many PHBs in total? */
> -#define MAX_NUM_CHASSIS                8 /* max number of chassis */
> -/* MAX_PHB_BUS_NUM is the maximal possible dev->bus->number */
> -#define MAX_PHB_BUS_NUM                (MAX_NUM_OF_PHBS * MAX_NUM_CHASSIS * 2)
> +/*
> +   The maximum PHB bus number.
> +   x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
> +   x3950M2: 4 chassis, 48 PHBs per chassis        = 192
> +   x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
> +   x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
> +*/
> +#define MAX_PHB_BUS_NUM                384
> +
>  #define PHBS_PER_CALGARY       4
>
>  /* register offsets in Calgary's internal register space */
>
