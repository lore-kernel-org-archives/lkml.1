Return-Path: <linux-kernel-owner+w=401wt.eu-S1760527AbZBDS7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527AbZBDS7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761393AbZBDSt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:28 -0500
Received: from kroah.org ([198.145.64.141]:60987 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760190AbZBDStT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:19 -0500
Date: Wed, 4 Feb 2009 10:46:28 -0800
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
       alan@lxorguk.ukuu.org.uk, Len Brown <len.brown@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Renninger <trenn@suse.de>
Subject: [patch 20/41] cpuidle: update the last_state acpi cpuidle
	reflecting actual state entered
Message-ID: <20090204184628.GU25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cpuidle-update-the-last_state-acpi-cpuidle-reflecting-actual-state-entered.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

commit addbad46ed0906cd584784423b9d0babc7476446

reflect the actual state entered in dev->last_state, when actaul state entered
is different from intended one.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/processor_idle.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1587,6 +1587,7 @@ static int acpi_idle_enter_bm(struct cpu
 
 	if (acpi_idle_bm_check()) {
 		if (dev->safe_state) {
+			dev->last_state = dev->safe_state;
 			return dev->safe_state->enter(dev, dev->safe_state);
 		} else {
 			local_irq_disable();

