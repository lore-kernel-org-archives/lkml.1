Return-Path: <linux-kernel-owner+w=401wt.eu-S934165AbYBVWKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165AbYBVWKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934773AbYBVWJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:09:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934723AbYBVWJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:09:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=FuwTIBwCyPEeQgvNrmuqdHxCr6a3wpdPGCodJWJCcdtny1N3TEXLDCXw6WLns4+svglkkVSaQafV3wlv+0F91L/RJ3T4gddGKW4Llejt9iJsibhfedZAiJx3B0pTVMFU6TMmvPvsdi+y593UuFkca9SKEb3OCMbljUVwY7UUI2s=
Date: Fri, 22 Feb 2008 23:09:34 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/20] x86: Coding Style fixes to
 arch/x86/kernel/summit_32.c
Message-ID: <20080222230934.406120e9@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/summit_32.c |   43 +++++++++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index 72f4634..c7b579d 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -40,38 +40,40 @@ static int __init setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
 	int twister = 0, node = 0;
 	int i, bus, num_buses;
 
-	for(i = 0; i < rio_table_hdr->num_rio_dev; i++){
-		if (rio_devs[i]->node_id == rio_devs[wpeg_num]->owner_id){
+	for (i = 0; i < rio_table_hdr->num_rio_dev; i++) {
+		if (rio_devs[i]->node_id == rio_devs[wpeg_num]->owner_id) {
 			twister = rio_devs[i]->owner_id;
 			break;
 		}
 	}
-	if (i == rio_table_hdr->num_rio_dev){
+	if (i == rio_table_hdr->num_rio_dev) {
 		printk(KERN_ERR "%s: Couldn't find owner Cyclone for Winnipeg!\n", __FUNCTION__);
 		return last_bus;
 	}
 
-	for(i = 0; i < rio_table_hdr->num_scal_dev; i++){
-		if (scal_devs[i]->node_id == twister){
+	for (i = 0; i < rio_table_hdr->num_scal_dev; i++) {
+		if (scal_devs[i]->node_id == twister) {
 			node = scal_devs[i]->node_id;
 			break;
 		}
 	}
-	if (i == rio_table_hdr->num_scal_dev){
+	if (i == rio_table_hdr->num_scal_dev) {
 		printk(KERN_ERR "%s: Couldn't find owner Twister for Cyclone!\n", __FUNCTION__);
 		return last_bus;
 	}
 
-	switch (rio_devs[wpeg_num]->type){
+	switch (rio_devs[wpeg_num]->type) {
 	case CompatWPEG:
-		/* The Compatibility Winnipeg controls the 2 legacy buses,
+		/*
+		 * The Compatibility Winnipeg controls the 2 legacy buses,
 		 * the 66MHz PCI bus [2 slots] and the 2 "extra" buses in case
 		 * a PCI-PCI bridge card is used in either slot: total 5 buses.
 		 */
 		num_buses = 5;
 		break;
 	case AltWPEG:
-		/* The Alternate Winnipeg controls the 2 133MHz buses [1 slot
+		/*
+		 * The Alternate Winnipeg controls the 2 133MHz buses [1 slot
 		 * each], their 2 "extra" buses, the 100MHz bus [2 slots] and
 		 * the "extra" buses for each of those slots: total 7 buses.
 		 */
@@ -79,7 +81,8 @@ static int __init setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
 		break;
 	case LookOutAWPEG:
 	case LookOutBWPEG:
-		/* A Lookout Winnipeg controls 3 100MHz buses [2 slots each]
+		/*
+		 * A Lookout Winnipeg controls 3 100MHz buses [2 slots each]
 		 * & the "extra" buses for each of those slots: total 9 buses.
 		 */
 		num_buses = 9;
@@ -89,7 +92,7 @@ static int __init setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
 		return last_bus;
 	}
 
-	for(bus = last_bus; bus < last_bus + num_buses; bus++)
+	for (bus = last_bus; bus < last_bus + num_buses; bus++)
 		mp_bus_id_to_node[bus] = node;
 	return bus;
 }
@@ -99,12 +102,12 @@ static int __init build_detail_arrays(void)
 	unsigned long ptr;
 	int i, scal_detail_size, rio_detail_size;
 
-	if (rio_table_hdr->num_scal_dev > MAX_NUMNODES){
+	if (rio_table_hdr->num_scal_dev > MAX_NUMNODES) {
 		printk(KERN_WARNING "%s: MAX_NUMNODES too low!  Defined as %d, but system has %d nodes.\n", __FUNCTION__, MAX_NUMNODES, rio_table_hdr->num_scal_dev);
 		return 0;
 	}
 
-	switch (rio_table_hdr->version){
+	switch (rio_table_hdr->version) {
 	default:
 		printk(KERN_WARNING "%s: Invalid Rio Grande Table Version: %d\n", __FUNCTION__, rio_table_hdr->version);
 		return 0;
@@ -119,10 +122,10 @@ static int __init build_detail_arrays(void)
 	}
 
 	ptr = (unsigned long)rio_table_hdr + 3;
-	for(i = 0; i < rio_table_hdr->num_scal_dev; i++, ptr += scal_detail_size)
+	for (i = 0; i < rio_table_hdr->num_scal_dev; i++, ptr += scal_detail_size)
 		scal_devs[i] = (struct scal_detail *)ptr;
 
-	for(i = 0; i < rio_table_hdr->num_rio_dev; i++, ptr += rio_detail_size)
+	for (i = 0; i < rio_table_hdr->num_rio_dev; i++, ptr += rio_detail_size)
 		rio_devs[i] = (struct rio_detail *)ptr;
 
 	return 1;
@@ -140,9 +143,9 @@ void __init setup_summit(void)
 
 	rio_table_hdr = NULL;
 	offset = 0x180;
-	while (offset){
+	while (offset) {
 		/* The block id is stored in the 2nd word */
-		if (*((unsigned short *)(ptr + offset + 2)) == 0x4752){
+		if (*((unsigned short *)(ptr + offset + 2)) == 0x4752) {
 			/* set the pointer past the offset & block id */
 			rio_table_hdr = (struct rio_table_hdr *)(ptr + offset + 4);
 			break;
@@ -150,7 +153,7 @@ void __init setup_summit(void)
 		/* The next offset is stored in the 1st word.  0 means no more */
 		offset = *((unsigned short *)(ptr + offset));
 	}
-	if (!rio_table_hdr){
+	if (!rio_table_hdr) {
 		printk(KERN_ERR "%s: Unable to locate Rio Grande Table in EBDA - bailing!\n", __FUNCTION__);
 		return;
 	}
@@ -161,8 +164,8 @@ void __init setup_summit(void)
 	/* The first Winnipeg we're looking for has an index of 0 */
 	next_wpeg = 0;
 	do {
-		for(i = 0; i < rio_table_hdr->num_rio_dev; i++){
-			if (is_WPEG(rio_devs[i]) && rio_devs[i]->WP_index == next_wpeg){
+		for (i = 0; i < rio_table_hdr->num_rio_dev; i++) {
+			if (is_WPEG(rio_devs[i]) && rio_devs[i]->WP_index == next_wpeg) {
 				/* It's the Winnipeg we're looking for! */
 				next_bus = setup_pci_node_map_for_wpeg(i, next_bus);
 				next_wpeg++;
-- 
1.5.4.GIT

