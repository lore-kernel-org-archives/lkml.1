Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbZLIThI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbZLIThI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787AbZLIThF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:37:05 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35242 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbZLIThE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:37:04 -0500
MIME-Version: 1.0
In-Reply-To: <20091209184030.GA10295@tux1.beaverton.ibm.com>
References: <20091209005901.GX10295@tux1.beaverton.ibm.com>
	 <61b968730912082104q7e47576am6b330ae19d732bf2@mail.gmail.com>
	 <20091209184030.GA10295@tux1.beaverton.ibm.com>
Date: Wed, 9 Dec 2009 13:37:09 -0600
Message-ID: <61b968730912091137v45ba41ccte425941eeeaa963d@mail.gmail.com>
Subject: Re: [PATCH v2] calgary: Increase the maximum PHB bus number
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

Thanks for fixing the comment

Acked-by: Jon Mason <jdmason@kudzu.us>

On Wed, Dec 9, 2009 at 12:40 PM, Darrick J. Wong <djwong@us.ibm.com> wrote:
> Newer systems (x3950M2) can have 48 PHBs per chassis and 8 chassis, so bump the
> limits up and provide an explanation of the requirements for each class.
>
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
> ---
>
>  arch/x86/kernel/pci-calgary_64.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
>
>
> diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
> index e6ec8a2..4b7eb90 100644
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
> + * The maximum PHB bus number.
> + * x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
> + * x3950M2: 4 chassis, 48 PHBs per chassis        = 192
> + * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
> + * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
> + */
> +#define MAX_PHB_BUS_NUM                384
> +
>  #define PHBS_PER_CALGARY       4
>
>  /* register offsets in Calgary's internal register space */
>
