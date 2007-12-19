Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbXLSBEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbXLSBEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbXLSBEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:04:30 -0500
Received: from hs-out-0708.google.com ([64.233.178.242]:64509 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752654AbXLSBE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:04:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:message-id:mime-version:content-type;
        b=NqZwb94hR2jdu1Fg4btHehLS3gUTx9VNpttYZZufXEuS3VAk+A0EzfdHvX1I01xH8uNrKH1Lo3aLnVGuzb6Ct4Gjsko9b67Fh4eO63eGhz3dGlsNU1kB7hvB4UzqujHuUlhZWjpvUAtmk/AUVk/GvSGpAeXUztzug0UNuL7BDHY=
Date: Tue, 18 Dec 2007 20:04:23 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: netdev@vger.kernel.org
cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] sch_generic.c: Make dev_watchdog use deferrable timer
Message-ID: <Pine.LNX.4.64.0712181956180.3616@mini.warudkars.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reduces the number of wakeups from idle per second, makes powertop happy.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6/net/sched/sch_generic.c	2007-12-07 10:04:43.000000000 -0500
+++ linux-2.6-work/net/sched/sch_generic.c	2007-12-16 17:57:05.000000000 -0500
@@ -213,7 +213,7 @@

  static void dev_watchdog_init(struct net_device *dev)
  {
-	init_timer(&dev->watchdog_timer);
+	init_timer_deferrable(&dev->watchdog_timer);
  	dev->watchdog_timer.data = (unsigned long)dev;
  	dev->watchdog_timer.function = dev_watchdog;
  }
