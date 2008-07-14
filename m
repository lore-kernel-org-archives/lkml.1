Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYGNTFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYGNTFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 15:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbYGNTFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 15:05:35 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49149 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbYGNTFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 15:05:34 -0400
Subject: [PATCH] init/version.c: Define version_string only if
	CONFIG_KALLSYMS is not defined.
From: Daniel Guilak <guilak@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, daniel@danielguilak.com
In-Reply-To: <1215552069.10304.6.camel@dguilak-desk>
References: <1215552069.10304.6.camel@dguilak-desk>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 12:04:46 -0700
Message-Id: <1216062286.6497.18.camel@dguilak-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

int Version_* is only used with ksymoops, which is only needed (according to
README and Documentation/Changes) if CONFIG_KALLSYMS is NOT defined.  Therefore
this patch defines version_string only if CONFIG_KALLSYMS is not defined.

Signed-off-by: Daniel Guilak <daniel@danielguilak.com>
---
 init/version.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Depends on "[PATCH] init/version.c: Silenced sparse warning by declaring the version string."

diff --git a/init/version.c b/init/version.c
index 041fd82..52a8b98 100644
--- a/init/version.c
+++ b/init/version.c
@@ -13,11 +13,13 @@
 #include <linux/utsrelease.h>
 #include <linux/version.h>
 
+#ifndef CONFIG_KALLSYMS
 #define version(a) Version_ ## a
 #define version_string(a) version(a)
 
 extern int version_string(LINUX_VERSION_CODE);
 int version_string(LINUX_VERSION_CODE);
+#endif
 
 struct uts_namespace init_uts_ns = {
 	.kref = {
-- 
1.5.4.3



