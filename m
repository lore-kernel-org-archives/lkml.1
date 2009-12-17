Return-Path: <linux-kernel-owner+w=401wt.eu-S1760546AbZLQA4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbZLQA4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763262AbZLQAzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:55:32 -0500
Received: from kroah.org ([198.145.64.141]:44550 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762058AbZLQAyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:54:47 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 16:47:09 2009
Message-Id: <20091217004709.378331483@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 16:46:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [17/18] jffs2: Fix long-standing bug with symlink garbage collection.
In-Reply-To: <20091217005306.GA6230@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Woodhouse <David.Woodhouse@intel.com>

commit 2e16cfca6e17ae37ae21feca080a6f2eca9087dc upstream.

Ever since jffs2_garbage_collect_metadata() was first half-written in
February 2001, it's been broken on architectures where 'char' is signed.
When garbage collecting a symlink with target length above 127, the payload
length would end up negative, causing interesting and bad things to happen.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jffs2/gc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/jffs2/gc.c
+++ b/fs/jffs2/gc.c
@@ -700,7 +700,8 @@ static int jffs2_garbage_collect_metadat
 	struct jffs2_raw_inode ri;
 	struct jffs2_node_frag *last_frag;
 	union jffs2_device_node dev;
-	char *mdata = NULL, mdatalen = 0;
+	char *mdata = NULL;
+	int mdatalen = 0;
 	uint32_t alloclen, ilen;
 	int ret;
 


