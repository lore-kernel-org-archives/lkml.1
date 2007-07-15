Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbXGOTCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbXGOTCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 15:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXGOTCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:02:12 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:41665
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751507AbXGOTCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:02:10 -0400
Date: Sun, 15 Jul 2007 21:03:39 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: PATCH [3/5] fs/super.c: use list_for_each_entry() instead of list_for_each()
Message-ID: <20070715190339.GH4034@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070715185409.GE4034@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715185409.GE4034@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fs/super.c: use list_for_each_entry() instead of list_for_each() in
sget()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/fs/super.c b/fs/super.c
index 5260d62..6866c92 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -335,14 +335,12 @@ struct super_block *sget(struct file_system_type *type,
 			void *data)
 {
 	struct super_block *s = NULL;
-	struct list_head *p;
+	struct super_block *old;
 	int err;
 
 retry:
 	spin_lock(&sb_lock);
-	if (test) list_for_each(p, &type->fs_supers) {
-		struct super_block *old;
-		old = list_entry(p, struct super_block, s_instances);
+	if (test) list_for_each_entry(old, &type->fs_supers, s_instances) {
 		if (!test(old, data))
 			continue;
 		if (!grab_super(old))

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

      El trabajo es el refugio de los que no tienen nada que hacer
                            (Oscar Wilde)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
