Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbZKKEc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbZKKEc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 23:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbZKKEc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 23:32:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42415 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbZKKEc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 23:32:57 -0500
Date: Wed, 11 Nov 2009 15:33:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the pcmcia tree with the wireless tree
Message-Id: <20091111153302.0f5074ef.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dominik,

Today's linux-next merge of the pcmcia tree got a conflict in
drivers/net/wireless/ray_cs.c between commit
40cca2919c1994c01addfac2320ee77f4b9e12cf ("drivers/net/wireless: correct
check on CCS_START_NETWORK") from the wireless tree and commit
624dd66957e53e15cf40e937b50597c4d41f0e99 ("pcmcia: use dynamic debug
infrastructure, deprecate CS_CHECK (ray-cs.c)") from the pcmcia tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/ray_cs.c
index 5ee9d2a,28db791..0000000
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@@ -2074,8 -2065,8 +2065,8 @@@ static irqreturn_t ray_interrupt(int ir
  				del_timer(&local->timer);
  				local->timer.expires = jiffies + HZ * 5;
  				local->timer.data = (long)local;
 -				if (status == CCS_START_NETWORK) {
 +				if (cmd == CCS_START_NETWORK) {
- 					DEBUG(0,
+ 					dev_dbg(&link->dev,
  					      "ray_cs interrupt network \"%s\" start failed\n",
  					      local->sparm.b4.a_current_ess_id);
  					local->timer.function = &start_net;
