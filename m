Return-Path: <linux-kernel-owner+w=401wt.eu-S932814AbZJPRY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbZJPRY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZJPRSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:33 -0400
Received: from kroah.org ([198.145.64.141]:48541 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179AbZJPRS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:29 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:59 2009
Message-Id: <20091016171158.549828423@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>,
       James Morris <jmorris@namei.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [23/46] tpm-fixup-pcrs-sysfs-file-update
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=tpm-fixup-pcrs-sysfs-file-update.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

commit 0afd9056f1b43c9fcbfdf933b263d72023d382fe upstream.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Marcel Selhorst <m.selhorst@sirrix.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -742,7 +742,7 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
  * the module usage count.
  */
 #define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
-#define EXTEND_PCR_SIZE 34
+#define EXTEND_PCR_RESULT_SIZE 34
 static struct tpm_input_header pcrextend_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
 	.length = cpu_to_be32(34),
@@ -760,10 +760,9 @@ int tpm_pcr_extend(u32 chip_num, int pcr
 		return -ENODEV;
 
 	cmd.header.in = pcrextend_header;
-	BUILD_BUG_ON(be32_to_cpu(cmd.header.in.length) > EXTEND_PCR_SIZE);
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
-	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
+	rc = transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
 			  "attempting extend a PCR value");
 
 	module_put(chip->dev->driver->owner);


