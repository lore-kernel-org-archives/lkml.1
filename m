Return-Path: <linux-kernel-owner+w=401wt.eu-S1762036AbYF0TGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762036AbYF0TGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 15:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbYF0TGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 15:06:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51210 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbYF0TGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 15:06:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 27 Jun 2008 21:05:06 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] firewire update
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.712c21676f56d622@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following one-liner.

Richard Sharpe (1):
      firewire: fw-sbp2: fix parsing of logical unit directories

 drivers/firewire/fw-sbp2.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


commit 0e3e2eabf4fbc0162e1f1eb4fd90cb3e9513a554
Author: Richard Sharpe <realrichardsharpe@gmail.com>
Date:   Tue Jun 24 19:11:13 2008 -0700

    firewire: fw-sbp2: fix parsing of logical unit directories
    
    There is a small off-by-one bug in firewire-sbp2. This causes problems
    when a device exports multiple LUN Directories. I found it when trying
    to talk to a SONY DVD Jukebox.
    
    Signed-off-by: Richard Sharpe <realrichardsharpe@gmail.com>
    Acked-by: Kristian Høgsberg <krh@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (op. order, changelog)

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index b2458bb..227d2e0 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1051,7 +1051,8 @@ static int sbp2_scan_unit_dir(struct sbp2_target *tgt, u32 *directory,
 			break;
 
 		case SBP2_CSR_LOGICAL_UNIT_DIRECTORY:
-			if (sbp2_scan_logical_unit_dir(tgt, ci.p + value) < 0)
+			/* Adjust for the increment in the iterator */
+			if (sbp2_scan_logical_unit_dir(tgt, ci.p - 1 + value) < 0)
 				return -ENOMEM;
 			break;
 		}
-- 
Stefan Richter
-=====-==--- -==- ==-==
http://arcgraph.de/sr/

