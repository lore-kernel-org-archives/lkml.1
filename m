Return-Path: <linux-kernel-owner+w=401wt.eu-S1761144AbXJLQMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144AbXJLQMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760048AbXJLQGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:06:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418AbXJLQGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:06:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/52] CRED: Make Ext3 use the writeback credentials
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:06:36 +0100
Message-ID: <20071012160635.15119.49014.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make Ext3 use the writeback credentials when performing writebacks.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index d7e1390..73b64f3 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1526,7 +1526,7 @@ static int ext3_journalled_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
-	struct cred *cred = current->cred;
+	struct cred *cred = &writeback_cred;
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;

