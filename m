Return-Path: <linux-kernel-owner+w=401wt.eu-S1422909AbXCGRVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422909AbXCGRVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422940AbXCGRVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:21:24 -0500
Received: from ns2.suse.de ([195.135.220.15]:43913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422909AbXCGRSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:44 -0500
Message-Id: <20070307171704.096175305@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       mm-commits@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, petero2@telia.com, gd@spherenet.de
Subject: [patch 099/101] pktcdvd: Correctly set cmd_len field in pkt_generic_packet
Content-Disposition: inline; filename=pktcdvd-correctly-set-cmd_len-field-in-pkt_generic_packet.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Gerhard Dirschl <gd@spherenet.de>

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=7810 - a silly
copy-paste bug introduced by the latest change.

Signed-off-by: Gerhard Dirschl <gd@spherenet.de>
Cc: Peter Osterlund <petero2@telia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/pktcdvd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/drivers/block/pktcdvd.c
+++ linux-2.6.20.1/drivers/block/pktcdvd.c
@@ -777,7 +777,7 @@ static int pkt_generic_packet(struct pkt
 			goto out;
 	}
 
-	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
+	rq->cmd_len = COMMAND_SIZE(cgc->cmd[0]);
 	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
 	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
 		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PACKET_SIZE);

--
