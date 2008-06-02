Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbYFBKrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbYFBKrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbYFBKrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:47:03 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:56822 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753095AbYFBKrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:47:02 -0400
Date: Mon, 2 Jun 2008 19:47:01 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10 of 12] xen: implement save/restore
Message-ID: <20080602104701.GB22955%yamahata@valinux.co.jp>
References: <patchbomb.1211550067@localhost> <9e8d06e5ae8024829836.1211550077@localhost> <20080602092144.GA22955%yamahata@valinux.co.jp> <4843C578.6060201@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4843C578.6060201@goop.org>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 11:03:36AM +0100, Jeremy Fitzhardinge wrote:
> Isaku Yamahata wrote:
> >What is the purpose of load_cr3() here?
> >I'd like to make this load_cr3() more arch generic for ia64 support.
> >(or eliminate it if possible)
> >  
> 
> I think it's an unnecessary left-over from when I was trying to get that 
> stuff to work.  I can't think of a good reason not to just remove it if 
> it causes you problems.

Here is the patch. I did only compile test.


> BTW, I tried to split the suspend/resume stuff into common and things 
> which were definitely x86-specific with you in mind.  How close did I get?

Almost complete. Your effort made my task easier.
I haven't yet succeeded to save/restore, though.

Is CONFIG_PM_SLEEP necessary?
Since ia64 doesn't define ARCH_HIBERNATION_POSSIBLE nor
ARCH_SUSPEND_POSSIBLE.
Although I can define them in ia64/xen/Kconfig, I'd like to leave
them untouched if possible.

>From 93906ae3785206cdd1e25e27b3797914f24f55aa Mon Sep 17 00:00:00 2001
From: Isaku Yamahata <yamahata@valinux.co.jp>
Date: Mon, 2 Jun 2008 19:36:20 +0900
Subject: [PATCH] xen: clean up of manage.c

remove load_cr3() from manage.c. It is unncessary and x86 dependent.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 drivers/xen/manage.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 675c3dd..28bb618 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -38,8 +38,6 @@ static int xen_suspend(void *data)
 
 	BUG_ON(!irqs_disabled());
 
-	load_cr3(swapper_pg_dir);
-
 	err = device_power_down(PMSG_SUSPEND);
 	if (err) {
 		printk(KERN_ERR "xen_suspend: device_power_down failed: %d\n",
-- 
1.5.3




-- 
yamahata
