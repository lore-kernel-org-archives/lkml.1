Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbZBRVru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbZBRVru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbZBRVga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:36:30 -0500
Received: from kroah.org ([198.145.64.141]:56473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754259AbZBRVgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:36:05 -0500
Date: Wed, 18 Feb 2009 13:33:28 -0800
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
       alan@lxorguk.ukuu.org.uk, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [patch 39/39] Fix longstanding "error: storage size of
	__mod_dmi_device_table isnt known"
Message-ID: <20090218213328.GN19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-longstanding-error-storage-size-of-__mod_dmi_device_table-isn-t-known.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit 40413dcb7b273bda681dca38e6ff0bbb3728ef11 upstream.

gcc 3.4.6 doesn't like MODULE_DEVICE_TABLE(dmi, x) expansion enough to
error out.  Shut it up in a most simple way.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/mod_devicetable.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -443,6 +443,13 @@ struct dmi_system_id {
 	struct dmi_strmatch matches[4];
 	void *driver_data;
 };
+/*
+ * struct dmi_device_id appears during expansion of
+ * "MODULE_DEVICE_TABLE(dmi, x)". Compiler doesn't look inside it
+ * but this is enough for gcc 3.4.6 to error out:
+ *	error: storage size of '__mod_dmi_device_table' isn't known
+ */
+#define dmi_device_id dmi_system_id
 #endif
 
 #define DMI_MATCH(a, b)	{ a, b }

