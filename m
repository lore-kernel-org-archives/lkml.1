Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbYKDXmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbYKDXmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757251AbYKDXiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:38:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:47341 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019AbYKDXiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:38:18 -0500
Date: Tue, 4 Nov 2008 15:31:24 -0800
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
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 13/57] libata: initialize port_task when !CONFIG_ATA_SFF
Message-ID: <20081104233124.GN659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-initialize-port_task-when-config_ata_sff.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <tj@kernel.org>

commit f667fdbbbea8bcce6cf9f7acb51b7cb4c264cc61 upstream

ap->port_task was not initialized if !CONFIG_ATA_SFF later triggering
lockdep warning.  Make sure it's initialized.

Reported by Larry Finger.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5259,6 +5259,8 @@ struct ata_port *ata_port_alloc(struct a
 
 #ifdef CONFIG_ATA_SFF
 	INIT_DELAYED_WORK(&ap->port_task, ata_pio_task);
+#else
+	INIT_DELAYED_WORK(&ap->port_task, NULL);
 #endif
 	INIT_DELAYED_WORK(&ap->hotplug_task, ata_scsi_hotplug);
 	INIT_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);

-- 
