Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZJUP2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZJUP2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 11:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZJUP2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 11:28:05 -0400
Received: from ozlabs.org ([203.10.76.45]:42509 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbZJUP2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 11:28:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 1/2] param: don't make the kernel_param's const
Date: Thu, 22 Oct 2009 01:58:04 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <s5haazv1sw5.wl%tiwai@suse.de>
In-Reply-To: <s5haazv1sw5.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910220158.05014.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of charp params written via sysfs, we modify the flags word.
On platforms where ro data is protected, this causes a fault.

Better is to get rid of that flags modification, but that patch series is
non-trivial.

Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -90,7 +90,7 @@ struct kparam_array
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
 	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
 	static const char __param_str_##name[] = prefix #name;		\
-	static struct kernel_param __moduleparam_const __param_##name	\
+	static struct kernel_param __param_##name			\
 	__used								\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
 	= { __param_str_##name, perm, isbool ? KPARAM_ISBOOL : 0,	\
