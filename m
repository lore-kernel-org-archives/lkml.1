Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbZFCBgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbZFCBgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 21:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZFCBf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 21:35:58 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:60950 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZFCBf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 21:35:58 -0400
Message-Id: <200906030135.n531ZvGb059761@www262.sakura.ne.jp>
Subject: [PATCH] Return a negative error code when seq_path_root() fails.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Jun 2009 10:35:57 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 03062009 #2077452, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seq_path_root() is returning a return value of successful __d_path()
instead of returning a negative value when mangle_path() failed.

This is not a bug so far because nobody is using return value of
seq_path_root().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/seq_file.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.30-rc7.orig/fs/seq_file.c
+++ linux-2.6.30-rc7/fs/seq_file.c
@@ -470,6 +470,7 @@ int seq_path_root(struct seq_file *m, st
 				m->count = s - m->buf;
 				return 0;
 			}
+			err = -ENAMETOOLONG;
 		}
 	}
 	m->count = m->size;
