Return-Path: <linux-kernel-owner+w=401wt.eu-S2993026AbXCIHST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993026AbXCIHST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993040AbXCIHST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:18:19 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:6412 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993026AbXCIHSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:18:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=l2o6uFlDPk99/i/TjNRvpoNLNOsyBsMOZGF2eO83AvifiwN+qR9JMGw31ZGfSYXzwG3U1i4cGRo9BboV+XKvr5Dvt/nPfEIcllQOYfA1oGA71slSS67qByBOO8MZrxSeGF3RrnuGM8xkfVSD59cNtVD18ptGIu+7VDcNjOD468k=
Date: Thu, 8 Mar 2007 23:18:03 -0800
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/cifs/readdir.c: check kmalloc() return value.
Message-Id: <20070308231803.50e7268f.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Check the return value of kmalloc() in function cifs_readdir(), in file fs/cifs/readdir.c.

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index b5b0a2a..2d43b2a 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -1063,6 +1063,11 @@ int cifs_readdir(struct file *file, void
 		such multibyte target UTF-8 characters. cifs_unicode.c,
 		which actually does the conversion, has the same limit */
 		tmp_buf = kmalloc((2 * NAME_MAX) + 4, GFP_KERNEL);
+		if (!tmp_buf) {
+			cERROR(1, ("No memory!"));
+			rc = -ENOMEM;
+			goto rddir2_exit;
+		}
 		for(i=0;(i<num_to_fill) && (rc == 0);i++) {
 			if(current_entry == NULL) {
 				/* evaluate whether this case is an error */
