Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYKQH3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYKQH3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbYKQHVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:24 -0500
Received: from kroah.org ([198.145.64.141]:38451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754426AbYKQHVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:13 -0500
Date: Sun, 16 Nov 2008 23:15:39 -0800
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
       Steve Conklin <sconklin@canonical.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 22/46] sony-laptop: ignore missing _DIS method on pic device
Message-ID: <20081117071539.GW29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sony-laptop-ignore-missing-_dis-method-on-pic-device.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
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
