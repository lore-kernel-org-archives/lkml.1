Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0BVCGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 21:06:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40518
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753876Ab0BVCGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 21:06:41 -0500
Date: Sun, 21 Feb 2010 18:06:58 -0800 (PST)
Message-Id: <20100221.180658.226784107.davem@davemloft.net>
To: rob@landley.net
Cc: qemu-devel@nongnu.org, blauwirbel@gmail.com, pbonzini@redhat.com,
       atar4qemu@googlemail.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Subject: Re: Commit 085219f79cad broke Sparc-32 back in 2.6.28.
From: David Miller <davem@davemloft.net>
In-Reply-To: <201002211025.11588.rob@landley.net>
References: <f43fc5581002201359x50aff2b1ofc4f816762bda597@mail.gmail.com>
	<201002201712.23628.rob@landley.net>
	<201002211025.11588.rob@landley.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's the fix I'll use, thanks for the report Rob:

sparc32: Fix struct stat uid/gid types.

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
---
 arch/sparc/include/asm/stat.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/stat.h b/arch/sparc/include/asm/stat.h
index 55db5ec..39327d6 100644
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
-- 
1.6.6.1

