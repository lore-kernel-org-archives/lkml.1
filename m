Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbYGAVpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbYGAVpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbYGAVpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:45:33 -0400
Received: from mail.suse.de ([195.135.220.2]:45502 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbYGAVpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:45:32 -0400
Date: Tue, 1 Jul 2008 23:45:29 +0200
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Add base_hi BAR for oxsemi_840
Message-ID: <20080701234529.67f59f49@kopernikus.site>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the 2nd BAR for the oxsemi_840 chip as BAR for base_hi.
Tested with:

Parallel controller [0701]: Oxford Semiconductor Ltd VScom 011H-EP1 
        1 port parallel adaptor [1415:8403] (prog-if 03 [IEEE1284])

This patch is needed to make 'TRISTATE' working with that adaptor.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 drivers/parport/parport_pc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2877,7 +2877,7 @@ static struct parport_pc_pci {
 	 * and 840 locks up if you write 1 to bit 2! */
 	/* oxsemi_952 */		{ 1, { { 0, 1 }, } },
 	/* oxsemi_954 */		{ 1, { { 0, -1 }, } },
-	/* oxsemi_840 */		{ 1, { { 0, -1 }, } },
+	/* oxsemi_840 */		{ 1, { { 0, 1 }, } },
 	/* aks_0100 */                  { 1, { { 0, -1 }, } },
 	/* mobility_pp */		{ 1, { { 0, 1 }, } },
 	/* netmos_9705 */               { 1, { { 0, -1 }, } }, /* untested */
