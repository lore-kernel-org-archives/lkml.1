Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbZJPRSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbZJPRSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbZJPRSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:41 -0400
Received: from kroah.org ([198.145.64.141]:48613 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199AbZJPRSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:38 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:03 2009
Message-Id: <20091016171203.401776193@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, serue@us.ibm.com,
       Philipp Reisner <philipp.reisner@linbit.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [32/46] dst/connector: Disallow unpliviged users to configure dst
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=dst-connector-disallow-unpliviged-users-to-configure-dst.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Philipp Reisner <philipp.reisner@linbit.com>

(cherry picked from commit dbbb3431228784612848a1ec6061c78b4b708b5c)

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/dst/dcore.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/staging/dst/dcore.c
+++ b/drivers/staging/dst/dcore.c
@@ -854,6 +854,11 @@ static void cn_dst_callback(struct cn_ms
 	struct dst_node *n = NULL, *tmp;
 	unsigned int hash;
 
+	if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN)) {
+		err = -EPERM;
+		goto out;
+	}
+
 	if (msg->len < sizeof(struct dst_ctl)) {
 		err = -EBADMSG;
 		goto out;


