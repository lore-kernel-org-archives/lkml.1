Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbXBLJIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbXBLJIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933137AbXBLJIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:08:49 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:39389 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933127AbXBLJIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:08:49 -0500
Date: Mon, 12 Feb 2007 01:39:41 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 06/10] nfnetlink_log: micro-optimization: don't modify destroyed instance
Message-ID: <20070212003941.GG8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simple micro-optimization: Don't change any options if the instance is
being destroyed.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.4	2007-02-11 20:46:26.000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 22:24:56.000000000 +0100
@@ -829,7 +829,8 @@ nfulnl_recv_config(struct sock *ctnl, st
 			}
 
 			instance_destroy(inst);
-			break;
+			/* no point in changing anything in destroyed instance */
+			goto out_put;
 		case NFULNL_CFG_CMD_PF_BIND:
 			UDEBUG("registering log handler for pf=%u\n", pf);
 			ret = nf_log_register(pf, &nfulnl_logger);
