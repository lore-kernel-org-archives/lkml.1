Return-Path: <linux-kernel-owner+w=401wt.eu-S1765350AbXHDQsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765350AbXHDQsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764829AbXHDQr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:47:57 -0400
Received: from zone4.gcu.info ([217.195.17.234]:59549 "EHLO
	zone4.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764126AbXHDQr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:47:56 -0400
Date: Sat, 4 Aug 2007 18:47:50 +0200 (CEST)
To: jengelh@computergmbh.de, joe@perches.com
Subject: Re: + remove-current-defines-and-uses-of-pr_err-add-pr_emerg.patch added to -mm tree
X-IlohaMail-Blah: khali@localhost
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.14 (On: mail.gcu-squad.org)
Message-ID: <0H03p0ll.1186246070.5043630.khali@localhost>
In-Reply-To: <Pine.LNX.4.64.0708041141560.11760@fbirervta.pbzchgretzou.qr>
From: "Jean Delvare" <khali@linux-fr.org>
Bounce-To: "Jean Delvare" <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, adaplas@pol.net, greg@kroah.com,
       jeff@garzik.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jan, Joe,

On 8/4/2007, "Jan Engelhardt" <jengelh@computergmbh.de> wrote:
>On Aug 3 2007 15:16, Joe Perches wrote:
>>On Fri, 2007-08-03 at 17:05 +0200, Jean Delvare wrote:
>>> Fine with me, but this first patch should still be correct per se.
>>
>>Add new pr_<level> printk(KERN_<level> fmt "\n", ##arg) to kernel.h
>>pr_info and pr_debug are unchanged
>>Remove local pr_err #defines
>>Convert current uses of pr_err
>>
>>Signed-off-by:  Joe Perches <joe@perches.com>
>>
>>diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>>index 4300bb4..6447072 100644
>>--- a/include/linux/kernel.h
>>+++ b/include/linux/kernel.h
>>@@ -229,20 +229,24 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
>> 			void *buf, size_t len);
>> #define hex_asc(x)	"0123456789abcdef"[x]
>>
>>+#define pr_emerg(fmt, arg...)	printk(KERN_EMERG fmt "\n", ##arg)
>>+#define pr_alert(fmt, arg...)	printk(KERN_ALERT fmt "\n", ##arg)
>>+#define pr_crit(fmt, arg...)	printk(KERN_CRIT fmt "\n", ##arg)
>>+#define pr_err(fmt, arg...)	printk(KERN_ERR fmt "\n", ##arg)
>>+#define pr_warn(fmt, arg...)	printk(KERN_WARNING fmt "\n", ##arg)
>>+#define pr_notice(fmt, arg...)	printk(KERN_NOTICE fmt "\n", ##arg)
>>+#define pr_info(fmt, arg...)	printk(KERN_INFO fmt, ##arg)
>>+
>
>Ugh. What do we have printk for then? I do not like this.
>For pr_debug() it makes sense because its semantics change with
>-DDEBUG and -UDEBUG, but for these pr_()s it does not seem so.

I think I agree with Jan here, I see no fundamental need for these
additional macros. But if they are really added, then they should follow
the same standard as pr_debug() and pr_info(), that is: no "\n" added
automatically. Otherwise this will become quite messy.

Thanks,
--
Jean Delvare
