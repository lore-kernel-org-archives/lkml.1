Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbXLSA4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbXLSA4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbXLSA4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:56:17 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:47879 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbXLSA4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:56:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:message-id:mime-version:content-type;
        b=R35f7WzcbDsImF6BJ1mkT/bG2jB+dQyq3wVSjoEAM6/sryp9JTxEMuJfFjW1t6lkOm21ZGBDc9byIbjbfX83iNdsNR+fBzjMtyWmCBPpjdESv+Yi1iS88ymiPS8enEQFBWp1En7iowu2AvSr0TCVuVrqr3EZva7QM54v6Lwjzkk=
Date: Tue, 18 Dec 2007 19:56:11 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       johnstul@us.ibm.com
Subject: [PATCH] clocksource.c: Use init_timer_deferrable for clocksource_watchdog
Message-ID: <Pine.LNX.4.64.0712181947250.3616@mini.warudkars.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


clocksource_watchdog can use a deferrable timer - reduces wakeups from 
idle per second.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6/kernel/time/clocksource.c	2007-12-07 10:04:43.000000000 -0500
+++ linux-2.6-work/kernel/time/clocksource.c	2007-12-13 12:49:14.000000000 -0500
@@ -175,7 +175,7 @@
  			if (watchdog)
  				del_timer(&watchdog_timer);
  			watchdog = cs;
-			init_timer(&watchdog_timer);
+			init_timer_deferrable(&watchdog_timer);
  			watchdog_timer.function = clocksource_watchdog;

  			/* Reset watchdog cycles */
