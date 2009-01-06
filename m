Return-Path: <linux-kernel-owner+w=401wt.eu-S1761197AbZAFWft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761197AbZAFWft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbZAFWO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:27 -0500
Received: from kroah.org ([198.145.64.141]:51330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755573AbZAFWOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:19 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 60/60] uio: make uio_info's name and version const
Date: Tue,  6 Jan 2009 14:12:19 -0800
Message-Id: <1231279939-32728-60-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

These are only ever assigned constant strings and never modified.

This was noticed because Wolfram Sang needed to cast the result of
of_get_property() in order to assign it to the name field of a struct
uio_info.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/DocBook/uio-howto.tmpl |    4 ++--
 include/linux/uio_driver.h           |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index 6116b93..b787e47 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -393,12 +393,12 @@ offset = N * getpagesize();
 
 <itemizedlist>
 <listitem><para>
-<varname>char *name</varname>: Required. The name of your driver as
+<varname>const char *name</varname>: Required. The name of your driver as
 it will appear in sysfs. I recommend using the name of your module for this.
 </para></listitem>
 
 <listitem><para>
-<varname>char *version</varname>: Required. This string appears in
+<varname>const char *version</varname>: Required. This string appears in
 <filename>/sys/class/uio/uioX/version</filename>.
 </para></listitem>
 
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 20be327..a0bb6bd 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -76,8 +76,8 @@ struct uio_device;
  */
 struct uio_info {
 	struct uio_device	*uio_dev;
-	char			*name;
-	char			*version;
+	const char		*name;
+	const char		*version;
 	struct uio_mem		mem[MAX_UIO_MAPS];
 	struct uio_port		port[MAX_UIO_PORT_REGIONS];
 	long			irq;
-- 
1.6.0.4

