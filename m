Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbZJTS6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbZJTS6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 14:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZJTS6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 14:58:38 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:60835 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZJTS6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 14:58:38 -0400
Date: Tue, 20 Oct 2009 13:58:41 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Debora Velarde <debora@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>,
       tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-bugs@dell.com
Subject: [PATCH] tpm: autoload tpm_tis based on system PnP IDs
Message-ID: <20091020185840.GA19773@mock.linuxdev.us.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tpm_tis driver already has a list of supported pnp_device_ids.
This patch simply exports that list as a MODULE_DEVICE_TABLE() so that
the module autoloader will discover and load the module at boottime.

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
---
 drivers/char/tpm/tpm_tis.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 0b73e4e..c10ab48 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -629,6 +629,7 @@ static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
 	{"", 0},		/* User Specified */
 	{"", 0}			/* Terminator */
 };
+MODULE_DEVICE_TABLE(pnp, tpm_pnp_tbl);
 
 static __devexit void tpm_tis_pnp_remove(struct pnp_dev *dev)
 {
-- 
1.6.0.6


-- 
Matt Domsch
Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
