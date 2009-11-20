Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZKTQm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZKTQm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbZKTQmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:42:55 -0500
Received: from cantor.suse.de ([195.135.220.2]:41536 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbZKTQlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:41:00 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/15] airo: Use ppos instead of file->f_pos
Date: Fri, 20 Nov 2009 17:40:38 +0100
Message-Id: <1258735245-25826-9-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258735245-25826-1-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When updating the priv->writelen value the ppos given to proc_write()
should be used instead of file->f_pos. This might lead to a wrong writelen
value when pwrite() is used.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/net/wireless/airo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index abf896a..ae7dea8 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -4659,7 +4659,7 @@ static ssize_t proc_write( struct file *file,
 	if (copy_from_user(priv->wbuffer + pos, buffer, len))
 		return -EFAULT;
 	if ( pos + len > priv->writelen )
-		priv->writelen = len + file->f_pos;
+		priv->writelen = pos + len;
 	*offset = pos + len;
 	return len;
 }
-- 
1.6.4.2

