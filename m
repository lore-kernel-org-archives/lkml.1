Return-Path: <linux-kernel-owner+w=401wt.eu-S1762351AbZAWGYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762351AbZAWGYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761130AbZAWGQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:16:44 -0500
Received: from kroah.org ([198.145.64.141]:36318 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760979AbZAWGQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:40 -0500
Date: Thu, 22 Jan 2009 22:14:06 -0800
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
       alan@lxorguk.ukuu.org.uk, Dean Nelson <dcn@sgi.com>,
       Robin Holt <holt@sgi.com>
Subject: [patch 21/40] sgi-xp: eliminate false detection of no heartbeat
Message-ID: <20090123061406.GU2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sgi-xp-eliminate-false-detection-of-no-heartbeat.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dean Nelson <dcn@sgi.com>

commit 158bc69effbf96f59c01cdeb20f8d4c184e59f8e upstream.

After XPC has been up and running on multiple partitions for any length of
time, if XPC on one of the partitions is stopped and restarted (either by
a rmmod/insmod or a system restart), it is possible for the XPCs running
on the other partitions to falsely detect a lack of heartbeat from the XPC
that was just restarted.  This false detection will occur if the restarted
XPC comes up within the five-seconds preceding one of the other XPC's
heartbeat check (which occurs once every twenty seconds).

The detection of no heartbeat results in the detecting XPC deactivating
from the just restarted XPC.  The only remedy is to restart one of the
XPCs and hope that one doesn't hit this five-second window on any of the
other partitions.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/sgi-xp/xpc_sn2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/sgi-xp/xpc_sn2.c
+++ b/drivers/misc/sgi-xp/xpc_sn2.c
@@ -904,7 +904,7 @@ xpc_update_partition_info_sn2(struct xpc
 	dev_dbg(xpc_part, "  remote_vars_pa = 0x%016lx\n",
 		part_sn2->remote_vars_pa);
 
-	part->last_heartbeat = remote_vars->heartbeat;
+	part->last_heartbeat = remote_vars->heartbeat - 1;
 	dev_dbg(xpc_part, "  last_heartbeat = 0x%016lx\n",
 		part->last_heartbeat);
 

