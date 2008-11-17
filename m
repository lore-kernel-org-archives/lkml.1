Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbYKQHWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbYKQHWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYKQHU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:20:57 -0500
Received: from kroah.org ([198.145.64.141]:38190 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751630AbYKQHUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:20:54 -0500
Date: Sun, 16 Nov 2008 23:14:29 -0800
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
       alan@lxorguk.ukuu.org.uk, Eilon Greenstein <eilong@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>, Alex Chiang <achiang@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 05/46] bnx2x: Removing the PMF indication when unloading
Message-ID: <20081117071429.GF29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bnx2x-removing-the-pmf-indication-when-unloading.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eilon Greenstein <eilong@broadcom.com>

commit 9a0354405feb0f8bd460349a93db05e4cca8d166 upstream.

When the PMF flag is set, the driver can access the HW freely. When the
driver is unloaded, it should not access the HW. The problem caused fatal
errors when "ethtool -i" was called after the calling instance was unloaded
and another instance was already loaded

Signed-off-by: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Alex Chiang <achiang@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bnx2x_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/bnx2x_main.c
+++ b/drivers/net/bnx2x_main.c
@@ -6480,6 +6480,7 @@ load_int_disable:
 	bnx2x_free_irq(bp);
 load_error:
 	bnx2x_free_mem(bp);
+	bp->port.pmf = 0;
 
 	/* TBD we really need to reset the chip
 	   if we want to recover from this */
@@ -6790,6 +6791,7 @@ unload_error:
 	/* Report UNLOAD_DONE to MCP */
 	if (!BP_NOMCP(bp))
 		bnx2x_fw_command(bp, DRV_MSG_CODE_UNLOAD_DONE);
+	bp->port.pmf = 0;
 
 	/* Free SKBs, SGEs, TPA pool and driver internals */
 	bnx2x_free_skbs(bp);

-- 
