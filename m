Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbXEOAb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbXEOAb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 20:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXEOAbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 20:31:51 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17605 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbXEOAbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 20:31:50 -0400
Date: Mon, 14 May 2007 17:35:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, ak@suse.de, rusty@rustcorp.com.au
Subject: [PATCH] docbook: make kernel-locking table readable
Message-Id: <20070514173540.6c5bb806.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Andi Kleen pointed out to me that the kernel locking cheat sheet
table entries are unreadable.

Make table entries smaller so that pdf and ps output is readable
(columns were being overwritten and garbled) by using abbreviations.
This allows the tables to fit on one page cleanly.
Add a Legend for the abbreviations:
  SLIS: spin_lock_irqsave
  SLI:  spin_lock_irq
  SL:   spin_lock
  SLBH: spin_lock_bh
  DI:   down_interruptible

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-locking.tmpl |  123 +++++++++++++++++++-----------
 1 file changed, 78 insertions(+), 45 deletions(-)

--- linux-2.6.22-rc1.orig/Documentation/DocBook/kernel-locking.tmpl
+++ linux-2.6.22-rc1/Documentation/DocBook/kernel-locking.tmpl
@@ -551,10 +551,12 @@
 	<function>spin_lock_irqsave()</function>, which is a superset
 	of all other spinlock primitives.
    </para>
+
    <table>
 <title>Table of Locking Requirements</title>
 <tgroup cols="11">
 <tbody>
+
 <row>
 <entry></entry>
 <entry>IRQ Handler A</entry>
@@ -576,97 +578,128 @@
 
 <row>
 <entry>IRQ Handler B</entry>
-<entry>spin_lock_irqsave</entry>
+<entry>SLIS</entry>
 <entry>None</entry>
 </row>
 
 <row>
 <entry>Softirq A</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SL</entry>
 </row>
 
 <row>
 <entry>Softirq B</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SL</entry>
+<entry>SL</entry>
 </row>
 
 <row>
 <entry>Tasklet A</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SL</entry>
+<entry>SL</entry>
 <entry>None</entry>
 </row>
 
 <row>
 <entry>Tasklet B</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SL</entry>
+<entry>SL</entry>
+<entry>SL</entry>
 <entry>None</entry>
 </row>
 
 <row>
 <entry>Timer A</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SL</entry>
+<entry>SL</entry>
+<entry>SL</entry>
+<entry>SL</entry>
 <entry>None</entry>
 </row>
 
 <row>
 <entry>Timer B</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SL</entry>
+<entry>SL</entry>
+<entry>SL</entry>
+<entry>SL</entry>
+<entry>SL</entry>
 <entry>None</entry>
 </row>
 
 <row>
 <entry>User Context A</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
 <entry>None</entry>
 </row>
 
 <row>
 <entry>User Context B</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>DI</entry>
+<entry>None</entry>
+</row>
+
+</tbody>
+</tgroup>
+</table>
+
+   <table>
+<title>Legend for Locking Requirements Table</title>
+<tgroup cols="2">
+<tbody>
+
+<row>
+<entry>SLIS</entry>
+<entry>spin_lock_irqsave</entry>
+</row>
+<row>
+<entry>SLI</entry>
 <entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
+</row>
+<row>
+<entry>SL</entry>
+<entry>spin_lock</entry>
+</row>
+<row>
+<entry>SLBH</entry>
 <entry>spin_lock_bh</entry>
+</row>
+<row>
+<entry>DI</entry>
 <entry>down_interruptible</entry>
-<entry>None</entry>
 </row>
 
 </tbody>
 </tgroup>
 </table>
+
 </sect1>
 </chapter>
 
