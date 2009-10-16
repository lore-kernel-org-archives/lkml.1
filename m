Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZJPRYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZJPRYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbZJPRSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:34 -0400
Received: from kroah.org ([198.145.64.141]:48548 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbZJPRSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:30 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:59 2009
Message-Id: <20091016171159.107320961@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>,
       James Morris <jmorris@namei.org>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [24/46] TPM: fix pcrread
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=tpm-fix-pcrread.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

commit 15d031c394e7bef9da4ec764e6b0330d701a0126 upstream.

The previously sent patch:

http://marc.info/?l=tpmdd-devel&m=125208945007834&w=2

Had its first hunk cropped when merged, submitting only this first hunk
again.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Marcel Selhorst <m.selhorst@sirrix.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
Tested-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -696,8 +696,7 @@ int __tpm_pcr_read(struct tpm_chip *chip
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	BUILD_BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
-	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
+	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
 			  "attempting to read a pcr value");
 
 	if (rc == 0)


