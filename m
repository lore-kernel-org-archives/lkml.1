Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbYLCUOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbYLCUOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbYLCTyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:38 -0500
Received: from kroah.org ([198.145.64.141]:60371 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754096AbYLCTyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:36 -0500
Date: Wed, 3 Dec 2008 11:53:00 -0800
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
       alan@lxorguk.ukuu.org.uk, Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [patch 062/104] ACPI: EC: count interrupts only if called from
	interrupt handler.
Message-ID: <20081203195300.GK8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-ec-count-interrupts-only-if-called-from-interrupt-handler.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit 7b4d469228a92a00e412675817cedd60133de38a upstream.

fix 2.6.28 EC interrupt storm regression

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/ec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -219,7 +219,8 @@ static void gpe_transaction(struct acpi_
 	goto unlock;
 err:
 	/* false interrupt, state didn't change */
-	++ec->curr->irq_count;
+	if (in_interrupt())
+		++ec->curr->irq_count;
 unlock:
 	spin_unlock_irqrestore(&ec->curr_lock, flags);
 }

