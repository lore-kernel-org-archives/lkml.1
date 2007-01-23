Return-Path: <linux-kernel-owner+w=401wt.eu-S932433AbXAWBgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbXAWBgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932507AbXAWBgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:36:45 -0500
Received: from ms-smtp-01.texas.rr.com ([24.93.47.40]:36520 "EHLO
	ms-smtp-01.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493AbXAWBgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:36:44 -0500
From: Eric Van Hensbergen <ericvh@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
       Eric Van Hensbergen <ericvh@strongmad.texas.9grid.us>,
       Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH] 9p: null terminate error strings for debug print
Date: Mon, 22 Jan 2007 19:36:33 -0600
Message-Id: <11695161931724-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.5.0.rc1.gde38
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Van Hensbergen <ericvh@strongmad.texas.9grid.us> - unquoted

We weren't properly NULL terminating protocol error strings for our
debug printk resulting in garbage being included in the output when debug
was enabled.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 fs/9p/error.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/9p/error.c b/fs/9p/error.c
index ae91555..0d7fa4e 100644
--- a/fs/9p/error.c
+++ b/fs/9p/error.c
@@ -83,6 +83,7 @@ int v9fs_errstr2errno(char *errstr, int len)
 
 	if (errno == 0) {
 		/* TODO: if error isn't found, add it dynamically */
+		errstr[len] = 0;
 		printk(KERN_ERR "%s: errstr :%s: not found\n", __FUNCTION__,
 		       errstr);
 		errno = 1;
-- 
1.5.0.rc1.gde38

