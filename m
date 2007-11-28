Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbXK1Wx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbXK1Wx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761293AbXK1Wxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:53:30 -0500
Received: from mx1.suse.de ([195.135.220.2]:57394 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761573AbXK1Wx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:53:27 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Hans J Koch <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/6] UIO: fix up the UIO documentation
Date: Wed, 28 Nov 2007 14:52:17 -0800
Message-Id: <1196290340-28828-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071128224746.GA28410@kroah.com>
References: <20071128224746.GA28410@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J Koch <hjk@linutronix.de>

Remove references to the old uio_dummy demo module from UIO documentation.
Add a small paragraph to make it clearer that UIO is not a universal driver
interface.

Signed-off-by: Hans J Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/DocBook/uio-howto.tmpl |   90 ++++++++++++----------------------
 1 files changed, 32 insertions(+), 58 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index c119484..fdd7f4f 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -30,6 +30,12 @@
 
 <revhistory>
 	<revision>
+	<revnumber>0.4</revnumber>
+	<date>2007-11-26</date>
+	<authorinitials>hjk</authorinitials>
+	<revremark>Removed section about uio_dummy.</revremark>
+	</revision>
+	<revision>
 	<revnumber>0.3</revnumber>
 	<date>2007-04-29</date>
 	<authorinitials>hjk</authorinitials>
@@ -94,6 +100,26 @@ interested in translating it, please email me
 	user space. This simplifies development and reduces the risk of
 	serious bugs within a kernel module.
 	</para>
+	<para>
+	Please note that UIO is not an universal driver interface. Devices
+	that are already handled well by other kernel subsystems (like
+	networking or serial or USB) are no candidates for an UIO driver.
+	Hardware that is ideally suited for an UIO driver fulfills all of
+	the following:
+	</para>
+<itemizedlist>
+<listitem>
+	<para>The device has memory that can be mapped. The device can be
+	controlled completely by writing to this memory.</para>
+</listitem>
+<listitem>
+	<para>The device usually generates interrupts.</para>
+</listitem>
+<listitem>
+	<para>The device does not fit into one of the standard kernel
+	subsystems.</para>
+</listitem>
+</itemizedlist>
 </sect1>
 
 <sect1 id="thanks">
@@ -174,8 +200,9 @@ interested in translating it, please email me
 	For cards that don't generate interrupts but need to be
 	polled, there is the possibility to set up a timer that
 	triggers the interrupt handler at configurable time intervals.
-	See <filename>drivers/uio/uio_dummy.c</filename> for an
-	example of this technique.
+	This interrupt simulation is done by calling
+	<function>uio_event_notify()</function>
+	from the timer's event handler.
 	</para>
 
 	<para>
@@ -263,63 +290,11 @@ offset = N * getpagesize();
 </sect1>
 </chapter>
 
-<chapter id="using-uio_dummy" xreflabel="Using uio_dummy">
-<?dbhtml filename="using-uio_dummy.html"?>
-<title>Using uio_dummy</title>
-	<para>
-	Well, there is no real use for uio_dummy. Its only purpose is
-	to test most parts of the UIO system (everything except
-	hardware interrupts), and to serve as an example for the
-	kernel module that you will have to write yourself.
-	</para>
-
-<sect1 id="what_uio_dummy_does">
-<title>What uio_dummy does</title>
-	<para>
-	The kernel module <filename>uio_dummy.ko</filename> creates a
-	device that uses a timer to generate periodic interrupts. The
-	interrupt handler does nothing but increment a counter. The
-	driver adds two custom attributes, <varname>count</varname>
-	and <varname>freq</varname>, that appear under
-	<filename>/sys/devices/platform/uio_dummy/</filename>.
-	</para>
-
-	<para>
-	The attribute <varname>count</varname> can be read and
-	written.  The associated file
-	<filename>/sys/devices/platform/uio_dummy/count</filename>
-	appears as a normal text file and contains the total number of
-	timer interrupts. If you look at it (e.g. using
-	<function>cat</function>), you'll notice it is slowly counting
-	up.
-	</para>
-
-	<para>
-	The attribute <varname>freq</varname> can be read and written.
-	The content of
-	<filename>/sys/devices/platform/uio_dummy/freq</filename>
-	represents the number of system timer ticks between two timer
-	interrupts. The default value of <varname>freq</varname> is
-	the value of the kernel variable <varname>HZ</varname>, which
-	gives you an interval of one second. Lower values will
-	increase the frequency. Try the following:
-	</para>
-<programlisting format="linespecific">
-cd /sys/devices/platform/uio_dummy/
-echo 100 > freq
-</programlisting>
-	<para>
-	Use <function>cat count</function> to see how the interrupt
-	frequency changes.
-	</para>
-</sect1>
-</chapter>
-
 <chapter id="custom_kernel_module" xreflabel="Writing your own kernel module">
 <?dbhtml filename="custom_kernel_module.html"?>
 <title>Writing your own kernel module</title>
 	<para>
-	Please have a look at <filename>uio_dummy.c</filename> as an
+	Please have a look at <filename>uio_cif.c</filename> as an
 	example. The following paragraphs explain the different
 	sections of this file.
 	</para>
@@ -354,9 +329,8 @@ See the description below for details.
 interrupt, it's your modules task to determine the irq number during
 initialization. If you don't have a hardware generated interrupt but
 want to trigger the interrupt handler in some other way, set
-<varname>irq</varname> to <varname>UIO_IRQ_CUSTOM</varname>. The
-uio_dummy module does this as it triggers the event mechanism in a timer
-routine. If you had no interrupt at all, you could set
+<varname>irq</varname> to <varname>UIO_IRQ_CUSTOM</varname>.
+If you had no interrupt at all, you could set
 <varname>irq</varname> to <varname>UIO_IRQ_NONE</varname>, though this
 rarely makes sense.
 </para></listitem>
-- 
1.5.3.4

