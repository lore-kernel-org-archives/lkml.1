Return-Path: <linux-kernel-owner+w=401wt.eu-S1761252AbYBEXfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252AbYBEXfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763389AbYBEXen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:34:43 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:43588 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763372AbYBEXek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:34:40 -0500
Message-ID: <47A8F28E.6000102@web.de>
Date: Wed, 06 Feb 2008 00:34:38 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/3] KGDB: Update documentation
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V01U2FsdGVkX1/sDxrfkyTbxwXz4GvGsUy2/4bFzxHwom7AZuVG
	To4WVNURvPFepuctgCAvGatg2p/TAHEXgDrzdrxpQb3nZie1tq
	MMwpVsZHM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align KGDB's DocBook chapters with all previous changes. To avoid
confusion, it removes references to the not-yet-merged KGDBOE driver.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 Documentation/DocBook/kgdb.tmpl |  132 ++++++++++++++++------------------------
 1 file changed, 55 insertions(+), 77 deletions(-)

Index: b/Documentation/DocBook/kgdb.tmpl
===================================================================
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -77,23 +77,16 @@
     and then select "KGDB: kernel debugging with remote gdb".
     </para>
     <para>
-    The first choice for I/O is <symbol>CONFIG_KGDB_ONLY_MODULES</symbol>.
-    This means that you will only be able to use KGDB after loading a
-    kernel module that defines how you want to be able to talk with
-    KGDB.  There are two other choices (more on some architectures) that
-    can be enabled as modules later, if not picked here.
-    </para>
-    <para>The first of these is <symbol>CONFIG_KGDB_8250_NOMODULE</symbol>.
-    This has sub-options such as <symbol>CONFIG_KGDB_SIMPLE_SERIAL</symbol>
-    which toggles choosing the serial port by ttyS number or by specifying
-    a port and IRQ number.
-    </para>
-    <para>
-    The second of these choices on most systems for I/O is
-    <symbol>CONFIG_KGDBOE</symbol>. This requires that the machine to be
-    debugged has an ethernet card which supports the netpoll API, such as
-    the cards supported by <symbol>CONFIG_E100</symbol>.  There are no
-    sub-options for this, but a kernel command line option is required.
+    Next you should choose one of more I/O drivers to interconnect debugging
+    host and debugged target.  If debugging early boot steps is required,
+    at least one driver has to be built in.  I/O driver configuration takes
+    place via kernel or module parameters, see following chapter.
+    </para>
+    <para>
+    While KGDB is connect with the host, it can dump console messages over
+    this link.  This is specifically useful for collecting critical kernel
+    messages while only a single serial port is available.  Enable
+    <symbol>CONFIG_KGDB_CONSOLE</symbol> to activate this feature.
     </para>
   </chapter>
   <chapter id="BootingTheKernel">
@@ -103,54 +96,60 @@
     wait for gdb connection during booting of a kernel.  If the
     <symbol>CONFIG_KGDB_8250</symbol> driver is used (or if applicable,
     another serial driver) this breakpoint will happen very early on, before
-    console output.  If you wish to change serial port information and you
-    have enabled both <symbol>CONFIG_KGDB_8250</symbol> and
-    <symbol>CONFIG_KGDB_SIMPLE_SERIAL</symbol> then you must pass the option
-    <constant>kgdb8250=&lt;io or mmio&gt;,&lt;address&gt;,&lt;baud
-    rate&gt;,&lt;irq&gt;</constant> before <constant>kgdbwait</constant>.
-    The values <constant>io</constant> or <constant>mmio</constant> refer to
-    if the address being passed next needs to be memory mapped
-    (<constant>mmio</constant>) or not. The <constant>address</constant> must
-    be passed in hex and is the hardware address and will be remapped if
-    passed as <constant>mmio</constant>. The value
-    <constant>baud rate</constant> and <constant>irq</constant> are base-10.
-    The supported values for <constant>baud rate</constant> are
-    <constant>9600</constant>, <constant>19200</constant>,
-    <constant>38400</constant>, <constant>57600</constant>, and
-    <constant>115200</constant>.
+    console output.
     </para>
     <para>
-    To have KGDB stop the kernel and wait, with the compiled values for the
-    serial driver, pass in: <constant>kgdbwait</constant>.
+    The serial port configuration must be passed via the
+    option <constant>kgdb8250=&lt;io|mmio&gt;,&lt;address&gt;[/&lt;regshift&gt;],&lt;baud
+    rate&gt;,&lt;irq&gt;</constant>.  The values <constant>io</constant> or
+    <constant>mmio</constant> refer to if the address being passed next needs
+    to be memory mapped (<constant>mmio</constant>) or not.  The
+    <constant>address</constant> must be passed in hex and is the hardware
+    address and will be remapped if passed as <constant>mmio</constant>. An
+    optional <constant>regshift</constant> value can be given to express
+    address spreading of the 8250 registers. <constant>regshift</constant>
+    just as the succeeding <constant>baud rate</constant> and
+    <constant>irq</constant> values are base-10. The supported values for
+    <constant>baud rate</constant> are <constant>9600</constant>,
+    <constant>19200</constant>, <constant>38400</constant>,
+    <constant>57600</constant>, and <constant>115200</constant>.
     </para>
     <para>
     To specify the values of the serial port at boot:
