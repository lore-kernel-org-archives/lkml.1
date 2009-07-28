Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbZG1XJC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbZG1XJC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:09:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZG1XIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:08:50 -0400
Received: from kroah.org ([198.145.64.141]:42965 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583AbZG1XD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:03:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:43 2009
Message-Id: <20090728225943.151650963@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       WANG Cong <amwang@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       James Morris <jmorris@namei.org>
Subject: [patch 15/37] elf: fix one check-after-use
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=elf-fix-one-check-after-use.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amerigo Wang <amwang@redhat.com>

commit e2dbe12557d85d81f4527879499f55681c3cca4f upstream.

Check before use it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/binfmt_elf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1517,11 +1517,11 @@ static int fill_note_info(struct elfhdr 
 	info->thread = NULL;
 
 	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
-	fill_note(&info->psinfo, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);
-
 	if (psinfo == NULL)
 		return 0;
 
+	fill_note(&info->psinfo, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);
+
 	/*
 	 * Figure out how many notes we're going to need for each thread.
 	 */


