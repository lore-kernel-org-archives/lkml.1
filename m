Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbYHSNl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbYHSNl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYHSNlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:41:16 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:46525 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYHSNlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:41:14 -0400
X-Greylist: delayed 1957 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Aug 2008 09:41:14 EDT
Date: Tue, 19 Aug 2008 22:02:00 +0900 (JST)
Message-Id: <20080819.220200.-1300539182.kouish@swc.toshiba.co.jp>
To: roel.kluin@gmail.com
Cc: paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc, scc: duplicate SCC_UHC_USBCEN
In-Reply-To: <48A9F256.2000901@gmail.com>
From: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Roel,

> untested, is it correct?

Your patch is correct.

Thanks for your pointing it out and sending the patch. I tested your
patch and it works good.

Fortunately, this bug is not fatal because it seems that the SCC-UHC
sets SCC_UHC_USBEN and SCC_UHC_USBCEN at once.


Your patch does not contain 'Signed-off-by' line. Could you re-post it
with your sign?


> ---
> arch/powerpc/platforms/cell/celleb_scc.h:224:
> #define SCC_UHC_USBEN           0x00010000
> #define SCC_UHC_USBCEN          0x00020000
> 
> ---
> diff --git a/arch/powerpc/platforms/cell/celleb_scc_uhc.c b/arch/powerpc/platforms/cell/celleb_scc_uhc.c
> index d63b720..b086f33 100644
> --- a/arch/powerpc/platforms/cell/celleb_scc_uhc.c
> +++ b/arch/powerpc/platforms/cell/celleb_scc_uhc.c
> @@ -31,7 +31,7 @@
>  
>  static inline int uhc_clkctrl_ready(u32 val)
>  {
> -	const u32 mask = SCC_UHC_USBCEN | SCC_UHC_USBCEN;
> +	const u32 mask = SCC_UHC_USBCEN | SCC_UHC_USBEN;
>  	return((val & mask) == mask);
>  }
>  
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

Best regards,
Kou Ishizaki
