Return-Path: <linux-kernel-owner+w=401wt.eu-S1764579AbXHDJnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764579AbXHDJnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 05:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbXHDJnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 05:43:35 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34629 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbXHDJne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 05:43:34 -0400
Date: Sat, 4 Aug 2007 11:43:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joe Perches <joe@perches.com>
cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org, adaplas@pol.net,
       greg@kroah.com, jeff@garzik.org
Subject: Re: + remove-current-defines-and-uses-of-pr_err-add-pr_emerg.patch
 added to -mm tree
In-Reply-To: <1186179369.13852.36.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708041141560.11760@fbirervta.pbzchgretzou.qr>
References: <tI4NY5SL.1186153543.0764100.khali@localhost>
 <1186179369.13852.36.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 3 2007 15:16, Joe Perches wrote:
>On Fri, 2007-08-03 at 17:05 +0200, Jean Delvare wrote: 
>> Fine with me, but this first patch should still be correct per se.
>
>Add new pr_<level> printk(KERN_<level> fmt "\n", ##arg) to kernel.h
>pr_info and pr_debug are unchanged
>Remove local pr_err #defines
>Convert current uses of pr_err
>
>Signed-off-by:  Joe Perches <joe@perches.com>
>
>diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>index 4300bb4..6447072 100644
>--- a/include/linux/kernel.h
>+++ b/include/linux/kernel.h
>@@ -229,20 +229,24 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
> 			void *buf, size_t len);
> #define hex_asc(x)	"0123456789abcdef"[x]
> 
>+#define pr_emerg(fmt, arg...)	printk(KERN_EMERG fmt "\n", ##arg)
>+#define pr_alert(fmt, arg...)	printk(KERN_ALERT fmt "\n", ##arg)
>+#define pr_crit(fmt, arg...)	printk(KERN_CRIT fmt "\n", ##arg)
>+#define pr_err(fmt, arg...)	printk(KERN_ERR fmt "\n", ##arg)
>+#define pr_warn(fmt, arg...)	printk(KERN_WARNING fmt "\n", ##arg)
>+#define pr_notice(fmt, arg...)	printk(KERN_NOTICE fmt "\n", ##arg)
>+#define pr_info(fmt, arg...)	printk(KERN_INFO fmt, ##arg)
>+

Ugh. What do we have printk for then? I do not like this.
For pr_debug() it makes sense because its semantics change with
-DDEBUG and -UDEBUG, but for these pr_()s it does not seem so.


> 	if (omap_request_gpio(15)) {
>-		pr_err("can't request GPIO 15\n");
>+		pr_err(PFX "can't request GPIO 15");
> 		omap_free_gpio(14);
> 		r = -1;
> 		goto exit;
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>

	Jan
-- 
