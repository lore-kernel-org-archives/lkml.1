Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbXJWPxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbXJWPxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbXJWPxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:53:22 -0400
Received: from flpi185.sbcis.sbc.com ([207.115.20.187]:42134 "EHLO
	flpi185.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbXJWPxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:53:21 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2007 11:53:21 EDT
X-ORBL: [76.241.169.38]
From: Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4/5] NET: Make ts_recent_stamp unsigned
To: linux-kernel@vger.kernel.org
Cc: Chuck Lever <chuck.lever@oracle.com>
Date: Tue, 23 Oct 2007 11:44:28 -0400
Message-ID: <20071023154428.28115.10406.stgit@ingres.1015granger.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The get_seconds() function returns an unsigned long.  To prevent incorrect
comparison results between values saved in ts_recent_stamp and later
invocations of get_seconds(), change the type of ts_recent_stamp to match
the return type of get_seconds().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <netdev@vger.kernel.org>
---

 include/linux/tcp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index bac17c5..129ddb4 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -206,7 +206,7 @@ struct tcp_sack_block {
 
 struct tcp_options_received {
 /*	PAWS/RTTM data	*/
-	long	ts_recent_stamp;/* Time we stored ts_recent (for aging) */
+	unsigned long ts_recent_stamp;/* Time we stored ts_recent (for aging) */
 	u32	ts_recent;	/* Time stamp to echo next		*/
 	u32	rcv_tsval;	/* Time stamp value             	*/
 	u32	rcv_tsecr;	/* Time stamp echo reply        	*/

