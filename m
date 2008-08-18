Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbYHRSv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbYHRSv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759617AbYHRSvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:51:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:34948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759602AbYHRSu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:50:56 -0400
Date: Mon, 18 Aug 2008 11:42:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 15/60] usb-storage: unusual_devs entries for iRiver T10 and
	Datafab CF+SM reader
Message-ID: <20080818184257.GP29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="usb-storage-unusual_devs-entries-for-iriver-t10-and-datafab-cf-sm-reader.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 368ee6469c327364ea10082a348f91c1f5ba47f7 upstream

This patch (as1115) adds unusual_devs entries with the IGNORE_RESIDE
flag for the iRiver T10 and the Simple Tech/Datafab CF+SM card
reader.  Apparently these devices provide reasonable residue values
for READ and WRITE operations, but not for others like INQUIRY or READ
CAPACITY.

This fixes the iRiver T10 problem reported in Bugzilla #11125.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1187,6 +1187,13 @@ UNUSUAL_DEV(  0x07c4, 0xa400, 0x0000, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY ),
 
+/* Reported by Rauch Wolke <rauchwolke@gmx.net> */
+UNUSUAL_DEV(  0x07c4, 0xa4a5, 0x0000, 0xffff,
+		"Simple Tech/Datafab",
+		"CF+SM Reader",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_IGNORE_RESIDUE ),
+
 /* Casio QV 2x00/3x00/4000/8000 digital still cameras are not conformant
  * to the USB storage specification in two ways:
  * - They tell us they are using transport protocol CBI. In reality they
@@ -1758,6 +1765,13 @@ UNUSUAL_DEV(  0x2770, 0x915d, 0x0010, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Reported by Andrey Rahmatullin <wrar@altlinux.org> */
+UNUSUAL_DEV(  0x4102, 0x1020, 0x0100,  0x0100,
+		"iRiver",
+		"MP3 T10",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_IGNORE_RESIDUE ),
+
 /*
  * David Härdeman <david@2gen.com>
  * The key makes the SCSI stack print confusing (but harmless) messages

-- 
