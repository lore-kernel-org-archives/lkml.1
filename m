Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646Ab0ANWjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab0ANWjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606Ab0ANWiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:38:24 -0500
Received: from kroah.org ([198.145.64.141]:60526 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab0ANW2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:24 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/52] SUNRPC: Fix the return value in gss_import_sec_context()
Date: Thu, 14 Jan 2010 14:26:49 -0800
Message-Id: <1263508051-7868-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-9-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit b891e4a05ef6beac85465295a032431577c66b16 upstream.

If the context allocation fails, it will return GSS_S_FAILURE, which is
neither a valid error code, nor is it even negative.

Return ENOMEM instead...

Reported-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sunrpc/auth_gss/gss_mech_switch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/auth_gss/gss_mech_switch.c b/net/sunrpc/auth_gss/gss_mech_switch.c
index 6efbb0c..76e4c6f 100644
--- a/net/sunrpc/auth_gss/gss_mech_switch.c
+++ b/net/sunrpc/auth_gss/gss_mech_switch.c
@@ -252,7 +252,7 @@ gss_import_sec_context(const void *input_token, size_t bufsize,
 		       struct gss_ctx		**ctx_id)
 {
 	if (!(*ctx_id = kzalloc(sizeof(**ctx_id), GFP_KERNEL)))
-		return GSS_S_FAILURE;
+		return -ENOMEM;
 	(*ctx_id)->mech_type = gss_mech_get(mech);
 
 	return mech->gm_ops
-- 
1.6.6

