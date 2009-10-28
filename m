Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZJ1R4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZJ1R4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZJ1R4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:56:13 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:18217 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbZJ1R4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:56:12 -0400
Date: Wed, 28 Oct 2009 10:49:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, tpmdd-devel@lists.sourceforge.net
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] tpm: fix header for modular build
Message-Id: <20091028104926.385d350f.randy.dunlap@oracle.com>
In-Reply-To: <20091028190643.627f10aa.sfr@canb.auug.org.au>
References: <20091028190643.627f10aa.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4AE88530.0101:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build for TCG_TPM=m.  Header file doesn't handle this
and incorrectly builds stubs.

drivers/char/tpm/tpm.c:720: error: redefinition of 'tpm_pcr_read'
include/linux/tpm.h:35: error:previous definition of 'tpm_pcr_read' was here
drivers/char/tpm/tpm.c:752: error: redefinition of 'tpm_pcr_extend'
include/linux/tpm.h:38: error:previous definition of 'tpm_pcr_extend' was here

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/tpm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20091028.orig/include/linux/tpm.h
+++ linux-next-20091028/include/linux/tpm.h
@@ -27,7 +27,7 @@
  */
 #define	TPM_ANY_NUM 0xFFFF
 
-#if defined(CONFIG_TCG_TPM)
+#if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
 
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
