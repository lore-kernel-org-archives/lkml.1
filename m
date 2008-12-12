Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbYLLFaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbYLLFaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 00:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYLLFar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 00:30:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33073 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbYLLFaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 00:30:46 -0500
Date: Fri, 12 Dec 2008 16:30:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH] uio: make uio_info's name and version const
Message-Id: <20081212163041.7bc16261.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are only ever assigned constant strings and never modified.

This was noticed because Wolfram Sang needed to cast the result of
of_get_property() in order to assign it to the name field of a struct
uio_info.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 Documentation/DocBook/uio-howto.tmpl |    4 ++--
 include/linux/uio_driver.h           |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Tested by compiling all the uio drivers available on x86.  The others
(all in arch sh) only ever assign constant string literals to these
fields.

[Resent with properly quoted recipient addresses]

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index df87d1b..21ba47e 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -339,12 +339,12 @@ offset = N * getpagesize();
 
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
index cdf338d..b5f23b1 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -57,8 +57,8 @@ struct uio_device;
  */
 struct uio_info {
 	struct uio_device	*uio_dev;
-	char			*name;
-	char			*version;
+	const char		*name;
+	const char		*version;
 	struct uio_mem		mem[MAX_UIO_MAPS];
 	long			irq;
 	unsigned long		irq_flags;
-- 
1.6.0.5

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
