Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbYFTL5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbYFTL5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYFTL5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:57:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:46353 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbYFTL5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:57:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=ZXQCA4ZdexR6mI0R8GdDVbncen/H7n8ie0d0nEPNzzUPEzxCcFgXoeW2fGbGCelFaK
         hgN1lJdMdyAgRogTu1HkS2kB4QcCfpMiLn8vV0ZDyMRY0Z3ylHQmCziTEFTACHbr2Gh5
         Y07YFxhbZ0onNhaSfW8nAmg4U3bNxPS/hywZI=
Date: Fri, 20 Jun 2008 13:56:56 +0200
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: fix mutex names
Message-ID: <20080620115656.GA17426@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I came across this as I was looking at Ingo's report. This looks correct,
yeah? (The alternative is to switch the #defines around, but that has
more serious implications than changing just what is displayed on the
screen!)


Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 20 Jun 2008 13:49:22 +0200
Subject: [PATCH] ACPI: fix mutex names

This patch reorders the mutex names to match the preceding #defines
and comment:

    /*
     * NOTE: any changes here must be reflected in the acpi_gbl_mutex_names
     * table below also!
     */
    #define ACPI_MTX_INTERPRETER            0       /* AML Interpreter, main lock */
    #define ACPI_MTX_NAMESPACE              1       /* ACPI Namespace */
    #define ACPI_MTX_TABLES                 2       /* Data for ACPI tables */

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/acpi/aclocal.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/acpi/aclocal.h b/include/acpi/aclocal.h
index c5cdc32..62d7468 100644
--- a/include/acpi/aclocal.h
+++ b/include/acpi/aclocal.h
@@ -98,8 +98,8 @@ union acpi_parse_object;
 
 static char *acpi_gbl_mutex_names[ACPI_NUM_MUTEX] = {
 	"ACPI_MTX_Interpreter",
-	"ACPI_MTX_Tables",
 	"ACPI_MTX_Namespace",
+	"ACPI_MTX_Tables",
 	"ACPI_MTX_Events",
 	"ACPI_MTX_Caches",
 	"ACPI_MTX_Memory",
-- 
1.5.4.1

