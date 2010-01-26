Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092Ab0AZX5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab0AZX5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388Ab0AZX5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:57:05 -0500
Received: from kroah.org ([198.145.64.141]:35306 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab0AZXni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:38 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:26 2010
Message-Id: <20100126233926.804124374@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [45/98] [SCSI] libfc: lport: fix minor documentation errors
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joe Eykholt <jeykholt@cisco.com>

commit 1b69bc062c2a4c8f3e15ac69f487afec3aa8d774 upstream.

Fix minor errors.
A debug message said an RLIR was received instead of ECHO.
"Expected" was misspelled in several places.
Fix a type cast from u32 to __be32.

Rob, Some of these may have been also taken care of in your
other doc cleanup patch.  Feel free to fold them in.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libfc/fc_lport.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -329,7 +329,7 @@ static void fc_lport_add_fc4_type(struct
  * @sp: current sequence in the RLIR exchange
  * @fp: RLIR request frame
  *
- * Locking Note: The lport lock is exected to be held before calling
+ * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
 static void fc_lport_recv_rlir_req(struct fc_seq *sp, struct fc_frame *fp,
@@ -348,7 +348,7 @@ static void fc_lport_recv_rlir_req(struc
  * @sp: current sequence in the ECHO exchange
  * @fp: ECHO request frame
  *
- * Locking Note: The lport lock is exected to be held before calling
+ * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
 static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
@@ -361,7 +361,7 @@ static void fc_lport_recv_echo_req(struc
 	void *dp;
 	u32 f_ctl;
 
-	FC_LPORT_DBG(lport, "Received RLIR request while in state %s\n",
+	FC_LPORT_DBG(lport, "Received ECHO request while in state %s\n",
 		     fc_lport_state(lport));
 
 	len = fr_len(in_fp) - sizeof(struct fc_frame_header);
@@ -374,7 +374,7 @@ static void fc_lport_recv_echo_req(struc
 	if (fp) {
 		dp = fc_frame_payload_get(fp, len);
 		memcpy(dp, pp, len);
-		*((u32 *)dp) = htonl(ELS_LS_ACC << 24);
+		*((__be32 *)dp) = htonl(ELS_LS_ACC << 24);
 		sp = lport->tt.seq_start_next(sp);
 		f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ;
 		fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
@@ -385,12 +385,12 @@ static void fc_lport_recv_echo_req(struc
 }
 
 /**
- * fc_lport_recv_echo_req() - Handle received Request Node ID data request
- * @lport: Fibre Channel local port recieving the RNID
- * @sp: current sequence in the RNID exchange
- * @fp: RNID request frame
+ * fc_lport_recv_rnid_req() - Handle received Request Node ID data request
+ * @sp:	   The sequence in the RNID exchange
+ * @fp:	   The RNID request frame
+ * @lport: The local port recieving the RNID
  *
- * Locking Note: The lport lock is exected to be held before calling
+ * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
 static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
@@ -667,7 +667,7 @@ static void fc_lport_enter_ready(struct 
  * Accept it with the common service parameters indicating our N port.
  * Set up to do a PLOGI if we have the higher-number WWPN.
  *
- * Locking Note: The lport lock is exected to be held before calling
+ * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
 static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,


