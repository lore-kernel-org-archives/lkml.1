Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbYDSLlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbYDSLlY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 07:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYDSLlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 07:41:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59691 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbYDSLlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 07:41:14 -0400
Date: Sat, 19 Apr 2008 20:41:17 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFC patch 26/27] Immediate Values - Jump
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080416213557.859844730@polymtl.ca>
References: <20080416213426.298498397@polymtl.ca> <20080416213557.859844730@polymtl.ca>
Message-Id: <20080419203925.A900.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: linux-2.6-lttng/include/linux/immediate.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/immediate.h	2008-04-16 14:04:47.000000000 -0400
> +++ linux-2.6-lttng/include/linux/immediate.h	2008-04-16 14:04:48.000000000 -0400
> @@ -33,8 +33,7 @@
>   * Internal update functions.
>   */
>  extern void core_imv_update(void);
> -extern void imv_update_range(const struct __imv *begin,
> -	const struct __imv *end);
> +extern void imv_update_range(struct __imv *begin, struct __imv *end);
>  extern void imv_unref_core_init(void);
>  extern void imv_unref(struct __imv *begin, struct __imv *end, void *start,
>  		unsigned long size);
> @@ -54,6 +53,14 @@ extern void imv_unref(struct __imv *begi
>  #define imv_read(name)			_imv_read(name)
>  
>  /**
> + * imv_cond - read immediate variable use as condition for if()
> + * @name: immediate value name
> + *
> + * Reads the value of @name.
> + */
> +#define imv_cond			_imv_read(name)
> +
> +/**

err, missing name argument.



Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 include/linux/immediate.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/include/linux/immediate.h
===================================================================
--- a/include/linux/immediate.h 2008-04-19 20:57:19.000000000 +0900
+++ b/include/linux/immediate.h 2008-04-19 21:09:01.000000000 +0900
@@ -62,7 +62,7 @@ struct __imv {
  *
  * Reads the value of @name.
  */
-#define imv_cond                       _imv_read(name)
+#define imv_cond(name)                 _imv_read(name)

 /**
  * imv_set - set immediate variable (with locking)