-    <constant>kgdb8250=io,3f8,115200,3</constant>.
+    </para>
+    <para>
+    <constant>kgdb8250=io,3f8,115200,3</constant>
+    </para>
+    <para>
     On IA64 this could also be:
+    </para>
+    <para>
     <constant>kgdb8250=mmio,0xff5e0000,115200,74</constant>
-    And to have KGDB also stop the kernel and wait for GDB to connect, pass in
-    <constant>kgdbwait</constant> after this arguement.
     </para>
     <para>
-    To configure the <symbol>CONFIG_KGDBOE</symbol> driver, pass in
-    <constant>kgdboe=[src-port]@&lt;src-ip&gt;/[dev],[tgt-port]@&lt;tgt-ip&gt;/[tgt-macaddr]</constant>
-    where:
-    <itemizedlist>
-      <listitem><para>src-port (optional): source for UDP packets (defaults to <constant>6443</constant>)</para></listitem>
-      <listitem><para>src-ip: source IP to use (interface address)</para></listitem>
-      <listitem><para>dev (optional): network interface (<constant>eth0</constant>)</para></listitem>
-      <listitem><para>tgt-port (optional): port GDB will use (defaults to <constant>6442</constant>)</para></listitem>
-      <listitem><para>tgt-ip: IP address GDB will be connecting from</para></listitem>
-      <listitem><para>tgt-macaddr (optional): ethernet MAC address for logging agent (default is broadcast)</para></listitem>
-    </itemizedlist>
-    </para>
-    <para>
-    The <symbol>CONFIG_KGDBOE</symbol> driver can be reconfigured at run time,
-    if <symbol>CONFIG_SYSFS</symbol> and <symbol>CONFIG_MODULES</symbol>
-    are enabled, by echo'ing a new config string to
-    <constant>/sys/module/kgdboe/parameter/kgdboe</constant>.  The
-    driver can be unconfigured with the special string
-    <constant>not_configured</constant>.
+    If the debugger is not needed early, the alternative configuration format
+    <constant>kgdb8250=ttyS&lt;n&gt;,&lt;baud rate&gt;</constant> can be used.
+    The required parameters are then obtained from the standard 8250 driver.
+    Example:
+    </para>
+    <para>
+    <constant>kgdb8250=ttyS0,115200</constant>
+    </para>
+    <para>
+    To configure the <symbol>CONFIG_KGDBOC</symbol> driver, just pass in
+    <constant>kgdboc=&lt;tty-device&gt;</constant>.  It will try to connect
+    to gdb over the given serial console.  Note that KGDBOC does not support
+    interrupting the target via the gdb remote protocol.  Instead you will
+    need to issue sysrq-g via the console or locally on the target.
+    </para>
+    <para>
+    All drivers can be reconfigured at run time, if
+    <symbol>CONFIG_SYSFS</symbol> and <symbol>CONFIG_MODULES</symbol> are
+    enabled, by echo'ing a new config string to
+    <constant>/sys/module/&lt;driver&gt;/parameter/&lt;option&gt;</constant>.
+    The driver can be unconfigured by passing an empty string.  You cannot
+    change the configuration while the debugger is attached.  In that case
+    issue the required <constant>detach</constant> command via gdb first.
     </para>
   </chapter>
   <chapter id="ConnectingGDB">
@@ -212,25 +211,4 @@
       </para>
 !Iinclude/linux/kgdb.h
   </chapter>
-  <chapter id="CommonBackEndOpt">
-    <title>The common backend (optional)</title>
-      <para>
-      These functions are part of the common backend, found in kernel/kgdb.c
-      and are optionally implemented.  Some functions (with _hw_ in the name)
-      end up being required on arches which use hardware breakpoints.
-      </para>
-<!--
-X!Ikernel/kgdb.c
--->
-  </chapter>
-  <chapter id="DriverSpecificFunctions">
-    <title>Driver-Specific Functions</title>
-      <para>
-      Some of the I/O drivers have additional functions that can be
-      called, that are specific to the driver.  Calls from other places
-      to these functions must be wrapped in #ifdefs for the driver in
-      question.
-      </para>
-!Idrivers/serial/8250_kgdb.c
-   </chapter>
 </book>
