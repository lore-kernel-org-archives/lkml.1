Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbYD2R2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbYD2R2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbYD2RVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:21:17 -0400
Received: from ns2.suse.de ([195.135.220.15]:43212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbYD2RVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:21:16 -0400
Date: Tue, 29 Apr 2008 10:18:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jeff@garzik.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       support@neterion.com, Santosh Rastapur <santosh.rastapur@neterion.com>,
       Ramkrishna Vepa <ram.vepa@neterion.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [18/37] S2io: Fix memory leak during free_tx_buffers
Message-ID: <20080429171838.GS14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="s2io-fix-memory-leak-during-free_tx_buffers.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Sreenivasa Honnur <Sreenivasa.Honnur@neterion.com>

commit b35b3b49fc6750806964048b31799c8782980ef9 upstream

- Fix the memory leak during free_tx_buffers.

Signed-off-by: Santosh Rastapur <santosh.rastapur@neterion.com>
Signed-off-by: Ramkrishna Vepa <ram.vepa@neterion.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/s2io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -2339,7 +2339,7 @@ static void free_tx_buffers(struct s2io_
 	for (i = 0; i < config->tx_fifo_num; i++) {
 		unsigned long flags;
 		spin_lock_irqsave(&mac_control->fifos[i].tx_lock, flags);
-		for (j = 0; j < config->tx_cfg[i].fifo_len - 1; j++) {
+		for (j = 0; j < config->tx_cfg[i].fifo_len; j++) {
 			txdp = (struct TxD *) \
 			mac_control->fifos[i].list_info[j].list_virt_addr;
 			skb = s2io_txdl_getskb(&mac_control->fifos[i], txdp, j);

-- 
