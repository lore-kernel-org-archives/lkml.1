Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZKTQlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZKTQlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbZKTQlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:41:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:41549 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbZKTQlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:41:05 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       Felix Beck <felix.beck@de.ibm.com>,
       Ralph Wuerthner <ralph.wuerthner@de.ibm.com>, linux390@de.ibm.com
Subject: [PATCH 11/15] zcrypt: Use nonseekable_open()
Date: Fri, 20 Nov 2009 17:40:41 +0100
Message-Id: <1258735245-25826-12-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258735245-25826-1-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zcrypt doesn't even allow to read/write the files it opens. So seeking on
it shouldn't fall back to defaults either but should be disallowed as well.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/s390/crypto/zcrypt_api.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 65b6a96..4ff1820 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -302,7 +302,7 @@ static int zcrypt_open(struct inode *inode, struct file *filp)
 	lock_kernel();
 	atomic_inc(&zcrypt_open_count);
 	unlock_kernel();
-	return 0;
+	return nonseekable_open(inode, filp);
 }
 
 /**
-- 
1.6.4.2

