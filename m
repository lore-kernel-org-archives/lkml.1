Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528Ab0AZX6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0AZX6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494Ab0AZXng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:36 -0500
Received: from kroah.org ([198.145.64.141]:35282 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436Ab0AZXne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:34 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:26 2010
Message-Id: <20100126233926.279971865@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [41/98] [SCSI] libfc: fix typo in retry check on received PRLI
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joe Eykholt <jeykholt@cisco.com>

commit 85b5893ca97c69e409ecbb5ee90a5d99882369c4 upstream.

A received Fibre Channel ELS PRLI request contains a bit that
indicates whether the remote port supports certain retry processing
sequences.  The test for this bit was somehow coded to use multiply
instead of AND!

This case would apply only for target mode operation, and it is
unlikely to be noticed as an initiator.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libfc/fc_rport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1402,7 +1402,7 @@ static void fc_rport_recv_prli_req(struc
 				break;
 			case FC_TYPE_FCP:
 				fcp_parm = ntohl(rspp->spp_params);
-				if (fcp_parm * FCP_SPPF_RETRY)
+				if (fcp_parm & FCP_SPPF_RETRY)
 					rdata->flags |= FC_RP_FLAGS_RETRY;
 				rdata->supported_classes = FC_COS_CLASS3;
 				if (fcp_parm & FCP_SPPF_INIT_FCN)


