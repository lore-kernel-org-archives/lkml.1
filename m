Return-Path: <linux-kernel-owner+w=401wt.eu-S1760364AbYGQCDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760364AbYGQCDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 22:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbYGQCCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 22:02:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62916 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757568AbYGQCCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 22:02:43 -0400
Message-ID: <487EA7DE.5070204@cn.fujitsu.com>
Date: Thu, 17 Jul 2008 10:01:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: cminyard@mvista.com
CC: LKML <linux-kernel@vger.kernel.org>,
       openipmi-developer@lists.sourceforge.net,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] ipmi: list_for_each_entry_rcu() cleanup
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the rcu update side, don't use list_for_each_entry_rcu().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/char/ipmi/ipmi_msghandler.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 8a59aaa..987f3c3 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -986,7 +986,7 @@ int ipmi_destroy_user(ipmi_user_t user)
 	 * synchronize_rcu()) then free everything in that list.
 	 */
 	mutex_lock(&intf->cmd_rcvrs_mutex);
-	list_for_each_entry_rcu(rcvr, &intf->cmd_rcvrs, link) {
+	list_for_each_entry(rcvr, &intf->cmd_rcvrs, link) {
 		if (rcvr->user == user) {
 			list_del_rcu(&rcvr->link);
 			rcvr->next = rcvrs;
-- 
1.5.4.rc3

