Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbXELOEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbXELOEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 10:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756304AbXELOE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 10:04:27 -0400
Received: from n6.bullet.re3.yahoo.com ([68.142.237.91]:24911 "HELO
	n6.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754398AbXELOE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 10:04:26 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 316027.70310.bm@rrr3.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=H1ameGxymyMegxZJ71PrWuSQRYgSgd2cC3n9NJqOVpMwKts20VSjO9kO8b6KFyZHhu0jcXJp3ySTeCzeRaphFJVwY+BtEvzLR1G27k2dsRyy8kmOrWnuNXOorUZ8oXtLqzpwSM8QIXrzRt64wuWSgGFkisEa1x03gEaxYdC844E=;
X-YMail-OSG: RzHJiSEVM1lIfNnAbBn9_mrPe2ZhbRRRoBD2hlwHdeWJA0An73YZ36OeYxvGsTxyWAp9An52ij2hdCsam.AXunzjoJg.5AkEXINAu6mkOdKVKtQ7.VE7bNEsS6XLqeGE
Date: Sat, 12 May 2007 07:04:25 -0700 (PDT)
From: Tear <tarrqt@yahoo.com>
Subject: Dell Optiplex GX240, ACPI and APIC
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <229533.82694.qm@web63609.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Summary: If ACPI is not enabled but APIC is,
then there is trouble on Dell Optiplex GX240.
If both are enabled or if both are disabled, then
everything is fine. The attached patch removes
Dell Optiplex GX240 from the ACPI blacklist.

---

Hello,

I have a Dell Optiplex GX240 and when I boot Linux, ACPI
gets set up by only acpi=ht. dmesg shows the following line:

   DELL GX240 detected: force use of acpi=ht

Everything seemed to be fine. However, I discovered that
everything is not fine. The USB controller works so slowly
that copying a few (uncached) 1 megabyte large photos from
a USB-enabled digital camera takes many minutes instead of
a couple of seconds.

I am using Linux 2.6.21.1 on a Debian 4.0 ("Etch") system.

I thought that this might be related to ACPI. So I tried
to boot with _only_ "acpi=force" appended to the kernel
command line. Voila, the USB controller started to work
at full speed and copying photos from my digital camera
took only seconds.

I tested the system with "acpi=force" and could not find
anything which did not work. So, can we please remove
Dell Optiplex GX240 from the blacklist in

..../arch/i386/kernel/acpi/boot.c

? The attached patch does just that: It removes Dell
Optiplex GX240 from the ACPI blacklist.

I thought that this might be related to interrupts and
APIC as well. (Note that this is APIC, not ACPI.) I tried
booting with _only_ "noapic" and "nolapic" appended to the
command line. Again, the USB controller started to work
at full speed.

If removing Dell Optiplex GX240 from the ACPI blacklist
is not wanted/possible, then is there a way to disable
APIC and LAPIC (note that this is APIC not ACPI) by
default on Dell GX240 machines? (I.e. Can one patch
the kernel so that APIC and LAPIC isn't used on
these machines? - I know that I can use the noapic
and nolapic options on the kernel command line.)

Thank you for your attention.

- Tear

Note: Please include me in CC of your replies.


--- linux-2.6.21.1.orig/arch/i386/kernel/acpi/boot.c	2007-05-01 17:10:30.000000000 +0300
+++ linux-2.6.21.1/arch/i386/kernel/acpi/boot.c	2007-05-01 20:31:53.000000000 +0300
@@ -971,14 +971,6 @@
 	 },
 	{
 	 .callback = force_acpi_ht,
-	 .ident = "DELL GX240",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "Dell Computer Corporation"),
-		     DMI_MATCH(DMI_BOARD_NAME, "OptiPlex GX240"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
 	 .ident = "HP VISUALIZE NT Workstation",
 	 .matches = {
 		     DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),





       
____________________________________________________________________________________Get the free Yahoo! toolbar and rest assured with the added security of spyware protection.
http://new.toolbar.yahoo.com/toolbar/features/norton/index.php

