Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbXLSBNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbXLSBNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbXLSBNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:13:33 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:7352 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbXLSBNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:13:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:message-id:mime-version:content-type;
        b=d+PvMphdLeC/tl6P5VJU/6UGoBsvJvmf7u1FEF9Y/kZQivKZlsXjzbSDSllEayHKR6wqN9Vj/1xkJ25W5OOAkGD3MRGR2Oi70ZhQba5YOpU4pK48sz+O0KvrigLTH6IqPEygTEA2VjeSpQfT/0rKZ+cewTXqXZW6KP7sWF8iX9A=
Date: Tue, 18 Dec 2007 20:13:28 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: netdev@vger.kernel.org
cc: shemminger@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sky2: Use deferrable timer for watchdog
Message-ID: <Pine.LNX.4.64.0712182008160.3616@mini.warudkars.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sky2 can use deferrable timer for watchdog - reduces wakeups from idle per 
second.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6/drivers/net/sky2.c	2007-12-07 10:04:39.000000000 -0500
+++ linux-2.6-work/drivers/net/sky2.c	2007-12-18 20:07:58.000000000 -0500
@@ -4230,7 +4230,10 @@
  			sky2_show_addr(dev1);
  	}

-	setup_timer(&hw->watchdog_timer, sky2_watchdog, (unsigned long) hw);
+	hw->watchdog_timer.function = sky2_watchdog;
+	hw->watchdog_timer.data = (unsigned long) hw;
+	init_timer_deferrable(&hw->watchdog_timer);
+
  	INIT_WORK(&hw->restart_work, sky2_restart);

  	pci_set_drvdata(pdev, hw);
