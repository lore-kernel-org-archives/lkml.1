Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbXJVCsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbXJVCsZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 22:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbXJVCrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 22:47:45 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47845 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753404AbXJVCro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 22:47:44 -0400
Date: Mon, 22 Oct 2007 04:48:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Corey Minyard <cminyard@mvista.com>
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] ipmi_demangle_device_id(): remove dead code
Message-ID: <20071022024814.GL30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes obviously dead code spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/ipmi_smi.h |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- linux-2.6/include/linux/ipmi_smi.h.old	2007-10-21 23:03:03.000000000 +0200
+++ linux-2.6/include/linux/ipmi_smi.h	2007-10-21 23:05:59.000000000 +0200
@@ -158,44 +158,38 @@ static inline int ipmi_demangle_device_i
 	if (data_len < 9)
 		return -EINVAL;
 	if (data[0] != IPMI_NETFN_APP_RESPONSE << 2 ||
 	    data[1] != IPMI_GET_DEVICE_ID_CMD)
 		/* Strange, didn't get the response we expected. */
 		return -EINVAL;
 	if (data[2] != 0)
 		/* That's odd, it shouldn't be able to fail. */
 		return -EINVAL;
 
 	data += 3;
 	data_len -= 3;
 	id->device_id = data[0];
 	id->device_revision = data[1];
 	id->firmware_revision_1 = data[2];
 	id->firmware_revision_2 = data[3];
 	id->ipmi_version = data[4];
 	id->additional_device_support = data[5];
-	if (data_len >= 6) {
-		id->manufacturer_id = (data[6] | (data[7] << 8) |
-				       (data[8] << 16));
-		id->product_id = data[9] | (data[10] << 8);
-	} else {
-		id->manufacturer_id = 0;
-		id->product_id = 0;
-	}
+	id->manufacturer_id = (data[6] | (data[7] << 8) | (data[8] << 16));
+	id->product_id = data[9] | (data[10] << 8);
 	if (data_len >= 15) {
 		memcpy(id->aux_firmware_revision, data+11, 4);
 		id->aux_firmware_revision_set = 1;
 	} else
 		id->aux_firmware_revision_set = 0;
 
 	return 0;
 }
 
 /* Add a low-level interface to the IPMI driver.  Note that if the
    interface doesn't know its slave address, it should pass in zero.
    The low-level interface should not deliver any messages to the
    upper layer until the start_processing() function in the handlers
    is called, and the lower layer must get the interface from that
    call. */
 int ipmi_register_smi(struct ipmi_smi_handlers *handlers,
 		      void                     *send_info,
 		      struct ipmi_device_id    *device_id,
