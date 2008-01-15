Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbYAOX4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbYAOX4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbYAOXtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:49:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757438AbYAOXsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:48:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/26] NFS: Fix memory leak
To: sds@tycho.nsa.gov, casey@schaufler-ca.com, Trond.Myklebust@netapp.com,
       npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Tue, 15 Jan 2008 23:48:50 +0000
Message-ID: <20080115234849.22183.67884.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
References: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memory leak whereby multiple clientaddr=xxx mount options just overwrite
the duplicated client_address option pointer, without freeing the old memory.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 0b0c72a..7f5e747 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -936,6 +936,7 @@ static int nfs_parse_mount_options(char *raw,
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
+			kfree(mnt->client_address);
 			mnt->client_address = string;
 			break;
 		case Opt_mountaddr:

