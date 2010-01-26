Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434Ab0AZX5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0AZX5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030Ab0AZX5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:57:04 -0500
Received: from kroah.org ([198.145.64.141]:35322 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab0AZXnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:40 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:27 2010
Message-Id: <20100126233927.064971013@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Christie <michaelc@cs.wisc.edu>,
       Robert Love <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [47/98] [SCSI] fcoe: initialize return value in fcoe_destroy
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Christie <michaelc@cs.wisc.edu>

commit 8eca355fa8af660557fbdd5506bde1392eee9bfe upstream.

When doing echo ethX > /sys..../destroy I am getting
errors when the tear down succeeds. It looks like the
reason for this is because the rc var is not getting set
when the destruction works. This just sets it to zero.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1631,7 +1631,7 @@ static int fcoe_destroy(const char *buff
 {
 	struct fcoe_interface *fcoe;
 	struct net_device *netdev;
-	int rc;
+	int rc = 0;
 
 	mutex_lock(&fcoe_config_mutex);
 #ifdef CONFIG_FCOE_MODULE


