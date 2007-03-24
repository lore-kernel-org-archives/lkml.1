Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbXCXE6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbXCXE6I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 00:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbXCXE6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 00:58:08 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:13411 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbXCXE6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 00:58:07 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=Eet0WErT20ZjXl0M5/SeTSP1jdTJ2+M7qPy3Iyq1LX/M4LbnAJEE9y2vfFUsfNuuL7z9Q83ctclStxyCD793Y7PSF6fA6J8PgzRf0Jio6+qTdfru4baWSBlTNpu2I1cX;
X-IronPort-AV: i="4.14,322,1170655200"; 
   d="scan'208"; a="237951151:sNHT15794856"
Date: Fri, 23 Mar 2007 23:58:07 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: akpm@linux-foundation.org, gregkh@suse.de
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       charles_rose@dell.com
Subject: [PATCH 2.6.21-rc3] pci: set pci=bfsort for PowerEdge R900
Message-ID: <20070324045807.GA11480@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch automatically enables pci=bfsort for the Dell PowerEdge
R900.  This is necessary to ensure the onboard NICs enumerate in the
proper order, similar to the other systems already on the list.

I'd appreciate this being applied before 2.6.21-final if possible.

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>

Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

diff --git a/arch/i386/pci/common.c b/arch/i386/pci/common.c
index 1bb0693..9484366 100644
--- a/arch/i386/pci/common.c
+++ b/arch/i386/pci/common.c
@@ -193,6 +193,14 @@ static struct dmi_system_id __devinitdat
 	},
 	{
 		.callback = set_bf_sort,
+		.ident = "Dell PowerEdge R900",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R900"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
 		.ident = "HP ProLiant BL20p G3",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
