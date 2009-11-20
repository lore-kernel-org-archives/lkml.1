Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbZKTQlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbZKTQlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbZKTQlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:41:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:41574 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbZKTQlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:41:12 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 15/15] BKL: Update documentation on llseek( =?ISO-8859-1?Q?=08?=)
Date: Fri, 20 Nov 2009 17:40:45 +0100
Message-Id: <1258735245-25826-16-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258735245-25826-1-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
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

