Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbXJaPXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbXJaPXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbXJaPXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:23:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33369 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbXJaPXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:23:39 -0400
Date: Wed, 31 Oct 2007 08:10:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: [patch 02/26] Fix ESP host instance numbering.
Message-ID: <20071031151048.GC2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-esp-host-instance-numbering.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David Miller <davem@davemloft.net>

changeset ff4abd6cfacf0bb23a077f615d3a5cd17359db1b in mainline.

The ESP scsi driver does not initialize the host controller
instance early enough, so the messages in the log confuse
users.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/esp_scsi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2318,6 +2318,7 @@ int __devinit scsi_esp_register(struct e
 	esp->host->transportt = esp_transport_template;
 	esp->host->max_lun = ESP_MAX_LUN;
 	esp->host->cmd_per_lun = 2;
+	esp->host->unique_id = instance;
 
 	esp_set_clock_params(esp);
 
@@ -2341,7 +2342,7 @@ int __devinit scsi_esp_register(struct e
 	if (err)
 		return err;
 
-	esp->host->unique_id = instance++;
+	instance++;
 
 	scsi_scan_host(esp->host);
 

-- 
