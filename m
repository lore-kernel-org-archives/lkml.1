Return-Path: <linux-kernel-owner+w=401wt.eu-S934575AbZJIXSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575AbZJIXSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761804AbZJIXSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:18:11 -0400
Received: from kroah.org ([198.145.64.141]:36867 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761791AbZJIXSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:18:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:03 2009
Message-Id: <20091009231003.148054572@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:09:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mimi Zohar <zohar@us.ibm.com>, James Morris <jmorris@namei.org>
Subject: [patch 24/26] IMA: open new file for read
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=ima-open-new-file-for-read.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

commit 6c1488fd581a447ec87c4b59f0d33f95f0aa441b upstream.

When creating a new file, ima_path_check() assumed the new file
was being opened for write. Call ima_path_check() with the
appropriate acc_mode so that the read/write counters are
incremented correctly.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1533,9 +1533,11 @@ int may_open(struct path *path, int acc_mode, int flag)
 	if (error)
 		return error;
 
-	error = ima_path_check(path,
-			       acc_mode & (MAY_READ | MAY_WRITE | MAY_EXEC),
+	error = ima_path_check(path, acc_mode ?
+			       acc_mode & (MAY_READ | MAY_WRITE | MAY_EXEC) :
+			       ACC_MODE(flag) & (MAY_READ | MAY_WRITE),
 			       IMA_COUNT_UPDATE);
+
 	if (error)
 		return error;
 	/*


