Return-Path: <linux-kernel-owner+w=401wt.eu-S932209AbZFIK2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbZFIK2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZFIKUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:06 -0400
Received: from kroah.org ([198.145.64.141]:55014 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760760AbZFIKUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:04 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:03 2009
Message-Id: <20090609094103.080454984@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 47/87] igb: fix LRO warning
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=igb-fix-lro-warning.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

This fix is only needed for 2.6.29.y tree, since in 2.6.30 and later IGB
has moved to using GRO instead of LRO.

igb supports LRO, but was not setting any hooks to the ->set_flags
ethtool_ops function.  This would trigger warnings if the user tried
to enable or disable LRO.

Based on the patch provided by Stephen Hemminger <shemminger@vyatta.com>

Reported-by: Sergey Kononenko <sergk@sergk.org.ua>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/igb/igb_ethtool.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/igb/igb_ethtool.c
+++ b/drivers/net/igb/igb_ethtool.c
@@ -2024,6 +2024,10 @@ static struct ethtool_ops igb_ethtool_op
 	.get_ethtool_stats      = igb_get_ethtool_stats,
 	.get_coalesce           = igb_get_coalesce,
 	.set_coalesce           = igb_set_coalesce,
+	.get_flags              = ethtool_op_get_flags,
+#ifdef CONFIG_IGB_LRO
+	.set_flags              = ethtool_op_set_flags,
+#endif
 };
 
 void igb_set_ethtool_ops(struct net_device *netdev)


