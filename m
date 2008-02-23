Return-Path: <linux-kernel-owner+w=401wt.eu-S937563AbYBWAt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937563AbYBWAt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933510AbYBWAgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:36:15 -0500
Received: from mx1.suse.de ([195.135.220.2]:45039 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935673AbYBWAgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:36:10 -0500
Date: Fri, 22 Feb 2008 16:31:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 33/38] SCSI: gdth: scan for scsi devices
Message-ID: <20080223003130.GH7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-gdth-scan-for-scsi-devices.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Boaz Harrosh <bharrosh@panasas.com>

commit: 61c92814dc324b541391757062ff02fbf3b08086

The patch: "gdth: switch to modern scsi host registration"

missed one simple fact when moving a way from scsi_module.c.
That is to call scsi_scan_host() on the probed host.
With this the gdth driver from 2.6.24 is again able to
see drives and boot.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Tested-by: Joerg Dorchain <joerg@dorchain.net>
Tested-by: Stefan Priebe <s.priebe@allied-internet.ag>
Tested-by: Jon Chelton <jchelton@ffpglobal.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/gdth.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4838,6 +4838,9 @@ static int __init gdth_isa_probe_one(ulo
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+
+	scsi_scan_host(shp);
+
 	return 0;
 
  out_free_coal_stat:
@@ -4965,6 +4968,9 @@ static int __init gdth_eisa_probe_one(us
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+
+	scsi_scan_host(shp);
+
 	return 0;
 
  out_free_ccb_phys:
@@ -5102,6 +5108,9 @@ static int __init gdth_pci_probe_one(gdt
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+
+	scsi_scan_host(shp);
+
 	return 0;
 
  out_free_coal_stat:

-- 
