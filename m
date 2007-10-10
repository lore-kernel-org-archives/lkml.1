Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbXJJMPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbXJJMPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 08:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbXJJMPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 08:15:44 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:15383 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbXJJMPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 08:15:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type;
        b=SRNOOpiqfQ27tzqFYyqU6/7cDkzwdVoYVCUknHZcITw/fzK7HKi4Vtrwy0TjAGB5AeOWdaCuZUWAsoFSXsmjEhZxp1iwy0Zqr9BHQemN7tvKkph9Muwa0NBzpTL38Y3TFPXBFQLgTVL3X5R3fMZ2dR5n3reQf1o0K4qczMPzNA0=
Message-ID: <470CC26F.6070301@gmail.com>
Date: Wed, 10 Oct 2007 08:15:43 -0400
From: George Beshers <gbeshers@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070924)
MIME-Version: 1.0
To: torvalds@osdl.org, tony.luck@intel.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Cleanup misleading IA64 ACPI error message
Content-Type: multipart/mixed;
 boundary="------------090400030805040207040103"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090400030805040207040103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------090400030805040207040103
Content-Type: text/x-patch;
 name="MADT.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="MADT.patch"


On Altix (sn2) machines the "Error parsing MADT" message is
misleading because the lack of IOSAPIC entries is expected.

Since I am sure someone will ask, I have been told that
the chance of this changing anytime soon is close to nil.

Signed-off-by: George Beshers <gbeshers@sgi.com>

---
 acpi.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -purN linux-2.6.23/arch/ia64/kernel/acpi.c linux-2.6.23.b/arch/ia64/kernel/acpi.c
--- linux-2.6.23/arch/ia64/kernel/acpi.c	2007-10-09 16:31:38.000000000 -0400
+++ linux-2.6.23.b/arch/ia64/kernel/acpi.c	2007-10-09 21:43:29.283569798 -0400
@@ -678,9 +678,14 @@ int __init acpi_boot_init(void)
 	/* I/O APIC */
 
 	if (acpi_table_parse_madt
-	    (ACPI_MADT_TYPE_IO_SAPIC, acpi_parse_iosapic, NR_IOSAPICS) < 1)
-		printk(KERN_ERR PREFIX
-		       "Error parsing MADT - no IOSAPIC entries\n");
+	    (ACPI_MADT_TYPE_IO_SAPIC, acpi_parse_iosapic, NR_IOSAPICS) < 1) {
+		if (ia64_platform_is("sn2"))
+			printk(KERN_NOTICE
+			       "SGI/SN machines do not have IOSAPIC entries\n");
+		else
+			printk(KERN_ERR PREFIX
+			       "Error parsing MADT - no IOSAPIC entries\n");
+	}
 
 	/* System-Level Interrupt Routing */
 

--------------090400030805040207040103--
