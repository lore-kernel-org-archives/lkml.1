Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZBROeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZBROeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 09:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZBROeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 09:34:08 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:3686 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751148AbZBROeH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 09:34:07 -0500
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Feb 2009 09:34:07 EST
X-BigFish: VPS-24(zz1432R98dR1805M936fKzzzzz32i6bh6di43j)
X-WSS-ID: 0KF9MF3-01-UJU-01
Date: Wed, 18 Feb 2009 15:18:43 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mark Hounschell <markh@compro.net>
CC: Mark Hounschell <dmarkh@cfl.rr.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD Phenom-II
	processor
Message-ID: <20090218141843.GB13304@aftab>
References: <20090203151137.GB12017@aftab> <498897C1.2090802@compro.net> <498B1FA9.2050203@cfl.rr.com> <20090206135248.GB23459@aftab> <498C44FA.1010106@compro.net> <498C7980.2060309@compro.net> <498CB798.7050308@cfl.rr.com> <20090209141841.GA31643@aftab> <49904BED.7090208@cfl.rr.com> <499C0913.9050905@compro.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <499C0913.9050905@compro.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 18 Feb 2009 14:18:42.0967 (UTC) FILETIME=[CD901A70:01C991D3]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 08:11:47AM -0500, Mark Hounschell wrote:
> Mark Hounschell wrote:
> > Borislav Petkov wrote:
> 
> >> maybe I wasn't clear enough - I meant to boot a _1000HZ_ kernel not a
> >> 250HZ one with highres timers disabled, if the line above is correct.
> >> Can you try the same thing as above again, please, but this time use a
> >> 1000HZ 32bit kernel.
> >>
> >> Thanks.
> >>
> > 
> > Checking if this processor honours the WP bit even in supervisor mode...Ok.
> > SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> > HPE

Well, not really since we can't know for sure where your machine hangs.
It might be a problem with the HPET but we can't be sure what we see
above is the last string that entered the printk buffer. However, let's
try the following patch (against vanilla 2.6.28.3), please capture the
dmesg again and send it back, thanks.


---
 arch/x86/kernel/hpet.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 067d8de..068cbc7 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -269,6 +269,11 @@ static void hpet_set_mode(enum clock_event_mode mode,
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
 		       HPET_TN_SETVAL | HPET_TN_32BIT;
+
+		printk(KERN_ERR "HPET%d prog. values: now %lu, delta %llu, "
+				"cfg: 0x%lx, \n",
+				timer, now, delta, cfg);
+
 		hpet_writel(cfg, HPET_Tn_CFG(timer));
 		/*
 		 * The first write after writing TN_SETVAL to the
-- 
1.6.0.4


-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

