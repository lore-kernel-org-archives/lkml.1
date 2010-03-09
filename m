Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab0CIVPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 16:15:06 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60209 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab0CIVPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 16:15:00 -0500
Date: Tue, 9 Mar 2010 22:14:58 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/5] drivers/staging/otus: drop redundant memset
Message-ID: <Pine.LNX.4.64.1003092214350.4974@ask.diku.dk>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511516320-430609882-1268169298=:4974"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-430609882-1268169298=:4974
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

From: Julia Lawall <julia@diku.dk>

The region set by the call to memset is immediately overwritten by the
subsequent call to memcpy.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,e3,e4;
@@

- memset(e1,e2,e3);
  memcpy(e1,e4,e3);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/otus/wwrap.c |    1 -
 1 file changed, 1 deletion(-)

diff -u -p a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
--- a/drivers/staging/otus/wwrap.c
+++ b/drivers/staging/otus/wwrap.c
@@ -955,7 +955,6 @@ int zfLnxCencSendMsg(struct sock *netlin
 	/*填写数据报相关信息*/
 	nlh = NLMSG_PUT(skb, 0, 0, WAI_K_MSG, size-sizeof(*nlh));
 	pos = NLMSG_DATA(nlh);
-	memset(pos, 0, len);
 
 	/*传输到用户空间的数据*/
 	memcpy(pos, msg,  len);
---511516320-430609882-1268169298=:4974--
