Return-Path: <linux-kernel-owner+w=401wt.eu-S1762023AbZGAAh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762023AbZGAAh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759904AbZGAAaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:30:30 -0400
Received: from kroah.org ([198.145.64.141]:34400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759915AbZGAAaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:30:20 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:04:00 2009
Message-Id: <20090701000400.797655009@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:00:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 28/30] dm mpath: validate hw_handler argument count
References: <20090630235944.868879272@mini.kroah.org>
Content-Disposition: inline; filename=dm-mpath-validate-hw_handler-argument-count.patch
In-Reply-To: <20090701002817.GA6156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit e094f4f15f5169526c7200b9bde44b900548a81e upstream.

Fix arg count parsing error in hw handlers.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-mpath.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -684,6 +684,11 @@ static int parse_hw_handler(struct arg_s
 	if (!hw_argc)
 		return 0;
 
+	if (hw_argc > as->argc) {
+		ti->error = "not enough arguments for hardware handler";
+		return -EINVAL;
+	}
+
 	m->hw_handler_name = kstrdup(shift(as), GFP_KERNEL);
 	request_module("scsi_dh_%s", m->hw_handler_name);
 	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {


