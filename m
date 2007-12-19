Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbXLSBrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbXLSBrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbXLSBqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:46:55 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:21755 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbXLSBqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:46:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:message-id:mime-version:content-type;
        b=kKMzaSiMrEGOgR06Hrtyj7vRajnYl2rOJE0mR27vT1OUbovTRAZil3kXuhh7ulITgMVHBIKteMc0UMyeP4/GqgQP+ngnuq9Qn+2BK+mzBYHC6jg0cPeSBmJEE46ykfpWy9Q5BRY9kvU246ikXemi7Yy2m/shWXflm9mK78tO/fs=
Date: Tue, 18 Dec 2007 20:46:48 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: linux.nics@intel.com, netdev@vger.kernel.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] e1000: Use deferrable timer for watchdog
Message-ID: <Pine.LNX.4.64.0712182040470.3616@mini.warudkars.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use deferrable timer for watchdog. Reduces wakeups from idle per second.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6/drivers/net/e1000/e1000_main.c	2007-12-07 10:04:39.000000000 -0500
+++ linux-2.6-work/drivers/net/e1000/e1000_main.c	2007-12-18 20:38:38.000000000 -0500
@@ -1030,7 +1030,7 @@
  	adapter->tx_fifo_stall_timer.function = &e1000_82547_tx_fifo_stall;
  	adapter->tx_fifo_stall_timer.data = (unsigned long) adapter;

-	init_timer(&adapter->watchdog_timer);
+	init_timer_deferrable(&adapter->watchdog_timer);
  	adapter->watchdog_timer.function = &e1000_watchdog;
  	adapter->watchdog_timer.data = (unsigned long) adapter;

