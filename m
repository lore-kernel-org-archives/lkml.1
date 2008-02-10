Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYBJC7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYBJC7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 21:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYBJC7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 21:59:05 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:37662 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755070AbYBJC7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 21:59:04 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Silent compiler warning introduced by acea6852f32b8805e166d885ed7e9f0c7cd10d41 ([BLUETOOTH]: Move children of connection device to NULL before connection down.)
Date: Sun, 10 Feb 2008 04:57:17 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080201.769323)
Cc: davem@davemloft.net, torvalds@linux-foundation.org,
       hidave.darkstar@gmail.com, marcel@holtmann.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802100457.20143.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

Following patch silents

net/bluetooth/hci_sysfs.c: In function `del_conn':
net/bluetooth/hci_sysfs.c:339: warning: suggest parentheses around assignment used as truth value

compiler warning introduced by commit acea6852f32b8805e166d885ed7e9f0c7cd10d41 ([BLUETOOTH]: Move children of connection device to NULL before connection down.)

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

 net/bluetooth/hci_sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index e13cf5e..d2d1e4f 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -336,7 +336,7 @@ static void del_conn(struct work_struct *work)
 	struct device *dev;
 	struct hci_conn *conn = container_of(work, struct hci_conn, work);
 
-	while (dev = device_find_child(&conn->dev, NULL, __match_tty)) {
+	while ((dev = device_find_child(&conn->dev, NULL, __match_tty)) != NULL) {
 		device_move(dev, NULL);
 		put_device(dev);
 	}

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
