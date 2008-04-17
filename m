Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbYDQB1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbYDQB1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbYDQBJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:09:30 -0400
Received: from sous-sol.org ([216.99.217.87]:59001 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761289AbYDQBJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:09:29 -0400
Message-Id: <20080417010336.334108122@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Brad Sawatzky <brad+kernel@swatter.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: USB: serial: fix regression in Visor/Palm OS module for kernels >= 2.6.24
Content-Disposition: inline; filename=usb-serial-fix-regression-in-visor-palm-os-module-for-kernels-2.6.24.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Brad Sawatzky <brad+kernel@swatter.net>

upstream commit: d04863e9e65767feff7807c8f693ac2719dd1944

Fixes a bug/inconsistency revealed by the additional sanity checking in
   commit 063a2da8f01806906f7d7b1a1424b9afddebc443
introduced in the original 2.6.24 branch.

The Handspring Visor / PalmOS 4 device structure defines .num_bulk_out=2
but the usb-serial probe returns num_bulk_out=3, triggering the check in
the above commit and forcing a bail out when the device (a Garmin iQue in
my case) attempts to connect.  The patch bumps the expected number of
endpoints to 3.

FWIW, this patch will probably solve the following kernel bug report for
Treo users (identical symptoms, different model PalmOS units):
  <http://bugzilla.kernel.org/show_bug.cgi?id=10118>


Signed-off-by: Brad Sawatzky <brad+kernel@swatter.net>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/serial/visor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -191,7 +191,7 @@ static struct usb_serial_driver handspri
 	.id_table =		id_table,
 	.num_interrupt_in =	NUM_DONT_CARE,
 	.num_bulk_in =		2,
-	.num_bulk_out =		2,
+	.num_bulk_out =		NUM_DONT_CARE,
 	.num_ports =		2,
 	.open =			visor_open,
 	.close =		visor_close,

-- 
