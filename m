Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbYEFNoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbYEFNoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbYEFNog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:44:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:34020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210AbYEFNof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:44:35 -0400
Subject: Re: acpi_cpu_freq_init warning...
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <87k5i8hrmk.fsf@duaron.myhome.or.jp>
References: <86802c440805051951u153ebc21p15f0d73904496217@mail.gmail.com>
	 <87k5i8hrmk.fsf@duaron.myhome.or.jp>
Content-Type: text/plain
Date: Tue, 06 May 2008 17:44:22 +0200
Message-Id: <1210088662.4802.69.camel@linux-2bdv.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 15:29 +0900, OGAWA Hirofumi wrote:
> > calling  acpi_cpufreq_init+0x0/0x68()
> > sysdev: class cpu: driver (ffffffff80da0110) has already been
> > registered to a class, something is wrong, but will forge on!
> > ------------[ cut here ]------------
> > WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x82/0x150()
> > Modules linked in:
> > Pid: 1, comm: swapper Not tainted
> > 2.6.26-rc1-sched-devel.git-x86-latest.git-00485-g253148c-dirty #333
> 
> I've seen this too. The following patch seems to work for me.

Venkatesh Greg, should this patch also go into 2.6.25 stable kernel?
Not 100% sure, but IIRC Jiri reported the same problem on a 2.6.25
kernel.

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


[PATCH] Fix bogus warning in sysdev_driver_register()

        if ((drv->entry.next != drv->entry.prev) ||
            (drv->entry.next != NULL)) {

warns list_empty(&drv->entry).

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 drivers/base/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/sys.c~fix-sys-bogus-warning drivers/base/sys.c
--- linux-2.6/drivers/base/sys.c~fix-sys-bogus-warning  2008-05-06 14:30:42.000000000 +0900
+++ linux-2.6-hirofumi/drivers/base/sys.c       2008-05-06 14:30:45.000000000 +0900
@@ -175,7 +175,7 @@ int sysdev_driver_register(struct sysdev
        }
 
        /* Check whether this driver has already been added to a class. */
-       if ((drv->entry.next != drv->entry.prev) ||
+       if ((drv->entry.next != drv->entry.prev) &&
            (drv->entry.next != NULL)) {
                printk(KERN_WARNING "sysdev: class %s: driver (%p) has already"
                        " been registered to a class, something is wrong, but "
_
--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


