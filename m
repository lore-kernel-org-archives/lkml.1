Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbXDQAR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbXDQAR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 20:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbXDQAR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 20:17:26 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47120 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbXDQARZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 20:17:25 -0400
Date: Mon, 16 Apr 2007 19:24:03 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: "Wang, Baojun" <wangbj@lzu.edu.cn>
Cc: linux-kernel@vger.kernel.org, linuxppc-embedded@ozlabs.org
Subject: Re: PROBLEM: kernel 2.6.20.6 build failed for ppc board chestnut(ibm ppc 750GX/FX)
Message-ID: <20070417002402.GB23995@crusty.rchland.ibm.com>
References: <200704161313.04359.wangbj@lzu.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704161313.04359.wangbj@lzu.edu.cn>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 01:13:01PM +0800, Wang, Baojun wrote:
> PROBLEM: linux kernel 2.6.20.6 build failed for ppc board chestnut(ibm ppc 
> 750GX/FX)
> 

Confirmed.  arch/ppc isn't getting much love these days.

<snip>

> this brute force patch sould solve the problem:

This is missing a Signed-off-by: line.

> diff -Nru /tmp/linux-2.6.20.6/arch/ppc/platforms/chestnut.c \  
> linux-2.6.20.6/arch/ppc/platforms/chestnut.c
> 
> --- /tmp/linux-2.6.20.6/arch/ppc/platforms/chestnut.c   2007-04-07 
> 04:02:48.000000000 +0800
> +++ linux-2.6.20.6/arch/ppc/platforms/chestnut.c        2007-04-13 
> 17:09:03.000000000 +0800
> @@ -432,7 +432,9 @@
>         ptbl.name = "User FS";
>         ptbl.size = CHESTNUT_32BIT_SIZE;
> 
> -       physmap_map.size = CHESTNUT_32BIT_SIZE;
> +       // physmap_map.size = CHESTNUT_32BIT_SIZE;

Just remove this completely.  It's not needed any longer.

> +       physmap_configure(CHESTNUT_32BIT_BASE, CHESTNUT_32BIT_SIZE, 
> CONFIG_MTD_PHYSMAP_BANKWIDTH, NULL);

Technically, this call isn't needed.  The chestnut_defconfig already provides
the correct variables.

josh
