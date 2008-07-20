Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYGTXbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYGTXbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 19:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbYGTXbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 19:31:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:41560 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYGTXbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 19:31:32 -0400
Date: Sun, 20 Jul 2008 16:31:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>, Daniel Walker <dwalker@mvista.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 3/4] fastboot: make the raid autodetect code wait for
 all devices to init
Message-ID: <20080720163126.64b39d50@infradead.org>
In-Reply-To: <18563.50428.659101.868745@notabene.brown>
References: <20080720151140.4aa7c682@infradead.org>
	<20080720151339.6f4a83d8@infradead.org>
	<18563.50428.659101.868745@notabene.brown>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 09:06:36 +1000
Neil Brown <neilb@suse.de> wrote:

>     if (driver_probe_done() != 0) {
> 	printk("md: Waiting for all devices to be available before
> autodetect\n" "md:  If you don't boot off raid, use
> raid=noautodetect\n"); do


how about this patch?

From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 20 Jul 2008 16:30:29 -0700
Subject: [PATCH] fastboot: make the RAID autostart code print a message just before waiting

As requested/suggested by Neil Brown: make the raid code print that it's
about to wait for probing to be done as well as give a suggestion on how
to disable the probing if the user doesn't use raid.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com
---
 init/do_mounts_md.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index c0412a9..2ab122a 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -275,7 +275,9 @@ void __init md_run_setup(void)
 		 * Since we don't want to detect and use half a raid array, we need to
 		 * wait for the known devices to complete their probing
 		 */
-		while (driver_probe_done() != 0)
+		printk(KERN_INFO "md: Waiting for all devices to be available before autodetect\n");
+		printk(KERN_INFO "md: If you don't use raid, use raid=noautodetect\n");
+		while (driver_probe_done())
 			msleep(100);
 		int fd = sys_open("/dev/md0", 0, 0);
 		if (fd >= 0) {
-- 
1.5.5.1

