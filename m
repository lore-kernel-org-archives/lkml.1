Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbYICRcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbYICRcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbYICRcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:32:19 -0400
Received: from ns2.suse.de ([195.135.220.15]:54784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbYICRcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:32:17 -0400
Date: Wed, 3 Sep 2008 10:25:20 -0700
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
       alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Corentin Chary <corentincj@iksaif.net>,
       Karol Kozimor <sziwan@users.sourceforge.net>
Subject: [patch 03/42] eeepc-laptop: fix use after free
Message-ID: <20080903172520.GD7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="eeepc-laptop-fix-use-after-free.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matthew Garrett <mjg59@srcf.ucam.org>

commit f14413184b1de4dcbd5ec3e7c129c3ce2079f543 upstream

Date: Wed, 20 Aug 2008 14:08:57 -0700
Subject: [patch 03/42] eeepc-laptop: fix use after free

eeepc-laptop uses the hwmon struct after unregistering the device, causing
an oops on module unload.  Flip the ordering to fix.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Karol Kozimor <sziwan@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/eeepc-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/eeepc-laptop.c
+++ b/drivers/misc/eeepc-laptop.c
@@ -553,9 +553,9 @@ static void eeepc_hwmon_exit(void)
 	hwmon = eeepc_hwmon_device;
 	if (!hwmon)
 		return ;
-	hwmon_device_unregister(hwmon);
 	sysfs_remove_group(&hwmon->kobj,
 			   &hwmon_attribute_group);
+	hwmon_device_unregister(hwmon);
 	eeepc_hwmon_device = NULL;
 }
 

-- 
