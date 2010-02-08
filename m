Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab0BHHAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 02:00:45 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:62084 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0BHHAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 02:00:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=lC6lCPVxfFRVPzRx5Zc8UtjyttkQUl28HHDBymLvqgZ9glUt7aFBNXmA1UWFQbvVFp
         ZjHYDJKYBaV3KoWZ2aZO2OAaTF3YtxkBHdKtcSL0lxi+7hsG9FR8MFhJA9R0LgSXigfP
         sq9ODFWfvSEqa53zxVNWZvDOl1vY9iX6NckN0=
MIME-Version: 1.0
Date: Mon, 8 Feb 2010 15:00:43 +0800
Message-ID: <628d1651002072300i59bc192dy86fddca9713b5701@mail.gmail.com>
Subject: [PATCH] security/integrity/ima/ima_main.c: Fix return value
From: wzt wzt <wzt.wzt@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: zohar@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:
  In security/integrity/ima/ima_main.c ima_file_mmap() called by
security_file_mmap(), it depend on the return value of
ima_file_mmap(), not always return 0. see also in ima_bprm_check().


Signed-off-by: wzt <zhitong.wangzt@alibaba-inc.com>

diff --git a/security/integrity/ima/ima_main.c
b/security/integrity/ima/ima_main.c
index 294b005..705a991 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -271,7 +271,7 @@ int ima_file_mmap(struct file *file, unsigned long prot)
        if (prot & PROT_EXEC)
                rc = process_measurement(file, file->f_dentry->d_name.name,
                                         MAY_EXEC, FILE_MMAP);
-       return 0;
+       return rc;
 }

 /**
@@ -293,7 +293,7 @@ int ima_bprm_check(struct linux_binprm *bprm)

        rc = process_measurement(bprm->file, bprm->filename,
                                 MAY_EXEC, BPRM_CHECK);
-       return 0;
+       return rc;
 }
