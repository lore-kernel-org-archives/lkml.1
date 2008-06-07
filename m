Return-Path: <linux-kernel-owner+w=401wt.eu-S1763691AbYFGR50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763691AbYFGR50 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 13:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761122AbYFGR5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 13:57:17 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:31191 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761423AbYFGR5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 13:57:16 -0400
Date: Sat, 7 Jun 2008 21:57:14 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: galak@kernel.crashing.org, wim@iguana.be, jochen@scram.de,
       sfr@canb.auug.org.au, segher@kernel.crashing.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm] watchdog: mpc8xxx_wdt: fix build
Message-ID: <20080607175713.GA27793@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080602173726.GA24556@polina.dev.rtsoft.ru> <20080603164830.32457962.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080603164830.32457962.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      drivers/watchdog/mpc8xxx_wdt.o
drivers/watchdog/mpc8xxx_wdt.c: In function 'mpc8xxx_wdt_ioctl':
drivers/watchdog/mpc8xxx_wdt.c:156: error: 'cmd' undeclared (first use in this function)
drivers/watchdog/mpc8xxx_wdt.c:156: error: (Each undeclared identifier is reported only once
drivers/watchdog/mpc8xxx_wdt.c:156: error: for each function it appears in.)
drivers/watchdog/mpc8xxx_wdt.c: At top level:
drivers/watchdog/mpc8xxx_wdt.c:176: warning: initialization from incompatible pointer type

This patch ought to be folded into
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g.patch

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

On Tue, Jun 03, 2008 at 04:48:30PM -0700, Andrew Morton wrote:
> On Mon, 2 Jun 2008 21:37:26 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > No comments on the previous version for two weeks... resending once
> > again.
> 
> I did all the rework to make the patches apply on top of all the
> pending watchdog work in Wim's tree and in -mm.  I haven't build tested
> it yet.

Well, only one hunk is mis-merged, in
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g.patch.

Here is the patch to fix it.

I also run-time tested it, everything seem to work great.

p.s. Would be very handy if linux-trees.git would track mmotm snapshots.

 drivers/watchdog/mpc8xxx_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 8b82b91..3c5ed9e 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -142,7 +142,7 @@ static int mpc8xxx_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static long mpc8xxx_wdt_ioctl(struct inode *inode, struct file *file,
+static long mpc8xxx_wdt_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
-- 
1.5.5.1

