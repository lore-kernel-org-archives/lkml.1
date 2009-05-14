Return-Path: <linux-kernel-owner+w=401wt.eu-S1762442AbZENXHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762442AbZENXHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762277AbZENW6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:58:44 -0400
Received: from kroah.org ([198.145.64.141]:46052 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762249AbZENW6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:58:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:52:38 2009
Message-Id: <20090514225238.505627993@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:51:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-fsdevel@vger.kernel.org,
       linux-mm@vger.kernel.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [patch 13/28] NFS: Fix the return value in nfs_page_mkwrite()
References: <20090514225126.907908936@mini.kroah.org>
Content-Disposition: inline; filename=nfs-fix-the-return-value-in-nfs_page_mkwrite.patch
In-Reply-To: <20090514225413.GA705@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 2b2ec7554cf7ec5e4412f89a5af6abe8ce950700 upstream

Commit c2ec175c39f62949438354f603f4aa170846aabb ("mm: page_mkwrite
change prototype to match fault") exposed a bug in the NFS
implementation of page_mkwrite.  We should be returning 0 on success...

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/file.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -477,8 +477,6 @@ static int nfs_vm_page_mkwrite(struct vm
 		goto out_unlock;
 
 	ret = nfs_updatepage(filp, page, 0, pagelen);
-	if (ret == 0)
-		ret = pagelen;
 out_unlock:
 	unlock_page(page);
 	if (ret)


