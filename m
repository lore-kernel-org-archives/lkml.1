Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZDOQmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZDOQmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZDOQm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:42:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:51092 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbZDOQm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:42:26 -0400
Subject: Re: [PATCH] Make radeon_reinitialize_M10() absent if its reference
 is #ifdef'd out
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090414155651.27671.36394.stgit@warthog.procyon.org.uk>
References: <20090414155651.27671.36394.stgit@warthog.procyon.org.uk>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 18:40:27 +0200
Message-Id: <1239813627.7443.18.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 16:56 +0100, David Howells wrote:
> Make radeon_reinitialize_M10() absent if its reference is #ifdef'd out
> (if
> CONFIG_PM=n or CONFIG_PPC_PMAC=n.  Otherwise a warning is given:
> 
>   CC      drivers/video/aty/radeon_pm.o
> drivers/video/aty/radeon_pm.c:1720: warning: 'radeon_reinitialize_M10'
> defined but not used
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Nah. You ifdef it with CONFIG_PPC_PMAC, but it can be used on x86
too (see the "BUGFIX" entries).

Cheers,
Ben.

> ---
> 
>  drivers/video/aty/radeon_pm.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/drivers/video/aty/radeon_pm.c
> b/drivers/video/aty/radeon_pm.c
> index 97a1f09..8655bbd 100644
> --- a/drivers/video/aty/radeon_pm.c
> +++ b/drivers/video/aty/radeon_pm.c
> @@ -1716,6 +1716,7 @@ static void radeon_pm_m10_reconfigure_mc(struct radeonfb_info *rinfo)
>  	OUTREG(MC_IND_INDEX, 0);
>  }
>  
> +#if defined(CONFIG_PM) && defined(CONFIG_PPC_PMAC)
>  static void radeon_reinitialize_M10(struct radeonfb_info *rinfo)
>  {
>  	u32 tmp, i;
> @@ -1940,6 +1941,7 @@ static void radeon_reinitialize_M10(struct radeonfb_info *rinfo)
>  	 */
>  	radeon_pm_m10_enable_lvds_spread_spectrum(rinfo);
>  }
> +#endif /* CONFIG_PM && CONFIG_PPC_PMAC */
>  
>  #ifdef CONFIG_PPC_OF
>  

