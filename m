Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYHBK3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYHBK3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 06:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbYHBK3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 06:29:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:23912 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbYHBK3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 06:29:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dPL9ulvXQZiO3i3bq5cVXEtx4rWBU4iLdI4nX1LxySZA2lqBEj5848JnZlsBX39eQg
         s68LxFXK8trPcPkXgiPYGbxbDWS2UsvQsuC9Lw4MspqRn9u1okDLEIj8+6SSEnRW0al5
         dj5TPEJ9ZfHlLb0wD/umGNaIcz5WF/XaYnK5E=
Date: Sat, 2 Aug 2008 14:29:09 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Infiniband/ipath: fix warnings
Message-ID: <20080802102909.GC4856@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

infiniband/ipath : fix warnings

ipath_driver.c:1260: warning: format '%Lx' expects type 'long long
	unsigned int', but argument 6 has type 'long unsigned int'
ipath_driver.c:1459: warning: format '%Lx' expects type 'long long
	unsigned int', but argument 4 has type 'u64'
ipath_intr.c:358: warning: format '%Lx' expects type 'long long unsigned
	int', but argument 3 has type 'u64'
ipath_intr.c:358: warning: format '%Lu' expects type 'long long unsigned
	int', but argument 6 has type 'u64'
ipath_intr.c:1119: warning: format '%Lx' expects type 'long long
	unsigned int', but argument 5 has type 'u64'
ipath_intr.c:1119: warning: format '%Lx' expects type 'long long
	unsigned int', but argument 3 has type 'u64'
ipath_intr.c:1123: warning: format '%Lx' expects type 'long long
	unsigned int', but argument 3 has type 'u64'
ipath_intr.c:1130: warning: format '%Lx' expects type 'long long
	unsigned int', but argument 4 has type 'u64'
ipath_iba7220.c:1032: warning: format '%llx' expects type 'long long
	unsigned int', but argument 4 has type 'u64'
ipath_iba7220.c:1045: warning: format '%llX' expects type 'long long
	unsigned int', but argument 3 has type 'u64'
ipath_iba7220.c:2506: warning: format '%Lu' expects type 'long long
	unsigned int', but argument 4 has type 'u64'


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>

---

 drivers/infiniband/hw/ipath/ipath_driver.c  |    5 +++--
 drivers/infiniband/hw/ipath/ipath_iba7220.c |    7 ++++---
 drivers/infiniband/hw/ipath/ipath_intr.c    |   12 ++++++++----
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index daad09a..896b6ab 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -1259,7 +1259,7 @@ reloop:
 			 */
 			ipath_cdbg(ERRPKT, "Error Pkt, but no eflags! egrbuf"
 				  " %x, len %x hdrq+%x rhf: %Lx\n",
-				  etail, tlen, l,
+				  etail, tlen, l, (unsigned long long)
 				  le64_to_cpu(*(__le64 *) rhf_addr));
 			if (ipath_debug & __IPATH_ERRPKTDBG) {
 				u32 j, *d, dw = rsize-2;
@@ -1457,7 +1457,8 @@ static void ipath_reset_availshadow(struct ipath_devdata *dd)
 			0xaaaaaaaaaaaaaaaaULL); /* All BUSY bits in qword */
 		if (oldval != dd->ipath_pioavailshadow[i])
 			ipath_dbg("shadow[%d] was %Lx, now %lx\n",
-				i, oldval, dd->ipath_pioavailshadow[i]);
+				i, (unsigned long long)oldval,
+				dd->ipath_pioavailshadow[i]);
 	}
 	spin_unlock_irqrestore(&ipath_pioavail_lock, flags);
 }
