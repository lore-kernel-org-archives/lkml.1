Return-Path: <linux-kernel-owner+w=401wt.eu-S1763420AbZBDTCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763420AbZBDTCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761437AbZBDStk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:40 -0500
Received: from kroah.org ([198.145.64.141]:32884 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759468AbZBDSt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:29 -0500
Date: Wed, 4 Feb 2009 10:46:46 -0800
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
       alan@lxorguk.ukuu.org.uk, Thomas Renninger <trenn@suse.de>,
       Matthew Wilcox <willy@linux.intel.com>, Len Brown <len.brown@intel.com>
Subject: [patch 29/41] ACPI: Fix compiler warnings introduced by 32 to 64
	bit acpi conversions
Message-ID: <20090204184646.GD25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-fix-compiler-warnings-introduced-by-32-to-64-bit-acpi-conversions.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Renninger <trenn@suse.de>

commit: 27663c5855b10af9ec67bc7dfba001426ba21222 forgot to convert things at
two prints.

Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/intel_menlow.c       |    2 +-
 drivers/pci/hotplug/acpiphp_ibm.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/misc/intel_menlow.c
+++ b/drivers/misc/intel_menlow.c
@@ -104,7 +104,7 @@ static int memory_get_cur_bandwidth(stru
 	if (ACPI_FAILURE(status))
 		return -EFAULT;
 
-	return sprintf(buf, "%ld\n", value);
+	return sprintf(buf, "%lld\n", value);
 }
 
 static int memory_set_cur_bandwidth(struct thermal_cooling_device *cdev,
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -204,7 +204,7 @@ static int ibm_set_attention_status(stru
 		err("APLS evaluation failed:  0x%08x\n", stat);
 		return -ENODEV;
 	} else if (!rc) {
-		err("APLS method failed:  0x%08lx\n", rc);
+		err("APLS method failed:  0x%08llx\n", rc);
 		return -ERANGE;
 	}
 	return 0;

