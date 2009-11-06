Return-Path: <linux-kernel-owner+w=401wt.eu-S932239AbZKFWLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbZKFWLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759904AbZKFWFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:05:43 -0500
Received: from kroah.org ([198.145.64.141]:39711 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758835AbZKFWFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:41 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:50 2009
Message-Id: <20091106215950.444170520@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>
Subject: [03/30] dpt_i2o: Fix up copy*user
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=dpt_i2o-fix-up-copy-user.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@linux.intel.com>

commit ef7562b7f28319e6dd1f85dc1af87df2a7a84832 upstream.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/dpt_i2o.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1918,6 +1918,10 @@ static int adpt_i2o_passthru(adpt_hba* p
 		}
 		size = size>>16;
 		size *= 4;
+		if (size > MAX_MESSAGE_SIZE) {
+			rcode = EINVAL;
+			goto cleanup;
+		}
 		/* Copy in the user's I2O command */
 		if (copy_from_user (msg, user_msg, size)) {
 			rcode = -EFAULT;


