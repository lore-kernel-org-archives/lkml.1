Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbXHQGls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbXHQGls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 02:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXHQGlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 02:41:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47231 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbXHQGli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 02:41:38 -0400
Date: Fri, 17 Aug 2007 12:24:23 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jeff Dike <jdike@addtoit.com>
cc: Joe Perches <joe@perches.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH] hostfs: Remove pointless if statement
In-Reply-To: <20070816145210.GD6670@c2.user-mode-linux.org>
Message-ID: <alpine.LFD.0.999.0708171208060.3666@enigma.security.iitk.ac.in>
References: <20070815235825.GB17004@redhat.com> <1187224811.5906.55.camel@localhost>
 <20070816145210.GD6670@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Cc: list heavily trimmed. ]


On Thu, 16 Aug 2007, Jeff Dike wrote:

> On Wed, Aug 15, 2007 at 05:40:11PM -0700, Joe Perches wrote:
> > fs/hostfs/hostfs_user.c:        if(attrs->ia_valid & HOSTFS_ATTR_CTIME) ;
> 
> This one can be deleted, but I think I did it for documentation
> reasons, to make it clear that ctime handling wasn't left out by
> mistake.


We normally use "comments" for that, not dead code that a compiler
then elids ;-)


[PATCH] hostfs: Remove pointless if statement

And replace with comment saying we don't handle ctime.
Also some codingstyle while I was there.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 fs/hostfs/hostfs_user.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
index 5625e24..a554a0a 100644
--- a/fs/hostfs/hostfs_user.c
+++ b/fs/hostfs/hostfs_user.c
@@ -283,12 +283,12 @@ int set_attr(const char *file, struct hostfs_iattr *attrs, int fd)
 		}
 	}
 
-	if(attrs->ia_valid & HOSTFS_ATTR_CTIME) ;
-	if(attrs->ia_valid & (HOSTFS_ATTR_ATIME | HOSTFS_ATTR_MTIME)){
+	/* ctime is not handled */
+	if (attrs->ia_valid & (HOSTFS_ATTR_ATIME | HOSTFS_ATTR_MTIME)){
 		err = stat_file(file, NULL, NULL, NULL, NULL, NULL, NULL,
 				&attrs->ia_atime, &attrs->ia_mtime, NULL,
 				NULL, NULL, fd);
-		if(err != 0)
+		if (err != 0)
 			return err;
 	}
 	return 0;
