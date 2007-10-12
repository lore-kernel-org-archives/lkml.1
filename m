Return-Path: <linux-kernel-owner+w=401wt.eu-S1761328AbXJLR5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328AbXJLR5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbXJLR5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:57:30 -0400
Received: from 193.4.221.87.dynamic.jazztel.es ([87.221.4.193]:41899 "EHLO
	traven.no-ip.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756263AbXJLR52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:57:28 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2007 13:57:28 EDT
Date: Fri, 12 Oct 2007 19:57:23 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: krh@redhat.com, stefanr@s5r6.in-berlin.de,
       linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/2] ieee1394_core.c: use DEFINE_SPINLOCK for spinlock
	definition
Message-ID: <20071012175723.GE3564@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	krh@redhat.com, stefanr@s5r6.in-berlin.de,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/ieee1394/ieee1394_core.c: Define spinlock using
DEFINE_SPINLOCK instead of assignment to SPIN_LOCK_UNLOCKED

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/ieee1394/ieee1394_core.c b/drivers/ieee1394/ieee1394_core.c
index 98fd985..36c747b 100644
--- a/drivers/ieee1394/ieee1394_core.c
+++ b/drivers/ieee1394/ieee1394_core.c
@@ -488,7 +488,7 @@ void hpsb_selfid_complete(struct hpsb_host *host, int phyid, int isroot)
 	highlevel_host_reset(host);
 }
 
-static spinlock_t pending_packets_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(pending_packets_lock);
 
 /**
  * hpsb_packet_sent - notify core of sending a packet

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

     La guerra es un acto abominable en el que se matan personas que no
      se conocen, dirigidas por personas que se conocen y no se matan
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
