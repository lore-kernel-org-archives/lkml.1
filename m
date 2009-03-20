Return-Path: <linux-kernel-owner+w=401wt.eu-S1763236AbZCTXbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763236AbZCTXbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762926AbZCTXYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:31 -0400
Received: from kroah.org ([198.145.64.141]:48583 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762929AbZCTXYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:25 2009
Message-Id: <20090320222924.954615735@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Milan Broz <mbroz@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 13/43] dm ioctl: validate name length when renaming
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=dm-ioctl-validate-name-length-when-renaming.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Milan Broz <mbroz@redhat.com>

commit bc0fd67feba2e0770aad85393500ba77c6489f1c upstream.

When renaming a mapped device validate the length of the new name.

The rename ioctl accepted any correctly-terminated string enclosed
within the data passed from userspace.  The other ioctls enforce a
size limit of DM_NAME_LEN.  If the name is changed and becomes longer
than that, the device can no longer be addressed by name.

Fix it by properly checking for device name length (including
terminating zero).

Signed-off-by: Milan Broz <mbroz@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -704,7 +704,8 @@ static int dev_rename(struct dm_ioctl *p
 	char *new_name = (char *) param + param->data_start;
 
 	if (new_name < param->data ||
-	    invalid_str(new_name, (void *) param + param_size)) {
+	    invalid_str(new_name, (void *) param + param_size) ||
+	    strlen(new_name) > DM_NAME_LEN - 1) {
 		DMWARN("Invalid new logical volume name supplied.");
 		return -EINVAL;
 	}


