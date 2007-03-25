Return-Path: <linux-kernel-owner+w=401wt.eu-S1751458AbXCYPaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbXCYPaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 11:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbXCYPaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 11:30:06 -0400
Received: from smtpout08-04.prod.mesa1.secureserver.net ([64.202.165.12]:52977
	"HELO smtpout08.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751458AbXCYPaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 11:30:05 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Mar 2007 11:30:04 EDT
Message-ID: <460693EB.9080203@kpfleming.us>
Date: Sun, 25 Mar 2007 08:23:23 -0700
From: "Kevin P. Fleming" <lkml@kpfleming.us>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: drivers/pci/probe.c patch in 2.6.20.4 causes 'cannot adjust BAR0
 (not I/O)' on NVidia MCP51
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just upgraded from 2.6.20.2 to 2.6.20.4 on my Compaq V6000 laptop,
which has an NVidia core chipset. It has the MCP51 and uses it for PATA
and SATA.

Booting the 2.6.20.4 kernel causes two messages (and a kernel lockup)
like this:

0000:00:0d.0: cannot adjust BAR0 (not I/O)
0000:00:0d.0: cannot adjust BAR1 (not I/O)

Booting without ACPI, without APIC, without LAPIC makes no usable
difference (although sometimes I will also receive a message about BAR2).

This patch:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ed8ccee0918ad063a4741c0656fda783e02df627;hp=9e5755bce00bb563739aeb0f09932a1907521167

is the cause... backing it out results in a working 2.6.20.4 kernel on
my laptop.

I'll be happy to provide any assistance I can debugging this problem.
Thanks.
