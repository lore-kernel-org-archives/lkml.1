Return-Path: <linux-kernel-owner+w=401wt.eu-S935232AbXGZQjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935232AbXGZQjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934385AbXGZQfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:35:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35658 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934449AbXGZQfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:35:11 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] misannotation in pppol2tp
Cc: linux-kernel@vger.kernel.org, jchapman@katalix.com, davem@daveloft.net
Message-Id: <E1IE6Iv-0005Lj-N2@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:35:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Address of auto variable is not a userland pointer.  A good thing, too,
since if pppol2tp_tunnel_getsockopt() would _really_ get a userland pointer
as argument, it would be an instant roothole...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/pppol2tp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pppol2tp.c b/drivers/net/pppol2tp.c
index f871760..266e8b3 100644
--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -2054,7 +2054,7 @@ end:
  */
 static int pppol2tp_tunnel_getsockopt(struct sock *sk,
 				      struct pppol2tp_tunnel *tunnel,
-				      int optname, int __user *val)
+				      int optname, int *val)
 {
 	int err = 0;
 
@@ -2077,7 +2077,7 @@ static int pppol2tp_tunnel_getsockopt(struct sock *sk,
  */
 static int pppol2tp_session_getsockopt(struct sock *sk,
 				       struct pppol2tp_session *session,
-				       int optname, int __user *val)
+				       int optname, int *val)
 {
 	int err = 0;
 
-- 
1.5.3.GIT


