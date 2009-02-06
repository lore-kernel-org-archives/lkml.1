Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbZBFTmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbZBFTmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZBFTmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:42:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:54950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbZBFTmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:42:45 -0500
Message-ID: <498C928A.60407@kernel.org>
Date: Fri, 06 Feb 2009 11:42:02 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Kashyap Desai <kadesai@lsi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
CC: "Linux-Scsi" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mpt: fix enable lsi sas to use msi as default
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix bug

the third arg in module_param(,,) is perm instead of default value.
we still need to assign default at first.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/message/fusion/mptbase.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/message/fusion/mptbase.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptbase.c
+++ linux-2.6/drivers/message/fusion/mptbase.c
@@ -90,8 +90,8 @@ module_param(mpt_msi_enable_fc, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
 		controllers (default=0)");
 
-static int mpt_msi_enable_sas;
-module_param(mpt_msi_enable_sas, int, 1);
+static int mpt_msi_enable_sas = 1;
+module_param(mpt_msi_enable_sas, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
 		controllers (default=1)");
 
