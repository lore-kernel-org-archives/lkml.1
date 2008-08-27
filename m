Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbYH0OWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbYH0OWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYH0OV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:21:56 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:32068 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753960AbYH0OVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:21:55 -0400
Date: Wed, 27 Aug 2008 10:21:36 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Jeff Garzik <jgarzik@redhat.com>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ETH] forcdeth: increase max_interrupt_work
Message-ID: <20080827142136.GA22262@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forcedeth: increase max_interrupt_work

This eliminates the following often-generated warning from
my 64 bit Opteron SMP test stand:

	eth0: too many iterations (6) in nv_nic_irq

According to the web, the problem is that the forcedeth
driver has a too-low value for max_interrupt_work.
Grepping the kernel I see that forcedeth has the second
lowest value of all ethernet drivers (ie, 6).  Most are
in the 20-40 range.  So this patch increases this a bit,
from 6 to 15 (at 15 forcedeth becomes the driver with
third-lowest max_interrupt_work value).

My test stand, which used to print out the above warnings
repetitively whenever it was under heavy net load, no
longer does so.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.27-rc4-git4/drivers/net/forcedeth.c
===================================================================
--- 2.6.27-rc4-git4.orig/drivers/net/forcedeth.c	2008-08-27 09:49:13.000000000 -0400
+++ 2.6.27-rc4-git4/drivers/net/forcedeth.c	2008-08-27 10:02:40.000000000 -0400
@@ -818,7 +818,7 @@
  * Maximum number of loops until we assume that a bit in the irq mask
  * is stuck. Overridable with module param.
  */
-static int max_interrupt_work = 5;
+static int max_interrupt_work = 15;
 
 /*
  * Optimization can be either throuput mode or cpu mode
