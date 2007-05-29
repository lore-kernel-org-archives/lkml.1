Return-Path: <linux-kernel-owner+w=401wt.eu-S1764446AbXE2Mi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764446AbXE2Mi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbXE2MiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:38:20 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:17698 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbXE2MiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:38:20 -0400
Date: Tue, 29 May 2007 16:46:45 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: pmeda@akamai.com, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] mutex_unlock() later in seq_lseek()
Message-ID: <20070529124645.GA10599@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All manipulations with struct seq_file::version are done under
struct seq_file::lock except one introduced in commit
d6b7a781c51c91dd054e5c437885205592faac21
aka "[PATCH] Speed up /proc/pid/maps"

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/seq_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -260,8 +260,8 @@ loff_t seq_lseek(struct file *file, loff
 				}
 			}
 	}
-	mutex_unlock(&m->lock);
 	file->f_version = m->version;
+	mutex_unlock(&m->lock);
 	return retval;
 }
 EXPORT_SYMBOL(seq_lseek);

