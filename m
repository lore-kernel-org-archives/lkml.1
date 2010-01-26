Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173Ab0AZX4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab0AZX4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528Ab0AZXnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:40 -0500
Received: from kroah.org ([198.145.64.141]:35293 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab0AZXnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:39 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:27 2010
Message-Id: <20100126233926.932307847@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [46/98] [SCSI] libfc: dont WARN_ON in lport_timeout for RESET state
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joe Eykholt <jeykholt@cisco.com>

commit 22655ac22289d7b7def8ef2d72eafe5024bd57fe upstream.

It's possible and harmless to get FLOGI timeouts
while in RESET state.  Don't do a WARN_ON in that case.

Also, split out the other WARN_ONs in fc_lport_timeout, so
we can tell which one is hit by its line number.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libfc/fc_lport.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1237,10 +1237,13 @@ static void fc_lport_timeout(struct work
 
 	switch (lport->state) {
 	case LPORT_ST_DISABLED:
+		WARN_ON(1);
+		break;
 	case LPORT_ST_READY:
-	case LPORT_ST_RESET:
 		WARN_ON(1);
 		break;
+	case LPORT_ST_RESET:
+		break;
 	case LPORT_ST_FLOGI:
 		fc_lport_enter_flogi(lport);
 		break;


