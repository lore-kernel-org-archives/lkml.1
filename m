Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbZGFVlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbZGFVlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZGFVlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:41:05 -0400
Received: from mx10.go2.pl ([193.17.41.74]:51875 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752194AbZGFVlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:41:04 -0400
From: Zbigniew Luszpinski <zbiggy@o2.pl>
To: linux-usb@vger.kernel.org
Subject: PROBLEM: Nvidia OHCI chipset MCP78S (Geforce 8200) hangs on > 1Mbit transfers if noapic/acpi=noirq is missing
Date: Mon, 6 Jul 2009 23:40:56 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <200907060122.26312.zbiggy@o2.pl> <200907060211.43377.zbiggy@o2.pl>
In-Reply-To: <200907060211.43377.zbiggy@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907062340.56308.zbiggy@o2.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

with my ohci usb controller problem I came to conclusion that it hangs only 
during big transfers when ohci usb controller is unable to keep up with rest 
of the system. That is why it only hangs on fast bulk/iso transfers and not 
when slow usb keyboard or mouse is used.

After being inspired by this uhci usb bugfix (which is very similar to my 
problem but in my case Nvidia does not provide any driver for windows usb. 
Just use default windows one):
http://osdir.com/ml/linux.usb.user/2002-12/msg00112.html
So I modified ohci usb driver source code (ohci-q.c, ohci-hub.c) in similar 
way by adding mdelay(5); before most of ohci_writel(...) and ohci_readl(...). 
After recompilation and reboot I used ohci usb without noapic workaround for 
much longer time without hanging. However after this modification usb hangs
immediately after hotpluging other usb device so my ugly hack did not fix all
the issues. :(

I hope I find here someone who wrote or know Linux ohci driver so he/she knows 
how to slow down ohci bulk/iso IO operations without breaking hotplug.
It looks Linux ohci driver is more aggressive on ohci IO than windows one so 
making Linux less timing demanding would help my MCP78S keep working.

have a nice day,
Zbigniew Luszpinski

