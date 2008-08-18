Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbYHRVmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbYHRVmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYHRVmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:42:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:37971 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYHRVmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:42:24 -0400
Subject: Re: [PATCH] POWERPC: duplicate test of MACIO_FLAG_SCCB_ON
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: roel kluin <roel.kluin@gmail.com>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <48A9F8E9.8030303@gmail.com>
References: <48A9F8E9.8030303@gmail.com>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 07:42:13 +1000
Message-Id: <1219095733.28339.77.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 18:34 -0400, roel kluin wrote:
> untested, is it correct?

Your patch is correct. The bug is quite harmless thankfully :-)

Ben.
 
> arch/powerpc/include/asm/pmac_feature.h:359:
> #define MACIO_FLAG_SCCA_ON  0x00000001
> #define MACIO_FLAG_SCCB_ON  0x00000002
> ---
> duplicate test of MACIO_FLAG_SCCB_ON
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/arch/powerpc/platforms/powermac/feature.c b/arch/powerpc/platforms/powermac/feature.c
> index 5169ecc..e6c0040 100644
> --- a/arch/powerpc/platforms/powermac/feature.c
> +++ b/arch/powerpc/platforms/powermac/feature.c
> @@ -2677,7 +2677,7 @@ static void __init probe_one_macio(const char *name, const char *compat, int typ
>  	macio_chips[i].of_node	= node;
>  	macio_chips[i].type	= type;
>  	macio_chips[i].base	= base;
> -	macio_chips[i].flags	= MACIO_FLAG_SCCB_ON | MACIO_FLAG_SCCB_ON;
> +	macio_chips[i].flags	= MACIO_FLAG_SCCA_ON | MACIO_FLAG_SCCB_ON;
>  	macio_chips[i].name	= macio_names[type];
>  	revp = of_get_property(node, "revision-id", NULL);
>  	if (revp)

