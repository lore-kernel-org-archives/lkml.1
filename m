Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbZHNNBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbZHNNBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbZHNNBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:01:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35631 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZHNNBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:01:40 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 14 Aug 2009 14:01:34 +0100
Message-Id: <1250254894.3298.204.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following fix,

Steve.

------------------------------------------------------------------------
The following changes since commit 64f1607ffbbc772685733ea63e6f7f4183df1b16:
  Linus Torvalds (1):
        Linux 2.6.31-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Steven Whitehouse (1):
      GFS2: Fix permissions on "recover" file

 fs/gfs2/sys.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

---------------------------------------------------------------------------

>From d7e623da1a757fbd8c117fa29190ca8bef14dab3 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Tue, 11 Aug 2009 11:20:11 +0100
Subject: [PATCH] GFS2: Fix permissions on "recover" file

Although this file is only ever written and not read by
userspace, it seems that the utils are opening this
file O_RDWR, so we need to allow that.

Also fixes the whitespace which seemed to be broken.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: David Teigland <teigland@redhat.com>
---
 fs/gfs2/sys.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 23419dc..a7cbfbd 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -386,16 +386,16 @@ static ssize_t jid_show(struct gfs2_sbd *sdp, char *buf)
 #define GDLM_ATTR(_name,_mode,_show,_store) \
 static struct gfs2_attr gdlm_attr_##_name = __ATTR(_name,_mode,_show,_store)
 
-GDLM_ATTR(proto_name,     0444, proto_name_show,	NULL);
-GDLM_ATTR(block,          0644, block_show,		block_store);
-GDLM_ATTR(withdraw,       0644, withdraw_show,		withdraw_store);
-GDLM_ATTR(id,             0444, lkid_show,		NULL);
-GDLM_ATTR(jid,		  0444, jid_show,		NULL);
-GDLM_ATTR(first,          0444, lkfirst_show,		NULL);
-GDLM_ATTR(first_done,     0444, first_done_show,	NULL);
-GDLM_ATTR(recover,        0200, NULL,			recover_store);
-GDLM_ATTR(recover_done,   0444, recover_done_show,	NULL);
-GDLM_ATTR(recover_status, 0444, recover_status_show,	NULL);
+GDLM_ATTR(proto_name,		0444, proto_name_show,		NULL);
+GDLM_ATTR(block,		0644, block_show,		block_store);
+GDLM_ATTR(withdraw,		0644, withdraw_show,		withdraw_store);
+GDLM_ATTR(id,			0444, lkid_show,		NULL);
+GDLM_ATTR(jid,			0444, jid_show,			NULL);
+GDLM_ATTR(first,		0444, lkfirst_show,		NULL);
+GDLM_ATTR(first_done,		0444, first_done_show,		NULL);
+GDLM_ATTR(recover,		0600, NULL,			recover_store);
+GDLM_ATTR(recover_done,		0444, recover_done_show,	NULL);
+GDLM_ATTR(recover_status,	0444, recover_status_show,	NULL);
 
 static struct attribute *lock_module_attrs[] = {
 	&gdlm_attr_proto_name.attr,
-- 
1.6.2.5



