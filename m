Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZJPRSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZJPRSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZJPRSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:42 -0400
Received: from kroah.org ([198.145.64.141]:48624 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbZJPRSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:38 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:04 2009
Message-Id: <20091016171203.984772794@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, serue@us.ibm.com,
       Philipp Reisner <philipp.reisner@linbit.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [33/46] pohmelfs/connector: Disallow unpliviged users to configure pohmelfs
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=pohmelfs-connector-disallow-unpliviged-users-to-configure-pohmelfs.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Philipp Reisner <philipp.reisner@linbit.com>

(cherry picked from commit 0179065b13b354cc0b940e7a632a65ec0448beff)

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/pohmelfs/config.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/pohmelfs/config.c
+++ b/drivers/staging/pohmelfs/config.c
@@ -450,6 +450,9 @@ static void pohmelfs_cn_callback(struct 
 {
 	int err;
 
+	if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
+		return;
+
 	switch (msg->flags) {
 		case POHMELFS_FLAGS_ADD:
 		case POHMELFS_FLAGS_DEL:


