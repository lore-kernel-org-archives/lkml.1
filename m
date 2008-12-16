Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbYLPMV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbYLPMV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 07:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbYLPMVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 07:21:19 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57130 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbYLPMVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 07:21:19 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 16 Dec 2008 13:20:52 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] ieee1394 update
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.2fbfe9e690745496@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following update.

Stefan Richter (1):
      ieee1394: add quirk fix for Freecom HDD

 drivers/ieee1394/nodemgr.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)


commit 25a41b280083259d05d68f61633194344a1f8a9f
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Dec 13 01:43:59 2008 +0100

    ieee1394: add quirk fix for Freecom HDD
    
    According to http://bugzilla.kernel.org/show_bug.cgi?id=12206, Freecom
    FireWire Hard Drive 1TB reports max_rom=2 but returns garbage if block
    read requests are used to read the config ROM.  Force max_rom=0 to limit
    them to quadlet read requests.
    
    Reported-by: Christian Mueller <cm1@mumac.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index d333ae2..79ef5fd 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -115,8 +115,14 @@ static int nodemgr_bus_read(struct csr1212_csr *csr, u64 addr, u16 length,
 	return error;
 }
 
+#define OUI_FREECOM_TECHNOLOGIES_GMBH 0x0001db
+
 static int nodemgr_get_max_rom(quadlet_t *bus_info_data, void *__ci)
 {
+	/* Freecom FireWire Hard Drive firmware bug */
+	if (be32_to_cpu(bus_info_data[3]) >> 8 == OUI_FREECOM_TECHNOLOGIES_GMBH)
+		return 0;
+
 	return (be32_to_cpu(bus_info_data[2]) >> 8) & 0x3;
 }
 

Thanks,
-- 
Stefan Richter
-=====-==--- ==-- =----
http://arcgraph.de/sr/

