Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbZKHMW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbZKHMW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbZKHMWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:22:55 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49545 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbZKHMWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:34 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 13/23] sysctl crypto: Remove dead binary sysctl support
Date: Sun,  8 Nov 2009 04:22:00 -0800
Message-Id: <1257682930-31401-13-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sys_sysctl is a generic wrapper around /proc/sys  .ctl_name
and .strategy members of sysctl tables are dead code.  Remove them.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 crypto/proc.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/crypto/proc.c b/crypto/proc.c
index 5dc07e4..fe95975 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -25,28 +25,22 @@
 #ifdef CONFIG_CRYPTO_FIPS
 static struct ctl_table crypto_sysctl_table[] = {
 	{
-		.ctl_name       = CTL_UNNUMBERED,
 		.procname       = "fips_enabled",
 		.data           = &fips_enabled,
 		.maxlen         = sizeof(int),
 		.mode           = 0444,
 		.proc_handler   = &proc_dointvec
 	},
-	{
-		.ctl_name = 0,
-	},
+	{}
 };
 
 static struct ctl_table crypto_dir_table[] = {
 	{
-		.ctl_name       = CTL_UNNUMBERED,
 		.procname       = "crypto",
 		.mode           = 0555,
 		.child          = crypto_sysctl_table
 	},
-	{
-		.ctl_name = 0,
-	},
+	{}
 };
 
 static struct ctl_table_header *crypto_sysctls;
-- 
1.6.5.2.143.g8cc62

