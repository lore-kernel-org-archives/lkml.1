Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYJKGiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYJKGiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYJKGgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:36:54 -0400
Received: from vms172069pub.verizon.net ([206.46.172.69]:65502 "EHLO
	vms172069pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYJKGgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:52 -0400
Date: Sat, 11 Oct 2008 02:35:31 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 11/85] ACPICA: Fix wrong resource descriptor length for 64-bit
 build
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Message-id: <51ea4920e5259e9b675c96c55c470124498f1842.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

The "minimal" descriptors such as EndTag are calculated as 12
bytes long, but the actual length in the internal descriptor is
16 because of the round-up to 8 on 64-bit build.

http://www.acpica.org/bugzilla/show_bug.cgi?id=728

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/acpi/actypes.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 4ea4f40..73d6b1c 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -1225,8 +1225,8 @@ struct acpi_resource {
 
 #pragma pack()
 
-#define ACPI_RS_SIZE_MIN                    12
 #define ACPI_RS_SIZE_NO_DATA                8	/* Id + Length fields */
+#define ACPI_RS_SIZE_MIN                    (u32) ACPI_ROUND_UP_TO_NATIVE_WORD (12)
 #define ACPI_RS_SIZE(type)                  (u32) (ACPI_RS_SIZE_NO_DATA + sizeof (type))
 
 #define ACPI_NEXT_RESOURCE(res)             (struct acpi_resource *)((u8 *) res + res->length)
-- 
1.5.5.1

