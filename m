Return-Path: <linux-kernel-owner+w=401wt.eu-S937234AbYBWIbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937234AbYBWIbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934274AbYBWIUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:20:09 -0500
Received: from po-out-1718.google.com ([72.14.252.154]:35865 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764657AbYBWIUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:20:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YhSiz/Y2sqinBxZH28Nkyrxdz8uO713l8Od++0gs77vpWEWBsK/2Ffpn27K68S+ksNW3BLbRKsqP5+An7vrbxZCIBFUS1w9b5/L16pJ2GNLHKC43F7gt51x31Gfz9OfLAn/d3O5q6DJ8kcd94mDxXCJCx/u3Dp4pvaOwXnBoTf0=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 05/16] parisc: use get_personality()
Date: Sat, 23 Feb 2008 16:14:08 +0800
Message-Id: <1203754509934-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12037544991876-git-send-email-xiyou.wangcong@gmail.com>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
 <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
 <1203754478165-git-send-email-xiyou.wangcong@gmail.com>
 <1203754488669-git-send-email-xiyou.wangcong@gmail.com>
 <12037544991876-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro instead of explicit reference
for parisc code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>

---
 arch/parisc/kernel/sys_parisc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index 4f58921..1515ced 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -259,7 +259,7 @@ long parisc_personality(unsigned long personality)
 {
 	long err;
 
-	if (personality(current->personality) == PER_LINUX32
+	if (personality(get_personality()) == PER_LINUX32
 	    && personality == PER_LINUX)
 		personality = PER_LINUX32;
 
@@ -275,7 +275,7 @@ long parisc_newuname(struct new_utsname __user *name)
 	int err = sys_newuname(name);
 
 #ifdef CONFIG_COMPAT
-	if (!err && personality(current->personality) == PER_LINUX32) {
+	if (!err && personality(get_personality()) == PER_LINUX32) {
 		if (__put_user(0, name->machine + 6) ||
 		    __put_user(0, name->machine + 7))
 			err = -EFAULT;
-- 
1.5.3.8

