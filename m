Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574Ab0AEUIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab0AEUIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560Ab0AEUIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:08:32 -0500
Received: from kroah.org ([198.145.64.141]:50054 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517Ab0AEUGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:25 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:03 2010
Message-Id: <20100105200303.010531851@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [31/39] generic_permission: MAY_OPEN is not write access
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Serge E. Hallyn <serue@us.ibm.com>

commit 7ea6600148c265b1fd53e521022b1d7aec81d974 upstream.

generic_permission was refusing CAP_DAC_READ_SEARCH-enabled
processes from opening DAC-protected files read-only, because
do_filp_open adds MAY_OPEN to the open mask.

Ignore MAY_OPEN.  After this patch, CAP_DAC_READ_SEARCH is
again sufficient to open(fname, O_RDONLY) on a file to which
DAC otherwise refuses us read permission.

Reported-by: Mike Kazantsev <mk.fraggod@gmail.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Mike Kazantsev <mk.fraggod@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -221,6 +221,7 @@ int generic_permission(struct inode *ino
 	/*
 	 * Searching includes executable on directories, else just read.
 	 */
+	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
 	if (mask == MAY_READ || (S_ISDIR(inode->i_mode) && !(mask & MAY_WRITE)))
 		if (capable(CAP_DAC_READ_SEARCH))
 			return 0;


