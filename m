Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZIRBu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZIRBu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 21:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZIRBuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 21:50:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:40031 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbZIRBuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 21:50:25 -0400
Subject: Re: [PATCH] fix ppc64 build failure on fedora
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090917174144.GA11961@bombadil.infradead.org>
References: <20090917174144.GA11961@bombadil.infradead.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 11:50:06 +1000
Message-Id: <1253238606.4932.23.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 13:41 -0400, Kyle McMartin wrote:
> From: Kyle McMartin <kyle@redhat.com>
> 
> For some reason or another (newer gcc?) on Fedora 12 koji builders we're
> seeing _restgpr0_$n symbols instead of _restgpr_$n as handled in the
> prom_init_check.sh file:
> Checking prom_init.o symbol '_restgpr0_14'
> Error: External symbol '_restgpr0_14' referenced from prom_init.c
> Checking prom_init.o symbol '_restgpr0_17'
> 
> Add cases to handle this to the filter portion of the script.

My concern tho is if one of thse is actually called ... we implement
them in arch/powerpc/lib/crtsaveres.S but with the "other" names..

Ben.

> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> ---
> 
> diff --git a/arch/powerpc/kernel/prom_init_check.sh b/arch/powerpc/kernel/prom_init_check.sh
> index 1ac136b..9f82f49 100644
> --- a/arch/powerpc/kernel/prom_init_check.sh
> +++ b/arch/powerpc/kernel/prom_init_check.sh
> @@ -52,12 +52,18 @@ do
>  	if [ "${UNDEF:0:9}" = "_restgpr_" ]; then
>  		OK=1
>  	fi
> +	if [ "${UNDEF:0:10}" = "_restgpr0_" ]; then
> +		OK=1
> +	fi
>  	if [ "${UNDEF:0:11}" = "_rest32gpr_" ]; then
>  		OK=1
>  	fi
>  	if [ "${UNDEF:0:9}" = "_savegpr_" ]; then
>  		OK=1
>  	fi
> +	if [ "${UNDEF:0:10}" = "_savegpr0_" ]; then
> +		OK=1
> +	fi
>  	if [ "${UNDEF:0:11}" = "_save32gpr_" ]; then
>  		OK=1
>  	fi
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

