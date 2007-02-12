Return-Path: <linux-kernel-owner+w=401wt.eu-S965367AbXBLUWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965367AbXBLUWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965365AbXBLUWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:22:43 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:48944 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965318AbXBLUWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:22:41 -0500
Date: Mon, 12 Feb 2007 21:22:24 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 12/14] nfnetlink_log: possible NULL pointer dereference in nfulnl_recv_config()
Message-ID: <20070212202224.GC28704@rere.qmqm.pl>
References: <20070212003738.GA8262@rere.qmqm.pl> <20070212202052.GA28704@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070212202052.GA28704@rere.qmqm.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate possible NULL pointer dereference in nfulnl_recv_config().

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.10	2007-02-12 17:05:14.000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-12 17:35:50.000000000 +0100
@@ -853,6 +853,9 @@ nfulnl_recv_config(struct sock *ctnl, st
 			ret = -EINVAL;
 			break;
 		}
+
+		if (!inst)
+			goto out_null;
 	} else {
 		if (!inst) {
 			UDEBUG("no config command, and no instance for "
