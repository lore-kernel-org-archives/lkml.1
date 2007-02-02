Return-Path: <linux-kernel-owner+w=401wt.eu-S1423170AbXBBOWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423170AbXBBOWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 09:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423183AbXBBOWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 09:22:46 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:35308 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423157AbXBBOWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 09:22:40 -0500
Date: Fri, 2 Feb 2007 15:22:39 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: peter.oberparleiter@de.ibm.com
Subject: [S390] cio: declare hardware structures packed.
Message-ID: <20070202142239.GD30839@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

[S390] cio: declare hardware structures packed.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/chsc.c |   16 ++++++++--------
 drivers/s390/cio/chsc.h |    8 ++++----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -urpN linux-2.6/drivers/s390/cio/chsc.c linux-2.6-patched/drivers/s390/cio/chsc.c
--- linux-2.6/drivers/s390/cio/chsc.c	2007-02-02 14:04:42.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/chsc.c	2007-02-02 14:04:43.000000000 +0100
@@ -93,7 +93,7 @@ chsc_get_sch_desc_irq(struct subchannel 
 		u16 sch;	  /* subchannel */
 		u8 chpid[8];	  /* chpids 0-7 */
 		u16 fla[8];	  /* full link addresses 0-7 */
-	} *ssd_area;
+	} __attribute__ ((packed)) *ssd_area;
 
 	ssd_area = page;
 
@@ -444,7 +444,7 @@ __get_chpid_from_lir(void *data)
 		u32 andesc[28];
 		/* incident-specific information */
 		u32 isinfo[28];
-	} *lir;
+	} __attribute__ ((packed)) *lir;
 
 	lir = data;
 	if (!(lir->iq&0x80))
@@ -483,7 +483,7 @@ chsc_process_crw(void)
 		u32 reserved6;
 		u32 ccdf[96];	/* content-code dependent field */
 		/* ccdf has to be big enough for a link-incident record */
-	} *sei_area;
+	} __attribute__ ((packed)) *sei_area;
 
 	if (!sei_page)
 		return 0;
@@ -1040,7 +1040,7 @@ __chsc_do_secm(struct channel_subsystem 
 		u32 : 4;
 		u32 fmt : 4;
 		u32 : 16;
-	} *secm_area;
+	} __attribute__ ((packed)) *secm_area;
 	int ret, ccode;
 
 	secm_area = page;
@@ -1251,7 +1251,7 @@ chsc_determine_channel_path_description(
 		struct chsc_header response;
 		u32 zeroes2;
 		struct channel_path_desc desc;
-	} *scpd_area;
+	} __attribute__ ((packed)) *scpd_area;
 
 	scpd_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!scpd_area)
@@ -1348,7 +1348,7 @@ chsc_get_channel_measurement_chars(struc
 		u32 cmg : 8;
 		u32 zeroes3;
 		u32 data[NR_MEASUREMENT_CHARS];
-	} *scmc_area;
+	} __attribute__ ((packed)) *scmc_area;
 
 	scmc_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!scmc_area)
@@ -1515,7 +1515,7 @@ chsc_enable_facility(int operation_code)
 		u32 reserved5:4;
 		u32 format2:4;
 		u32 reserved6:24;
-	} *sda_area;
+	} __attribute__ ((packed)) *sda_area;
 
 	sda_area = (void *)get_zeroed_page(GFP_KERNEL|GFP_DMA);
 	if (!sda_area)
@@ -1567,7 +1567,7 @@ chsc_determine_css_characteristics(void)
 		u32 reserved4;
 		u32 general_char[510];
 		u32 chsc_char[518];
-	} *scsc_area;
+	} __attribute__ ((packed)) *scsc_area;
 
 	scsc_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!scsc_area) {
diff -urpN linux-2.6/drivers/s390/cio/chsc.h linux-2.6-patched/drivers/s390/cio/chsc.h
--- linux-2.6/drivers/s390/cio/chsc.h	2007-02-02 14:04:19.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/chsc.h	2007-02-02 14:04:43.000000000 +0100
@@ -10,17 +10,17 @@
 struct chsc_header {
 	u16 length;
 	u16 code;
-};
+} __attribute__ ((packed));
 
 #define NR_MEASUREMENT_CHARS 5
 struct cmg_chars {
 	u32 values[NR_MEASUREMENT_CHARS];
-};
+} __attribute__ ((packed));
 
 #define NR_MEASUREMENT_ENTRIES 8
 struct cmg_entry {
 	u32 values[NR_MEASUREMENT_ENTRIES];
-};
+} __attribute__ ((packed));
 
 struct channel_path_desc {
 	u8 flags;
@@ -31,7 +31,7 @@ struct channel_path_desc {
 	u8 zeroes;
 	u8 chla;
 	u8 chpp;
-};
+} __attribute__ ((packed));
 
 struct channel_path {
 	int id;
