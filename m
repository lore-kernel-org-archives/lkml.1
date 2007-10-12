Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbXJLQFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbXJLQFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759715AbXJLQFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:05:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757971AbXJLQFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:05:39 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/52] Introduce credential record
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:05:19 +0100
Message-ID: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Al,

Here's a set of patches to partially implement cred passing.  This is in no
way complete yet.

The only complete chain is mkdir(), and only Ext3 and NFS are fully altered,
though I think NFS really needs redoing.  I'd like to come up with a way of
caching the rpc_cred struct inside the struct cred, but that needs some
thought.

Most of the vfs_xxxx() structs grab current->cred and pass it on down.
vfs_mkdir() is currently the only one that gets given it.

There are also holes in fs/buffer.c that need patching up, and most of the
other filesystems haven't yet been touched.

Note that I haven't included keyrings or capabilties or LSM data at this time.

Note also that this patch set is built on top of the iget patch set I've
posted to LKML earlier today.

David
