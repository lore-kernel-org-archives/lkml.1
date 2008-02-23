Return-Path: <linux-kernel-owner+w=401wt.eu-S936151AbYBWAg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936151AbYBWAg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbYBWAdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:33:40 -0500
Received: from ns.suse.de ([195.135.220.2]:44667 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765742AbYBWAdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:33:37 -0500
Date: Fri, 22 Feb 2008 16:30:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 08/38] Fix dl2k constants
Message-ID: <20080223003001.GI7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-dl2k-constants.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
 

patch 9c52fab2f187636b39afb0dcf562872ed42ab608 in mainline.

The MSSR constants didn't match the reality - bitfield declarations
used to be correct (1000BT_FD - bit 11, 1000BT_HD - bit 10), but enum
had them the other way round.  Went unnoticed until the switch from
the bitfields use to the explicit arithmetics and I hadn't caught that one
when verifying correctness of change...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/dl2k.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/dl2k.h
+++ b/drivers/net/dl2k.h
@@ -388,8 +388,8 @@ enum _mii_mssr {
 	MII_MSSR_CFG_RES = 0x4000,
 	MII_MSSR_LOCAL_RCV_STATUS = 0x2000,
 	MII_MSSR_REMOTE_RCVR = 0x1000,
-	MII_MSSR_LP_1000BT_HD = 0x0800,
-	MII_MSSR_LP_1000BT_FD = 0x0400,
+	MII_MSSR_LP_1000BT_FD = 0x0800,
+	MII_MSSR_LP_1000BT_HD = 0x0400,
 	MII_MSSR_IDLE_ERR_COUNT = 0x00ff,
 };
 

-- 
