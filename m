Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYLDOAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYLDOAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYLDOAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:00:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:10992 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbYLDOAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:00:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=viosk0Q/Jqxq4ZT4o5Nqv+lr5Yv/qtGZYsgJYXUC3gWCKjAFTpdDxryvVadvGnxS3+
         8JESMdKCd6YYvKfYEB0DSGR2HZMnU9mcOJGX2X2pFWJk0XOi1mMVonNAk6oKk0hw/mkx
         3N0asouWOZBMfW9LA+NIzJRqwxVwEZisgmISk=
Date: Thu, 4 Dec 2008 17:04:18 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Artem.Bityutskiy@nokia.com
Subject: next-2008-12-04: ubifs section fixlet
Message-ID: <20081204140418.GB13953@x200.localdomain>
References: <20081204200745.eff0ac87.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204200745.eff0ac87.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, fold into 552ff3179d1e93a3e982357544c059f3e9a5516e
aka "UBIFS: add debugfs support":

WARNING: fs/ubifs/ubifs.o(.init.text+0xec): Section mismatch in reference from the function init_module() to the function .exit.text:ubifs_compressors_exit()

--- a/fs/ubifs/compress.c
+++ b/fs/ubifs/compress.c
@@ -244,7 +244,7 @@ out_lzo:
 /**
  * ubifs_compressors_exit - de-initialize UBIFS compressors.
  */
-void __exit ubifs_compressors_exit(void)
+void ubifs_compressors_exit(void)
 {
 	compr_exit(&lzo_compr);
 	compr_exit(&zlib_compr);
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index e658b06..055c6b5 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1700,7 +1700,7 @@ long ubifs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 /* compressor.c */
 int __init ubifs_compressors_init(void);
-void __exit ubifs_compressors_exit(void);
+void ubifs_compressors_exit(void);
 void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int *out_len,
 		    int *compr_type);
 int ubifs_decompress(const void *buf, int len, void *out, int *out_len,
