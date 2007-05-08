Return-Path: <linux-kernel-owner+w=401wt.eu-S1032079AbXEHUMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032079AbXEHUMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032045AbXEHUMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:12:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032034AbXEHUM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:12:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] smaps: only define clear_refs for CONFIG_MMU
To: torvalds@osdl.org, akpm@osdl.org
Cc: rientjes@google.com, linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Tue, 08 May 2007 21:11:38 +0100
Message-ID: <20070508201138.2302.87781.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

/proc/pid/clear_refs is only defined in the CONFIG_MMU case, so make sure we
don't have any references to clear_refs_smap() in generic procfs code.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/proc/base.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index ec158dd..5602ae4 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -715,6 +715,7 @@ static const struct file_operations proc_oom_adjust_operations = {
 	.write		= oom_adjust_write,
 };
 
+#ifdef CONFIG_MMU
 static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -748,6 +749,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 static struct file_operations proc_clear_refs_operations = {
 	.write		= clear_refs_write,
 };
+#endif
 
 #ifdef CONFIG_AUDITSYSCALL
 #define TMPBUFLEN 21

