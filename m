Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbXFURgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbXFURgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbXFURg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:36:28 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:56914 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459AbXFURg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:36:27 -0400
Date: Thu, 21 Jun 2007 19:36:28 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andi Kleen <ak@suse.de>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for 2.6.22] [6/10] x86: Only make Macintosh drivers default on Macs
Message-ID: <20070621173628.GA21243@aepfle.de>
References: <200706201223.443613000@suse.de> <20070620102334.DD01814AD0@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070620102334.DD01814AD0@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, Andi Kleen wrote:

> 
> It's already annoying that they appear on x86 now -- that's for the 3button
> emulation needed on x86 macs -- but at least don't make them default.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  drivers/macintosh/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/macintosh/Kconfig
> ===================================================================
> --- linux.orig/drivers/macintosh/Kconfig
> +++ linux/drivers/macintosh/Kconfig
> @@ -2,7 +2,7 @@
>  menuconfig MACINTOSH_DRIVERS
>  	bool "Macintosh device drivers"
>  	depends on PPC || MAC || X86
> -	default y
> +	default y if MAC

This looks incorrect because my macdrivers were almost gone now when
updating from 2.6.21 to 2.6.22. 
A better one may be something like this, to not lose everything on a G5:

        depends on PPC_PMAC || MAC || X86
        default y if (PPC_PMAC || MAC)

