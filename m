Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbZJPRXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbZJPRXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbZJPRSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:39 -0400
Received: from kroah.org ([198.145.64.141]:48604 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbZJPRSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:36 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:03 2009
Message-Id: <20091016171202.927189279@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, serue@us.ibm.com,
       Philipp Reisner <philipp.reisner@linbit.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [31/46] dm/connector: Only process connector packages from privileged processes
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=dm-connector-only-process-connector-packages-from-privileged-processes.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Philipp Reisner <philipp.reisner@linbit.com>

(cherry picked from commit 93136335f9ad7a98b92eacda1b43dccbf063cd07)

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-log-userspace-transfer.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -133,6 +133,9 @@ static void cn_ulog_callback(struct cn_m
 {
 	struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);
 
+	if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
+		return;
+
 	spin_lock(&receiving_list_lock);
 	if (msg->len == 0)
 		fill_pkg(msg, NULL);


