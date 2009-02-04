Return-Path: <linux-kernel-owner+w=401wt.eu-S1763801AbZBDTEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763801AbZBDTEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760339AbZBDStp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:45 -0500
Received: from kroah.org ([198.145.64.141]:32958 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759476AbZBDStf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:35 -0500
Date: Wed, 4 Feb 2009 10:46:58 -0800
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
       alan@lxorguk.ukuu.org.uk, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: [patch 35/41] dont load asus-acpi if model is not supported
Message-ID: <20090204184658.GJ25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="don-t-load-asus-acpi-if-model-is-not-supported.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 7745384080ef70f7710530afa3e45477b126e056 upstream.

asus_hotk_get_info should return -ENODEV if the model is not supported.
http://bugzilla.kernel.org/show_bug.cgi?id=10389

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/asus_acpi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/acpi/asus_acpi.c
+++ b/drivers/acpi/asus_acpi.c
@@ -1244,6 +1244,8 @@ static int asus_hotk_get_info(void)
 			       "default values\n", string);
 			printk(KERN_NOTICE
 			       "  send /proc/acpi/dsdt to the developers\n");
+			kfree(model);
+			return -ENODEV;
 		}
 		hotk->methods = &model_conf[hotk->model];
 		return AE_OK;

