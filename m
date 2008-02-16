Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbYBPCvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbYBPCvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 21:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbYBPCvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 21:51:40 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:43704 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452AbYBPCvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 21:51:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mXcKX31mXdfsFVcy71dWiplWsgi8zBJqBPDX35Y5/j+Z+xrevHnAZFj7mzxumIWMfJkzWcjs/WSG3wkZBGeHgOpHLCnV7FO43j0TW0DvviPZVA8xlnKSSv4jRjsOpcZv11dDSxGir3gpqifaew2PpXYC3a75f+jqY2JINVGc9jI=
Subject: Re: [PATCHv2] autofs4: fix sparse warning in root.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1203130061.3172.8.camel@raven.themaw.net>
References: <1203126572.7442.13.camel@brick>
	 <1203130061.3172.8.camel@raven.themaw.net>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 18:51:36 -0800
Message-Id: <1203130296.7442.22.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/autofs4/root.c:536:23: warning: symbol 'ino' shadows an earlier one
fs/autofs4/root.c:510:22: originally declared here

There is no need to redeclare, we are at the end of the loop and in
the next iteration of the loop, ino will be reset.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/autofs4/root.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index a54a946..aa4c5ff 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -533,9 +533,9 @@ static struct dentry *autofs4_lookup_unhashed(struct autofs_sb_info *sbi, struct
 			goto next;
 
 		if (d_unhashed(dentry)) {
-			struct autofs_info *ino = autofs4_dentry_ino(dentry);
 			struct inode *inode = dentry->d_inode;
 
+			ino = autofs4_dentry_ino(dentry);
 			list_del_init(&ino->rehash);
 			dget(dentry);
 			/*
-- 
1.5.4.1.1278.gc75be



