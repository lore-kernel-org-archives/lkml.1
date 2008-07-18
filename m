Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbYGRMf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbYGRMf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbYGRMfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:35:15 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:30425 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbYGRMfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:35:14 -0400
Message-Id: <4880AA39.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 13:35:37 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: check function status in EDD boot code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without checking the return value of get_edd_info() and adding the
entry only in the success case, 6 devices show up under
/sys/firmware/edd/, no matter how many devices are actually present.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/boot/edd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.26/arch/x86/boot/edd.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-x86-edd/arch/x86/boot/edd.c	2008-07-15 19:20:52.000000000 +0200
@@ -167,9 +167,8 @@ void query_edd(void)
 		 * Scan the BIOS-supported hard disks and query EDD
 		 * information...
 		 */
-		get_edd_info(devno, &ei);
-
-		if (boot_params.eddbuf_entries < EDDMAXNR) {
+		if (!get_edd_info(devno, &ei)
+		    && boot_params.eddbuf_entries < EDDMAXNR) {
 			memcpy(edp, &ei, sizeof ei);
 			edp++;
 			boot_params.eddbuf_entries++;



