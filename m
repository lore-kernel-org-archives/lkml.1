Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbZJFIWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbZJFIWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbZJFIWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:22:40 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:18214 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbZJFIWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:22:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=sxsEB8WEaFOilXc4h9fGxTca0rFd0KmnyO+8fNldv4Ithw1BfHxnnFr/+Sms1EN/iX
         UozTh1520611AsxKm3zoZxuM6lKYrSOgEYf5Yf/p/x0ls7iHeQQG2RQnpGsHOHsp6PvK
         P4YJsqSNWNaaCUw0pWvqz6z89RpoUgFBW/+l8=
From: Stephen Boyd <bebarino@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH] connector: Fix incompatible pointer type warning
Date: Tue,  6 Oct 2009 01:23:37 -0700
Message-Id: <1254817417-16157-1-git-send-email-bebarino@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1.44.ga1675
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7069331 (connector: Provide the sender's credentials to the
callback, 2009-10-02) changed callbacks to take two arguments but missed
this one.

drivers/connector/cn_proc.c: In function ‘cn_proc_init’:
drivers/connector/cn_proc.c:263: warning: passing argument 3 of
‘cn_add_callback’ from incompatible pointer type

Signed-off-by: Stephen Boyd <bebarino@gmail.com>
---
 drivers/connector/cn_proc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index abf4a25..6069790 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -227,7 +227,8 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
  * cn_proc_mcast_ctl
  * @data: message sent from userspace via the connector
  */
-static void cn_proc_mcast_ctl(struct cn_msg *msg)
+static void cn_proc_mcast_ctl(struct cn_msg *msg,
+			      struct netlink_skb_parms *nsp)
 {
 	enum proc_cn_mcast_op *mc_op = NULL;
 	int err = 0;
-- 
1.6.5.rc1.44.ga1675

