Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbYEHGlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbYEHGlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbYEHGlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:41:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53866 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbYEHGl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:41:29 -0400
Date: Thu, 08 May 2008 15:41:27 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] call_usermodehelper_setup() should use GFP_KERNEL
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080508153337.0EEE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, call_usermodehelper_setup() use GFP_ATOMIC.
but it is slighly odd.
because call_usermodehelper() is always called process context.

GFP_KERNEL is robust and better.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "Paul Menage" <menage@google.com>
CC: Li Zefan <lizf@cn.fujitsu.com>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>
CC: Andi Kleen <ak@suse.de>
CC: Rusty Russell <rusty@rustcorp.com.au> 

---
 kernel/kmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/kernel/kmod.c
===================================================================
--- a/kernel/kmod.c	2008-04-29 17:37:41.000000000 +0900
+++ b/kernel/kmod.c	2008-05-06 20:20:02.000000000 +0900
@@ -360,7 +360,7 @@ struct subprocess_info *call_usermodehel
 						  char **argv, char **envp)
 {
 	struct subprocess_info *sub_info;
-	sub_info = kzalloc(sizeof(struct subprocess_info),  GFP_ATOMIC);
+	sub_info = kzalloc(sizeof(struct subprocess_info),  GFP_KERNEL);
 	if (!sub_info)
 		goto out;
 


