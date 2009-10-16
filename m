Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbZJPRVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbZJPRVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbZJPRSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:43 -0400
Received: from kroah.org ([198.145.64.141]:48632 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752AbZJPRSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:39 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:04 2009
Message-Id: <20091016171204.475577693@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, serue@us.ibm.com,
       Philipp Reisner <philipp.reisner@linbit.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [34/46] uvesafb/connector: Disallow unpliviged users to send netlink packets
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=uvesafb-connector-disallow-unpliviged-users-to-send-netlink-packets.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Philipp Reisner <philipp.reisner@linbit.com>

(cherry picked from commit 30efa3f76813b17445bc5a2e443ae9731518566b)

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/uvesafb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -72,6 +72,9 @@ static void uvesafb_cn_callback(struct c
 	struct uvesafb_task *utask;
 	struct uvesafb_ktask *task;
 
+	if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
+		return;
+
 	if (msg->seq >= UVESAFB_TASKS_MAX)
 		return;
 


