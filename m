Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbYCGIPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbYCGIPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYCGIO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:14:56 -0500
Received: from imx9.toshiba.co.jp ([202.33.96.51]:61095 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbYCGIOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:14:55 -0500
Date: Fri, 07 Mar 2008 17:06:19 +0900 (JST)
Message-Id: <20080307.170619.-1300529804.kouish@swc.toshiba.co.jp>
To: paulus@samba.org
Cc: 12o3l@tiscali.nl, arnd@arndb.de, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPC: in celleb_show_cpuinfo() convert strncpy(x, y,
 sizeof(x)) to strlcpy
In-Reply-To: <47CFEF82.10709@tiscali.nl>
From: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin <12o3l@tiscali.nl> wrote:
> Roel Kluin wrote:
> > This patch was not yet tested. Please confirm it's right.
> 
> was too quick with the send button. the batch below is probably better
> ---
> strncpy does not append '\0' if the length of the source string equals
> the size parameter, strlcpy does.
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Acked-by: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>

I tested Roel's 2nd patch and it works good on Celleb.

> ---
> diff --git a/arch/powerpc/platforms/celleb/setup.c b/arch/powerpc/platforms/celleb/setup.c
> index f27ae1e..cbe09d9 100644
> --- a/arch/powerpc/platforms/celleb/setup.c
> +++ b/arch/powerpc/platforms/celleb/setup.c
> @@ -81,8 +81,7 @@ static void celleb_show_cpuinfo(struct seq_file *m)
>  
>  static int __init celleb_machine_type_hack(char *ptr)
>  {
> -	strncpy(celleb_machine_type, ptr, sizeof(celleb_machine_type));
> -	celleb_machine_type[sizeof(celleb_machine_type)-1] = 0;
> +	strlcpy(celleb_machine_type, ptr, sizeof(celleb_machine_type));
>  	return 0;
>  }
>  
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
