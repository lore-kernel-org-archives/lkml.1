Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752Ab0AIQ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0AIQ7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 11:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712Ab0AIQ7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 11:59:17 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:39737 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab0AIQ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 11:59:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VFCwUsPeYfnRWtY43jpCDWHFC1a+zTRdBLap9jEx9oMRFAGeALPTXVot2zCrdEGucc
         AUpr3FmfEw3UpE4TwqCDwJT5l8wKuxrxt0+1qKCVct7Yy+pnMItSxEuquWbdt4Rdu6T4
         YF6V1uTCnDCE42xS+SRUAEjaH0tsqwVphRu6w=
Date: Sun, 10 Jan 2010 01:01:03 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: akpm@linux-foundation.org, daniel@caiaq.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: mxc: fix memory leak
Message-ID: <20100109170103.GB9190@hack>
References: <1263055387-31340-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263055387-31340-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 07:43:07PM +0300, Alexander Beregalov wrote:
>Free pdata before exit.
>Found by cppcheck.
>
>Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

This patch looks fine for me.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!

>---
> drivers/rtc/rtc-mxc.c |    6 ++++--
> 1 files changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
>index 6bd5072..2642e6b 100644
>--- a/drivers/rtc/rtc-mxc.c
>+++ b/drivers/rtc/rtc-mxc.c
>@@ -396,8 +396,10 @@ static int __init mxc_rtc_probe(struct platform_device *pdev)
> 	pdata->ioaddr = ioremap(res->start, resource_size(res));
> 
> 	clk = clk_get(&pdev->dev, "ckil");
>-	if (IS_ERR(clk))
>-		return PTR_ERR(clk);
>+	if (IS_ERR(clk)) {
>+		ret = PTR_ERR(clk);
>+		goto exit_free_pdata;
>+	}
> 
> 	rate = clk_get_rate(clk);
> 	clk_put(clk);
>-- 
>1.6.6
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
