Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbYGLLPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbYGLLPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 07:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYGLLOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 07:14:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50523 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYGLLOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 07:14:51 -0400
Date: Sat, 12 Jul 2008 20:14:21 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [mmotm] relay: fix build error
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080712201206.F6B0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

against: mmotm
patchname: relay-add-buffer-only-channels-useful-for-early-logging-fix.patch
applies after: relay-add-buffer-only-channels-useful-for-early-logging.patch

recently, smp_call_function remove retry argument.
it cause following build error on mmotm.

	kernel/relay.c: In function ‘relay_late_setup_files’:
	kernel/relay.c:754: error: too many arguments to function ‘smp_call_function_single’
	make[1]: *** [kernel/relay.o] error 1



Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Tom Zanussi <tzanussi@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>

---
 kernel/relay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/kernel/relay.c
===================================================================
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -751,7 +751,7 @@ int relay_late_setup_files(struct rchan 
 			/* relay_channels_mutex must be held, so wait. */
 			err = smp_call_function_single(i,
 						       __relay_set_buf_dentry,
-						       &disp, 0, 1);
+						       &disp, 1);
 		}
 		if (unlikely(err))
 			break;


