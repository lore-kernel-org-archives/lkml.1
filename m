Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYKOFcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYKOFcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 00:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbYKOFZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 00:25:30 -0500
Received: from kroah.org ([198.145.64.141]:48147 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751622AbYKOFZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 00:25:16 -0500
Date: Fri, 14 Nov 2008 21:24:00 -0800
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
       alan@lxorguk.ukuu.org.uk, Adam Jackson <ajax@redhat.com>,
       Mattia Dongili <malattia@linux.it>, Len Brown <lenb@kernel.org>,
       Steve Conklin <sconklin@canonical.com>
Subject: [patch 22/22] sony-laptop: ignore missing _DIS method on pic device
Message-ID: <20081115052400.GW3710@kroah.com>
References: <20081115051732.506914008@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sony-laptop-ignore-missing-_dis-method-on-pic-device.patch"
In-Reply-To: <20081115052220.GA3710@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matthew Garrett <mjg59@srcf.ucam.org>

commit 6158d3a2323835546c7cf83a170316fa77b726e0 upstream.

At least the Vaio VGN-Z540N doesn't have this method, so let's not fail
to suspend just because it doesn't exist.

Signed-off-by: Adam Jackson <ajax@redhat.com>
Acked-by: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steve Conklin <sconklin@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/misc/sony-laptop.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -2315,8 +2315,10 @@ end:
  */
 static int sony_pic_disable(struct acpi_device *device)
 {
-	if (ACPI_FAILURE(acpi_evaluate_object(device->handle,
-			"_DIS", NULL, NULL)))
+	acpi_status ret = acpi_evaluate_object(device->handle, "_DIS", NULL,
+					       NULL);
+
+	if (ACPI_FAILURE(ret) && ret != AE_NOT_FOUND)
 		return -ENXIO;
 
 	dprintk("Device disabled\n");

-- 
