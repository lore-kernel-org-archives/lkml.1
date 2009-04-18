Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbZDRG3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbZDRG3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 02:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbZDRG3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 02:29:01 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33441 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZDRG3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 02:29:00 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org, den@openvz.org, dwmw2@infradead.org,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <200904150009.n3F095J1011993@imap1.linux-foundation.org>
References: <200904150009.n3F095J1011993@imap1.linux-foundation.org>
Message-Id: <20090418152635.125D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Sat, 18 Apr 2009 15:28:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Denis V. Lunev <den@openvz.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/mtd/mtdcore.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff -puN drivers/mtd/mtdcore.c~mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char drivers/mtd/mtdcore.c
> --- a/drivers/mtd/mtdcore.c~mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char
> +++ a/drivers/mtd/mtdcore.c
> @@ -48,11 +48,11 @@ static LIST_HEAD(mtd_notifiers);
>   */
>  static void mtd_release(struct device *dev)
>  {
> -	struct mtd_info *mtd = dev_to_mtd(dev);
> +	dev_t index = MTD_DEVT(dev_to_mtd(dev));
>  
>  	/* remove /dev/mtdXro node if needed */
> -	if (MTD_DEVT(mtd->index))
> -		device_destroy(mtd_class, MTD_DEVT(mtd->index) + 1);
> +	if (index)
> +		device_destroy(mtd_class, index + 1);
>  }

I get compile failure problem on mmotm-0414.

=====================
mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char.patch remove one
warnig if CONFIG_MTD_CHAR=n.

but it introduce one compile error if CONFIG_MTD_CHAR=y/m.

    drivers/mtd/mtdcore.c: In function ‘mtd_release’:
    drivers/mtd/mtdcore.c:51: error: invalid operands to binary * (have ‘struct mtd_info *’ and ‘int’)



Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Denis V. Lunev <den@openvz.org>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/mtd/mtdcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/mtd/mtdcore.c
===================================================================
--- a/drivers/mtd/mtdcore.c	2009-04-16 21:43:18.000000000 +0900
+++ b/drivers/mtd/mtdcore.c	2009-04-16 21:44:23.000000000 +0900
@@ -48,7 +48,7 @@ static LIST_HEAD(mtd_notifiers);
  */
 static void mtd_release(struct device *dev)
 {
-	dev_t index = MTD_DEVT(dev_to_mtd(dev));
+	dev_t index = MTD_DEVT(dev_to_mtd(dev)->index);
 
 	/* remove /dev/mtdXro node if needed */
 	if (index)



