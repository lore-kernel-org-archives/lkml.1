Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbYC1Crr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbYC1Crr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbYC1CrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:47:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:7191 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056AbYC1CrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:47:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,567,1199692800"; 
   d="scan'208";a="265462622"
Subject: [PATCH 4/4] x86_64 boot -v2: Document for linked list of struct
	setup_data
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Mar 2008 10:49:50 +0800
Message-Id: <1206672590.13404.29.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 28 Mar 2008 02:46:47.0473 (UTC) FILETIME=[F7523210:01C8907D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation for linked list of struct setup_data.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 Documentation/i386/boot.txt |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -42,6 +42,8 @@ Protocol 2.05:	(Kernel 2.6.20) Make prot
 Protocol 2.06:	(Kernel 2.6.22) Added a field that contains the size of
 		the boot command line
 
+Protocol 2.09:	(kernel 2.6.26) Added a field of 64-bit physical
+		pointer to single linked list of struct	setup_data.
 
 **** MEMORY LAYOUT
 
@@ -172,6 +174,8 @@ Offset	Proto	Name		Meaning
 0240/8	2.07+	hardware_subarch_data Subarchitecture-specific data
 0248/4	2.08+	payload_offset	Offset of kernel payload
 024C/4	2.08+	payload_length	Length of kernel payload
+0250/8	2.09+	setup_data	64-bit physical pointer to linked list
+				of struct setup_data
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
@@ -572,6 +576,28 @@ command line is entered using the follow
 	covered by setup_move_size, so you may need to adjust this
 	field.
 
+Field name:	setup_data
+Type:		write (obligatory)
+Offset/size:	0x250/8
+Protocol:	2.09+
+
+  The 64-bit physical pointer to NULL terminated single linked list of
+  struct setup_data. This is used to define a more extensible boot
+  parameters passing mechanism. The definition of struct setup_data is
+  as follow:
+
+  struct setup_data {
+	  u64 next;
+	  u32 type;
+	  u32 len;
+	  u8  data[0];
+  };
+
+  Where, the next is a 64-bit physical pointer to the next node of
+  linked list, the next field of the last node is 0; the type is used
+  to identify the contents of data; the len is the length of data
+  field; the data holds the real payload.
+
 
 **** MEMORY LAYOUT OF THE REAL-MODE CODE
 

