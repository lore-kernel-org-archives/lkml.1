Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYJRTNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYJRTNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYJRTEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:04:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbYJRTEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:04:42 -0400
Date: Sat, 18 Oct 2008 11:47:48 -0700
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
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 11/26] libata: fix EH action overwriting in ata_eh_reset()
Message-ID: <20081018184748.GL301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-fix-eh-action-overwriting-in-ata_eh_reset.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Tejun Heo <tj@kernel.org>

Commit a674050e068a2919908730279f0b731ae6d2e005 upstream

ehc->i.action got accidentally overwritten to ATA_EH_HARD/SOFTRESET in
ata_eh_reset().  The original intention was to clear reset action
which wasn't selected.  This can cause unexpected behavior when other
EH actions are scheduled together with reset.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2112,10 +2112,10 @@ int ata_eh_reset(struct ata_link *link, 
 	ehc->i.action &= ~ATA_EH_RESET;
 	if (hardreset) {
 		reset = hardreset;
-		ehc->i.action = ATA_EH_HARDRESET;
+		ehc->i.action |= ATA_EH_HARDRESET;
 	} else if (softreset) {
 		reset = softreset;
-		ehc->i.action = ATA_EH_SOFTRESET;
+		ehc->i.action |= ATA_EH_SOFTRESET;
 	}
 
 	if (prereset) {

-- 
