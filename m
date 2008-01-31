Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbYAaKJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbYAaKJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764442AbYAaKIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:08:55 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:56624 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760762AbYAaKIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:08:52 -0500
Message-ID: <47A19E26.30107@panasas.com>
Date: Thu, 31 Jan 2008 12:08:38 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Sven_K=F6hler?= <skoehler@upb.de>,
       linux-scsi <linux-scsi@vger.kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG?] GDTH driver not working after upgrade to 2.6.24
References: <fnqka6$l46$1@ger.gmane.org>
In-Reply-To: <fnqka6$l46$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30 2008 at 21:47 +0200, Sven Köhler <skoehler@upb.de> wrote:
> Hi,
> 
> so i have upgraded a system to kernel 2.6.24. After that, it failed to 
> boot with the usual message telling, that the rootfs on device /dev/sda1 
>   cannot be mounted (a raid1 run by the controller below).
> 
> With 2.6.23.12, everything is working fine.
> 
> # lspci -v:
> 
> 03:01.0 RAID bus controller: Intel Corporation RAID Controller
>          Subsystem: Intel Corporation Unknown device 01db
>          Flags: bus master, 66MHz, slow devsel, latency 64, IRQ 17
>          Memory at ddffc000 (32-bit, prefetchable) [size=16K]
>          [virtual] Expansion ROM at deef0000 [disabled] [size=32K]
>          Capabilities: [80] Power Management version 2
> 
> # GDT-related dmesg output (2.6.23.12):
> 
> GDT-HA: Storage RAID Controller Driver. Version: 3.05
> ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 24 (level, low) -> IRQ 17
> GDT-HA: Found 1 PCI Storage RAID Controllers
> Configuring GDT-PCI HA at 3/1 IRQ 17
> GDT-HA 0: Name: SRCU42L
> scsi0 : SRCU42L
> scsi 0:0:0:0: Direct-Access     Intel    Host Drive  #00       PQ: 0 ANSI: 2
> scsi 0:2:6:0: Processor         ESG-SHV  SCA HSBP M29     1.06 PQ: 0 ANSI: 2
> sd 0:0:0:0: [sda] 143299800 512-byte hardware sectors (73369 MB)
> sd 0:0:0:0: [sda] Assuming Write Enabled
> sd 0:0:0:0: [sda] Assuming drive cache: write through
> sd 0:0:0:0: [sda] 143299800 512-byte hardware sectors (73369 MB)
> sd 0:0:0:0: [sda] Assuming Write Enabled
> sd 0:0:0:0: [sda] Assuming drive cache: write through
>   sda: sda1 sda2 < sda5 >
> sd 0:0:0:0: [sda] Attached SCSI disk
> 
> # cat /boot/config-2.6.24 |grep GDT
> 
> CONFIG_SCSI_GDTH=y
> 
> 
> 
> 
> Any ideas?
> 
> http://www.kernel.org/diff/diffview.cgi?file=%2Fpub%2Flinux%2Fkernel%2Fv2.6%2Fpatch-2.6.24.bz2 
> show huge drivers/scsi/gdth* related changes.
> 
> Can't test at the moment. System went production.
> 
> 
> Regards,
>    Sven
> 

Hi Sven!

CCing to the scsi mailing list. 

Yes the gdth driver passed an open hart surgery in kernel 2.6.24. The bad thing
about it is that all three of the Coders that did that did not have any HW to work
on. One of them is me. We did cry for tester for a long time but no one came forward.

Could you test patches for us? first thing would be to enable debug output patch below.

If you absolutely need a 2.6.24 kernel, + gdth in a production system you could
checkout the 2.6.23 driver and compile. The old driver will work the same in 2.6.24.
It will not however even compile in 2.6.25-rcx.

If any one wants to send me a card that uses the gdth driver, I will be very happy
to debug this card, and return it once I'm done.

Boaz

---
git-diff --stat -p
 drivers/scsi/gdth.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index c825239..eca72c4 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -188,6 +188,7 @@ static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
 				struct gdth_cmndinfo *cmndinfo);
 static void gdth_scsi_done(struct scsi_cmnd *scp);
 
+#define DEBUG_GDTH 1
 #ifdef DEBUG_GDTH
 static unchar   DebugState = DEBUG_GDTH;
 




 

