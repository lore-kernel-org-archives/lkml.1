Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYJFQd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYJFQd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 12:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYJFQdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 12:33:21 -0400
Received: from xenotime.net ([66.160.160.81]:36355 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752842AbYJFQdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:33:20 -0400
Date: Mon, 6 Oct 2008 09:33:08 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: George Nychis <gnychis@cmu.edu>
cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: [patch] Re: how to link to hrtimers in the kernel
In-Reply-To: <48EA31A4.6080903@cmu.edu>
Message-ID: <Pine.LNX.4.64.0810060931140.4121@shark.he.net>
References: <48EA31A4.6080903@cmu.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008, George Nychis wrote:

> Hi all,
> 
> I have modified drivers/usb/core/devio.c to use hrtimer_nanosleep(), and have
> included linux/hrtimer.h with it.
> 
> But now I am having trouble linking, I get:
> ERROR: "hrtimer_nanosleep" [drivers/usb/core/usbcore.ko] undefined!
> 
> How do I properly link to the hrtimer library?

Hi,
That function needs to be exported in its source file.
Patch below should fix it for you.



From: Randy Dunlap <randy.dunlap@oracle.com>

Export hrtimer_nanosleep() for module use.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/hrtimer.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.27-rc8-git5.orig/kernel/hrtimer.c
+++ linux-2.6.27-rc8-git5/kernel/hrtimer.c
@@ -1559,6 +1559,7 @@ out:
 	destroy_hrtimer_on_stack(&t.timer);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(hrtimer_nanosleep);
 
 asmlinkage long
 sys_nanosleep(struct timespec __user *rqtp, struct timespec __user *rmtp)
