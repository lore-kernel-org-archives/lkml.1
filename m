Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab0CIRUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:20:45 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:41779 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0CIRUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:20:41 -0500
Date: Tue, 9 Mar 2010 18:20:52 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 2/2] memory hotplug/s390: set phys_device
Message-ID: <20100309172052.GC2360@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Implement arch specific arch_get_memory_phys_device function and initialize
phys_device for each memory section. That way we finally can tell which
piece of memory belongs to which physical device.

Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by:  Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/s390/char/sclp_cmd.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -704,6 +704,13 @@ int sclp_chp_deconfigure(struct chp_id c
 	return do_chp_configure(SCLP_CMDW_DECONFIGURE_CHPATH | chpid.id << 8);
 }
 
+int arch_get_memory_phys_device(unsigned long start_pfn)
+{
+	if (!rzm)
+		return 0;
+	return PFN_PHYS(start_pfn) / rzm;
+}
+
 struct chp_info_sccb {
 	struct sccb_header header;
 	u8 recognized[SCLP_CHP_INFO_MASK_SIZE];
