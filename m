Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbYCKCId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbYCKCId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYCKCHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:07:46 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:21575 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756000AbYCKCHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:07:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iB0pP0DVxig8Kmj5PadN4M+Q2OVqhLfHEti1Gsae4zSryz+viT+J8ciLh8UJxHgvdOzOaECTf8Hw2L6/I+IOBoye1eINW8YmXpOk/3lTMaYd3oNRDIstyYpp+c2Lo74D/aBBTPOg/UbnKLRfm3q4RXvL2D8zpiX7papqVn2OGpE=  ;
X-YMail-OSG: IbeWlCEVM1mj_5ECmiehV9EvDfzMb.0s__4DjgEG2GhsClk6hrAI7vecUb7NaU1gNR98fb1LJA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.25-rc5] kerneldoc for <linux/clk.h>
Date: Mon, 10 Mar 2008 18:02:54 -0800
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803101902.54407.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add <linux/clk.h> to the generated kerneldoc, with some overview
to go along with those per-function descriptions.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 Documentation/DocBook/kernel-api.tmpl |   55 ++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

--- g26.orig/Documentation/DocBook/kernel-api.tmpl	2008-03-10 16:44:57.000000000 -0700
+++ g26/Documentation/DocBook/kernel-api.tmpl	2008-03-10 18:52:11.000000000 -0700
@@ -650,4 +650,59 @@ X!Idrivers/video/console/fonts.c
 !Edrivers/i2c/i2c-core.c
   </chapter>
 
+  <chapter id="clk">
+     <title>Clock Framework</title>
+
+     <para>
+	The clock framework defines programming interfaces to support
+	software management of the system clock tree.
+	This framework is widely used with System-On-Chip (SOC) platforms
+	to support power management and various devices which may need
+	custom clock rates.
+	Note that these "clocks" don't relate to timekeeping or real
+	time clocks (RTCs), each of which have separate frameworks.
+	These <structname>struct clk</structname> instances may be used
+	to manage for example a 96 MHz signal that is used to shift bits
+	into and out of peripherals or busses, or otherwise trigger
+	synchronous state machine transitions in system hardware.
+     </para>
+
+     <para>
+	Power management is supported by explicit software clock gating:
+	unused clocks are disabled, so the system doesn't waste power
+	changing the state of transistors that aren't in active use.
+	On some systems this may be backed by hardware clock gating.
+	Circuits will still have leakage current to be managed, which
+	costs more with finer cicuit geometries, but for CMOS circuits
+	power is mostly spent by clocked state changes.
+	Sections of chips that are powered but not clocked may be able
+	to retain their last state.
+	This low power state is often called a <emphasis>retention
+	mode</emphasis>, in contrast to <emphasis>off</emphasis> where
+	power is cut and no state is retained but where leakage currents
+	may have a significant impact on battery life.
+     </para>
+
+     <para>
+	Power-aware drivers only enable their clocks when the device
+	they manage is in active use.  Also, system sleep states often
+	differ according to which clock domains are active:  while a
+	"standby" state may allow wakeup from several active domains, a
+	"mem" (suspend-to-RAM) state may require a more wholesale shutdown
+	of clocks derived from higher speed PLLs and oscillators, limiting
+	the number of possible wakeup event sources.  A driver's suspend
+	method may need to be aware of system-specific clock constraints
+	on the target sleep state.
+     </para>
+
+     <para>
+        Some platforms support programmable clock generators.  These
+	can be used by external chips of various kinds, such as other
+	CPUs, multimedia codecs, and devices with strict requirements
+	for interface clocking.
+     </para>
+
+!Iinclude/linux/clk.h
+  </chapter>
+
 </book>
