Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839Ab0ANWx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab0ANWx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894Ab0ANWxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:53:20 -0500
Received: from kroah.org ([198.145.64.141]:58185 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757814Ab0ANWwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:52:09 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Jan 14 14:48:06 2010
Message-Id: <20100114224806.743281302@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 14:46:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Florian Westphal <fwestphal@astaro.com>,
       Patrick McHardy <kaber@trash.net>
Subject: [4/9] netfilter: ebtables: enforce CAP_NET_ADMIN
In-Reply-To: <20100114224848.GA532@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Westphal <fwestphal@astaro.com>

commit dce766af541f6605fa9889892c0280bab31c66ab upstream.

normal users are currently allowed to set/modify ebtables rules.
Restrict it to processes with CAP_NET_ADMIN.

Note that this cannot be reproduced with unmodified ebtables binary
because it uses SOCK_RAW.

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bridge/netfilter/ebtables.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1405,6 +1405,9 @@ static int do_ebt_set_ctl(struct sock *s
 {
 	int ret;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	switch(cmd) {
 	case EBT_SO_SET_ENTRIES:
 		ret = do_replace(sock_net(sk), user, len);
@@ -1424,6 +1427,9 @@ static int do_ebt_get_ctl(struct sock *s
 	struct ebt_replace tmp;
 	struct ebt_table *t;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (copy_from_user(&tmp, user, sizeof(tmp)))
 		return -EFAULT;
 


