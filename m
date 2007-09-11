Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbXIKHqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbXIKHqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 03:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758326AbXIKHqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 03:46:11 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:54721 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758319AbXIKHqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 03:46:10 -0400
Date: Tue, 11 Sep 2007 17:46:08 +1000
To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       LinuxPPC-dev <linuxppc-dev@ozlabs.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, Gabriel Paubert <paubert@iram.es>,
       zach@vmware.com, Thomas Gleixner <tglx@linutronix.de>,
       John Stultz <johnstul@us.ibm.com>
Subject: Fix "no_sync_cmos_clock"  logic inversion in kernel/time/ntp.c
Message-ID: <20070911074608.GD9814@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

---

Seems to me that this timer will only get started on platforms that say
they don't want it?

 kernel/time/ntp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: working/kernel/time/ntp.c
===================================================================
--- working.orig/kernel/time/ntp.c	2007-09-11 17:34:44.000000000 +1000
+++ working/kernel/time/ntp.c	2007-09-11 17:34:55.000000000 +1000
@@ -226,7 +226,7 @@ static void sync_cmos_clock(unsigned lon
 
 static void notify_cmos_timer(void)
 {
-	if (no_sync_cmos_clock)
+	if (!no_sync_cmos_clock)
 		mod_timer(&sync_cmos_timer, jiffies + 1);
 }
 

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

