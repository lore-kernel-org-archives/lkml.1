Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbZBKAgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbZBKAgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbZBKA2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:30 -0500
Received: from kroah.org ([198.145.64.141]:51235 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757646AbZBKA21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:27 -0500
Date: Tue, 10 Feb 2009 16:25:06 -0800
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
       alan@lxorguk.ukuu.org.uk, Zhao Yakui <yakui.zhao@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: [patch 25/56] ACPI: proc_dir_entry video/VGA already registered
Message-ID: <20090211002506.GZ14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-proc_dir_entry-video-vga-already-registered.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit f3b39f1393d5cebe56f43a584ef47efbebd2702c upstream.

eliminate the duplicate the name of "VGA"

http://bugzilla.kernel.org/show_bug.cgi?id=12514

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/video.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1983,6 +1983,12 @@ static int acpi_video_bus_add(struct acp
 			device->pnp.bus_id[3] = '0' + instance;
 		instance ++;
 	}
+	/* a hack to fix the duplicate name "VGA" problem on Pa 3553 */
+	if (!strcmp(device->pnp.bus_id, "VGA")) {
+		if (instance)
+			device->pnp.bus_id[3] = '0' + instance;
+		instance++;
+	}
 
 	video->device = device;
 	strcpy(acpi_device_name(device), ACPI_VIDEO_BUS_NAME);