diff --git a/drivers/infiniband/hw/ipath/ipath_iba7220.c b/drivers/infiniband/hw/ipath/ipath_iba7220.c
index fadbfbf..124eac1 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba7220.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba7220.c
@@ -1032,7 +1032,7 @@ static int ipath_7220_bringup_serdes(struct ipath_devdata *dd)
 	ipath_cdbg(VERBOSE, "done: xgxs=%llx from %llx\n",
 		   (unsigned long long)
 		   ipath_read_kreg64(dd, dd->ipath_kregs->kr_xgxsconfig),
-		   prev_val);
+		   (unsigned long long)prev_val);
 
 	guid = be64_to_cpu(dd->ipath_guid);
 
@@ -1042,7 +1042,8 @@ static int ipath_7220_bringup_serdes(struct ipath_devdata *dd)
 		ipath_dbg("No GUID for heartbeat, faking %llx\n",
 			(unsigned long long)guid);
 	} else
-		ipath_cdbg(VERBOSE, "Wrote %llX to HRTBT_GUID\n", guid);
+		ipath_cdbg(VERBOSE, "Wrote %llX to HRTBT_GUID\n",
+			(unsigned long long)guid);
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_hrtbt_guid, guid);
 	return ret;
 }
@@ -2505,7 +2506,7 @@ done:
 	if (dd->ipath_flags & IPATH_IB_AUTONEG_INPROG) {
 		ipath_dbg("Did not get to DDR INIT (%x) after %Lu msecs\n",
 			ipath_ib_state(dd, dd->ipath_lastibcstat),
-			jiffies_to_msecs(jiffies)-startms);
+			(unsigned long long)jiffies_to_msecs(jiffies)-startms);
 		dd->ipath_flags &= ~IPATH_IB_AUTONEG_INPROG;
 		if (dd->ipath_autoneg_tries == IPATH_AUTONEG_TRIES) {
 			dd->ipath_flags |= IPATH_IB_AUTONEG_FAILED;
diff --git a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/infiniband/hw/ipath/ipath_intr.c
index 26900b3..94b2711 100644
--- a/drivers/infiniband/hw/ipath/ipath_intr.c
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c
@@ -356,9 +356,10 @@ static void handle_e_ibstatuschanged(struct ipath_devdata *dd,
 			dd->ipath_cregs->cr_iblinkerrrecovcnt);
 		if (linkrecov != dd->ipath_lastlinkrecov) {
 			ipath_dbg("IB linkrecov up %Lx (%s %s) recov %Lu\n",
-				ibcs, ib_linkstate(dd, ibcs),
+				(unsigned long long)ibcs,
+				ib_linkstate(dd, ibcs),
 				ipath_ibcstatus_str[ltstate],
-				linkrecov);
+				(unsigned long long)linkrecov);
 			/* and no more until active again */
 			dd->ipath_lastlinkrecov = 0;
 			ipath_set_linkstate(dd, IPATH_IB_LINKDOWN);
@@ -1118,9 +1119,11 @@ irqreturn_t ipath_intr(int irq, void *data)
 	if (unlikely(istat & ~dd->ipath_i_bitsextant))
 		ipath_dev_err(dd,
 			      "interrupt with unknown interrupts %Lx set\n",
+			      (unsigned long long)
 			      istat & ~dd->ipath_i_bitsextant);
 	else if (istat & ~INFINIPATH_I_ERROR) /* errors do own printing */
-		ipath_cdbg(VERBOSE, "intr stat=0x%Lx\n", istat);
+		ipath_cdbg(VERBOSE, "intr stat=0x%Lx\n",
+			(unsigned long long)istat);
 
 	if (istat & INFINIPATH_I_ERROR) {
 		ipath_stats.sps_errints++;
@@ -1128,7 +1131,8 @@ irqreturn_t ipath_intr(int irq, void *data)
 					  dd->ipath_kregs->kr_errorstatus);
 		if (!estat)
 			dev_info(&dd->pcidev->dev, "error interrupt (%Lx), "
-				 "but no error bits set!\n", istat);
+				 "but no error bits set!\n",
+				 (unsigned long long)istat);
 		else if (estat == -1LL)
 			/*
 			 * should we try clearing all, or hope next read
