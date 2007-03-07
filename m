Return-Path: <linux-kernel-owner+w=401wt.eu-S965608AbXCGRXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965608AbXCGRXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965586AbXCGRXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:23:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422891AbXCGRSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:36 -0500
Message-Id: <20070307171654.144647936@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       James.Bottomley@steeleye.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Achim_Leubner@adaptec.com, joerg@dorchain.net,
       linux-scsi@vger.kernel.org
Subject: [patch 096/101] bug in gdth.c crashing machine
Content-Disposition: inline; filename=bug-in-gdth.c-crashing-machine.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Joerg Dorchain <joerg@dorchain.net>

Undocumented...

Signed-off-by: Joerg Dorchain <joerg@dorchain.net>
Acked-by: Achim Leubner <Achim_Leubner@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/gdth.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.20.1.orig/drivers/scsi/gdth.c
+++ linux-2.6.20.1/drivers/scsi/gdth.c
@@ -3092,6 +3092,7 @@ static int gdth_fill_raw_cmd(int hanum,S
             cmdp->u.raw64.direction  = 
                 gdth_direction_tab[scp->cmnd[0]]==DOU ? GDTH_DATA_OUT:GDTH_DATA_IN;
             memcpy(cmdp->u.raw64.cmd,scp->cmnd,16);
+            cmdp->u.raw64.sg_ranz    = 0;
         } else {
             cmdp->u.raw.reserved   = 0;
             cmdp->u.raw.mdisc_time = 0;
@@ -3108,6 +3109,7 @@ static int gdth_fill_raw_cmd(int hanum,S
             cmdp->u.raw.direction  = 
                 gdth_direction_tab[scp->cmnd[0]]==DOU ? GDTH_DATA_OUT:GDTH_DATA_IN;
             memcpy(cmdp->u.raw.cmd,scp->cmnd,12);
+            cmdp->u.raw.sg_ranz    = 0;
         }
 
         if (scp->use_sg) {

--
