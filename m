Return-Path: <linux-kernel-owner+w=401wt.eu-S1764942AbXHOIqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764942AbXHOIqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbXHOIqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:46:33 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54367 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752467AbXHOIqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:46:31 -0400
Message-ID: <387167585.28892@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 15 Aug 2007 16:46:25 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <rddunlap@osdl.org>, Martin Bligh <mbligh@google.com>
Subject: Re: [patch 2/2] Sort module list by pointer address to get
	coherent sleepable seq_file iterators
Message-ID: <20070815084625.GA18892@mail.ustc.edu.cn>
References: <20070812150844.305211039@polymtl.ca> <20070812151039.996081605@polymtl.ca> <20070815033945.GA13134@mail.ustc.edu.cn> <20070815041845.GJ21089@ftp.linux.org.uk> <20070815063741.GB5175@mail.ustc.edu.cn> <20070815065301.GK21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815065301.GK21089@ftp.linux.org.uk>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro,

Does this sounds like a good fix?
===

seq_file version fixes

- f_version is 'unsigned long', it's pointless to do more than that.
- m->version should not be reset when we are bumping up the buf size.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/seq_file.c            |    1 -
 include/linux/seq_file.h |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc3.orig/include/linux/seq_file.h
+++ linux-2.6.23-rc3/include/linux/seq_file.h
@@ -18,7 +18,7 @@ struct seq_file {
 	size_t from;
 	size_t count;
 	loff_t index;
-	loff_t version;
+	unsigned long version;
 	struct mutex lock;
 	const struct seq_operations *op;
 	void *private;
--- linux-2.6.23-rc3.orig/fs/seq_file.c
+++ linux-2.6.23-rc3/fs/seq_file.c
@@ -134,7 +134,6 @@ ssize_t seq_read(struct file *file, char
 		if (!m->buf)
 			goto Enomem;
 		m->count = 0;
-		m->version = 0;
 	}
 	m->op->stop(m, p);
 	m->count = 0;

