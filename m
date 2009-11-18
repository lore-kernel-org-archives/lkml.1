Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbZKRQHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbZKRQHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641AbZKRQHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:07:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618AbZKRQHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:07:37 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, Jan Blunck <jblunck@suse.de>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 2/2] BKL: Update documentation on llseek( =?ISO-8859-1?Q?=08?=)
Date: Wed, 18 Nov 2009 17:07:37 +0100
Message-Id: <1258560457-15129-2-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258560457-15129-1-git-send-email-jblunck@suse.de>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inode's i_size is not protected by the big kernel lock. Therefore it
does not make sense to recommend taking the BKL in filesystems llseek
operations. Instead it should use the inode's mutex or use just use
i_size_read() instead. Add a note that this is not protecting file->f_pos.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
---
 Documentation/filesystems/Locking |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 18b9d0c..25159d4 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -429,8 +429,9 @@ check_flags:		no
 implementations.  If your fs is not using generic_file_llseek, you
 need to acquire and release the appropriate locks in your ->llseek().
 For many filesystems, it is probably safe to acquire the inode
-semaphore.  Note some filesystems (i.e. remote ones) provide no
-protection for i_size so you will need to use the BKL.
+mutex or just to use i_size_read() instead.
+Note: this does not protect the file->f_pos against concurrent modifications
+since this is something the userspace has to take care about.
 
 Note: ext2_release() was *the* source of contention on fs-intensive
 loads and dropping BKL on ->release() helps to get rid of that (we still
-- 
1.6.4.2

