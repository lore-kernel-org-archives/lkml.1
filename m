Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab0BSRD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:03:26 -0500
Received: from kroah.org ([198.145.64.141]:57864 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108Ab0BSRBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:19 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:56 2010
Message-Id: <20100219163256.551334642@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nikanth Karthikesan <knikanth@suse.de>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [91/93] dm stripe: avoid divide by zero with invalid stripe count
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nikanth Karthikesan <knikanth@suse.de>

commit 781248c1b50c776a9ef4be1130f84ced1cba42fe upstream.

If a table containing zero as stripe count is passed into stripe_ctr
the code attempts to divide by zero.

This patch changes DM_TABLE_LOAD to return -EINVAL if the stripe count
is zero.

We now get the following error messages:
  device-mapper: table: 253:0: striped: Invalid stripe count
  device-mapper: ioctl: error adding target to table

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-stripe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -110,7 +110,7 @@ static int stripe_ctr(struct dm_target *
 	}
 
 	stripes = simple_strtoul(argv[0], &end, 10);
-	if (*end) {
+	if (!stripes || *end) {
 		ti->error = "Invalid stripe count";
 		return -EINVAL;
 	}


