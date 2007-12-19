Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbXLSBuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbXLSBuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXLSBt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:49:59 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:57293 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXLSBt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:49:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:message-id:mime-version:content-type;
        b=VeBtLc0+vdTBiYTXV2YB/CxP8Q6DI44prmjdDFMj19N5VRDEBqIlre004+x3jgKQIytnDJbVT+XxXCnSfUcY3qjVQEUz/CSR95UhIXvzWzfNrldLGj/9AE0DMXuCXrTfgLoSmWUobfaZ21WxTmmsvl712M2rOFBYliweVOvZo8I=
Date: Tue, 18 Dec 2007 20:49:47 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: netdev@vger.kernel.org, linux.nics@intel.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] e1000e: Use deferrable timer for watchdog
Message-ID: <Pine.LNX.4.64.0712182046560.3616@mini.warudkars.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reduce wakeups from idle per second.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6/drivers/net/e1000e/netdev.c	2007-12-07 10:04:39.000000000 -0500
+++ linux-2.6-work/drivers/net/e1000e/netdev.c	2007-12-18 20:45:59.000000000 -0500
@@ -3899,7 +3899,7 @@
  		goto err_eeprom;
  	}

-	init_timer(&adapter->watchdog_timer);
+	init_timer_deferrable(&adapter->watchdog_timer);
  	adapter->watchdog_timer.function = &e1000_watchdog;
  	adapter->watchdog_timer.data = (unsigned long) adapter;

