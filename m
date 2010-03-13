Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935969Ab0CMA6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:58:20 -0500
Received: from kroah.org ([198.145.64.141]:46792 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935385Ab0CMAbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:09 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:08 2010
Message-Id: <20100313002708.385659238@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [036/145] sparc32: Fix struct stat uid/gid types.
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 2531be413b3f2f64c0282073de89fe52bbcbbab5 ]

Commit 085219f79cad89291699bd2bfb21c9fdabafe65f
("sparc32: use proper types in struct stat")

Accidently changed the struct stat uid/gid members
to uid_t and gid_t, but those get set to
__kernel_uid32_t and __kernel_gid32_t respectively.
Those are of type 'int' but the structure is meant
to have 'short'.  So use uid16_t and gid16_t to
correct this.

Reported-by: Rob Landley <rob@landley.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/include/asm/stat.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/include/asm/stat.h
+++ b/arch/sparc/include/asm/stat.h
@@ -53,8 +53,8 @@ struct stat {
 	ino_t		st_ino;
 	mode_t		st_mode;
 	short		st_nlink;
-	uid_t		st_uid;
-	gid_t		st_gid;
+	uid16_t		st_uid;
+	gid16_t		st_gid;
 	unsigned short	st_rdev;
 	off_t		st_size;
 	time_t		st_atime;


