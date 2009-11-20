Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZKTNql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZKTNql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 08:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbZKTNqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 08:46:40 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:28671 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbZKTNqj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;2:1>);
	Fri, 20 Nov 2009 08:46:39 -0500
Message-Id: <4B06ABD602000078000211D5@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 20 Nov 2009 13:46:46 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <Douglas_Warzecha@Dell.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] use proper address translation functions in Dell RBU
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virt_to_bus() ought to be used (in particular for Xen compatibility).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/firmware/dell_rbu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.32-rc8/drivers/firmware/dell_rbu.c	2009-03-24 00:12:14.000000000 +0100
+++ 2.6.32-rc8-dell-rbu/drivers/firmware/dell_rbu.c	2009-10-26 16:34:16.000000000 +0100
@@ -170,7 +170,7 @@ static int create_packet(void *data, siz
 			goto out_alloc_packet_array;
 		}
 
-		if ((unsigned long)virt_to_phys(packet_data_temp_buf)
+		if ((unsigned long)virt_to_bus(packet_data_temp_buf)
 				< allocation_floor) {
 			pr_debug("packet 0x%lx below floor at 0x%lx.\n",
 					(unsigned long)virt_to_phys(
@@ -185,7 +185,7 @@ static int create_packet(void *data, siz
 	newpacket->data = packet_data_temp_buf;
 
 	pr_debug("create_packet: newpacket at physical addr %lx\n",
-		(unsigned long)virt_to_phys(newpacket->data));
+		(unsigned long)virt_to_bus(newpacket->data));
 
 	/* packets may not have fixed size */
 	newpacket->length = length;
@@ -204,7 +204,7 @@ out_alloc_packet_array:
 	/* always free packet array */
 	for (;idx>0;idx--) {
 		pr_debug("freeing unused packet below floor 0x%lx.\n",
-			(unsigned long)virt_to_phys(
+			(unsigned long)virt_to_bus(
 				invalid_addr_packet_array[idx-1]));
 		free_pages((unsigned long)invalid_addr_packet_array[idx-1],
 			ordernum);
@@ -438,7 +438,7 @@ static int img_update_realloc(unsigned l
 		(unsigned char *) __get_free_pages(GFP_KERNEL, ordernum);
 
 	img_buf_phys_addr =
-		(unsigned long) virt_to_phys(image_update_buffer);
+		(unsigned long) virt_to_bus(image_update_buffer);
 
 	if (img_buf_phys_addr > BIOS_SCAN_LIMIT) {
 		free_pages((unsigned long) image_update_buffer, ordernum);



