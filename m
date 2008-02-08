Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbYBHQsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbYBHQsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762220AbYBHQs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:48:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:4638 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762224AbYBHQsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:48:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=hxOq9Lgv1ZA/0ldTgL/RAO/8nmzNA8gJS/SXPpLk3xwS5zTpEtLuK5M2ksO58meOrk0aA/ccPJbLzLyn8gr0P2XBCB8l1ivkDhBLifWhPCqIlsqioBNVqbah4MSXfEyBQDTJJmXa7BXnl7wW4ICIUrW+aYjX/owTFrxxsI2dgsU=
Message-ID: <47AC87CE.2060200@gmail.com>
Date: Fri, 08 Feb 2008 17:48:14 +0100
From: Jiri Olsa <olsajiri@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: rubini@vision.unipv.it
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] misc: ifdef KMOD, saving some bytes probably
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

found some code in misc.c that could be ifdef'ed for KMOD

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
---
 drivers/char/misc.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index a39101f..3455b09 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -126,7 +126,8 @@ static int misc_open(struct inode * inode, struct file * file)
 			break;
 		}
 	}
-		
+
+#if defined(CONFIG_KMOD)
 	if (!new_fops) {
 		mutex_unlock(&misc_mtx);
 		request_module("char-major-%d-%d", MISC_MAJOR, minor);
@@ -141,6 +142,10 @@ static int misc_open(struct inode * inode, struct file * file)
 		if (!new_fops)
 			goto fail;
 	}
+#else
+	if (!new_fops)
+		goto fail;
+#endif
 
 	err = 0;
 	old_fops = file->f_op;
