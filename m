Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYIYSuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYIYSuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbYIYSt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:49:57 -0400
Received: from dcs-mx1.cs.uiuc.edu ([128.174.252.81]:45661 "EHLO
	dcs-mx1.cs.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbYIYSt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:49:56 -0400
X-Greylist: delayed 3607 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2008 14:49:56 EDT
Date: Thu, 25 Sep 2008 12:49:48 -0500
From: Lin Tan <tammy000@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH git latest] drivers/scsi: fixing wrong comment before new_buffer_tape()
Message-ID: <20080925174948.GA14180@carmen.cs.uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I would wish to be personally CC'ed the answers/comments posted to the list in response to my posting.)

---

Removing the wrong comment.
The lock is needed before calling new_tape_buffer(), at least in some cases.
So the comment above new_tape_buffer() is inconsistent with the code and
may mislead developers.

I simply removed the wrong comment, as I am not sure if the lock is required
in all situations. If so, we should add "Caller must hold os_scsi_tapes_lock".

Signed-off-by: Lin Tan <tammy000@gmail.com>

---

--- a/drivers/scsi/osst.c	2008-09-25 11:53:09.000000000 -0500
+++ b/drivers/scsi/osst.c	2008-09-25 11:59:46.000000000 -0500
@@ -5209,7 +5209,7 @@
 
 /* Memory handling routines */
 
-/* Try to allocate a new tape buffer skeleton. Caller must not hold os_scsi_tapes_lock */
+/* Try to allocate a new tape buffer skeleton. */
 static struct osst_buffer * new_tape_buffer( int from_initialization, int need_dma, int max_sg )
 {
 	int i;
