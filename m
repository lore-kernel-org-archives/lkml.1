Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbYHCOw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbYHCOw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 10:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757946AbYHCOwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 10:52:08 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:20576 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbYHCOwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 10:52:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=OfSAqTjMs0JknBfR8dB+K/lgBx2BLM4UVwPaswjMwCTuqXvkM3XTdk36KhGsNyvfB2
         D+KWFLaqHMlgtfSB/I20ArUGvCo9STdKshOllGM3p2Urgnpby4ygULoTnL2ZE+IerP+B
         Cfvs6OCwf9kedAm5FVSNGJci70vtjKVnjG5t4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: Re: 2.6.27-rc1-mm1: rmmod ide-cd_mod oops
Date: Sun, 3 Aug 2008 16:41:55 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080731000354.24b55d5b.akpm@linux-foundation.org> <200808021815.57573.bzolnier@gmail.com> <200808030125.04737.m.kozlowski@tuxland.pl>
In-Reply-To: <200808030125.04737.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808031641.56096.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 August 2008, Mariusz Kozlowski wrote:
> Hi,
>  
> > > 	rmmod on ide-cd_mod causes this oops:
> > > 
> > > BUG: unable to handle kernel paging request at 83535683
> > > IP: [<c0246ffa>] ide_device_put+0xc/0x33
> > > *pde = 00000000 
> > > Oops: 0000 [#1] PREEMPT 
> > > last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0/resource
> > > Modules linked in: radeon drm nfsd lockd sunrpc exportfs pcmcia uhci_hcd ehci_hcd usbcore snd_ali5451 yenta_socket pcspkr snd_ac97_codec ac97_bus rsrc_nonstatic snd_pcm snd_timer ati_agp agpgart snd soundcore snd_page_alloc ide_cd_mod(-) cdrom 8139too psmouse sony_laptop backlight floppy rtc
> > > 
> > > Pid: 3890, comm: rmmod Not tainted (2.6.27-rc1-mm1 #2)
> > > EIP: 0060:[<c0246ffa>] EFLAGS: 00010286 CPU: 0
> > > EIP is at ide_device_put+0xc/0x33
> > > EAX: 83535657 EBX: dc927a00 ECX: 00000003 EDX: 00000001
> > > ESI: dec34e34 EDI: dec34e34 EBP: d9f46ee0 ESP: d9f46edc
> > >  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > > Process rmmod (pid: 3890, ti=d9f46000 task=dd88e780 task.ti=d9f46000)
> > > Stack: dc927c00 d9f46eec dec2e202 dc927c00 d9f46ef8 dec2e225 dd9138dc d9f46f00 
> > >        c02469e0 d9f46f10 c024156f dd9138dc dd9139f4 d9f46f24 c024162c 00000880 
> > >        dec34e34 c0397dc0 d9f46f38 c0240a33 00000880 dec34e34 00000000 d9f46f48 
> > > Call Trace:
> > >  [<dec2e202>] ? ide_cd_put+0x26/0x33 [ide_cd_mod]
> > >  [<dec2e225>] ? ide_cd_remove+0x16/0x19 [ide_cd_mod]
> > >  [<c02469e0>] ? generic_ide_remove+0x1a/0x1e
> > >  [<c024156f>] ? __device_release_driver+0x59/0x7f
> > >  [<c024162c>] ? driver_detach+0x97/0x99
> > >  [<c0240a33>] ? bus_remove_driver+0x6f/0x8b
> > >  [<c02419f1>] ? driver_unregister+0x2f/0x33
> > >  [<dec31331>] ? ide_cdrom_exit+0xd/0xf [ide_cd_mod]
> > >  [<c014265a>] ? sys_delete_module+0x10d/0x1e2
> > >  [<c015fedc>] ? do_munmap+0x1d7/0x234
> > >  [<c01e8684>] ? trace_hardirqs_on_thunk+0xc/0x10
> > >  [<c0103015>] ? sysenter_do_call+0x12/0x35
> > >  =======================
> > > Code: ff ff 89 44 24 08 c7 44 24 04 a7 de 35 c0 89 34 24 e8 cb ce f9 ff 31 c0 83 c4 0c 5b 5e 5d c3 55 89 e5 53 89 c3 8b 40 24 8b 40 10 <8b> 40 2c 85 c0 74 12 8b 80 44 01 00 00 8b 40 08 85 c0 74 05 e8 
> > > EIP: [<c0246ffa>] ide_device_put+0xc/0x33 SS:ESP 0068:d9f46edc
> > > ---[ end trace a2eed48430d87636 ]---
> > > 
> > > this is easily reporoducible, more investigation points here:

[...]

> 1) on drive->hwif (drive is null)

[...]

Thanks for debugging this.  I see the problem now: previous reference
counting fix was totally fscked up and introduced access to cd->drive
after putting last reference on cd (time to re-supply brown paper bag
stock).  The incremental fix (for 2.6.27-rc1-mm1) attached, the fixed
original patch will be posted in the separate mail.

> 2) on drive->hwif->host->dev[0] (->dev is bogus?)

Does it still happen with the 1) fixed?

---
 drivers/ide/ide-cd.c     |    4 +++-
 drivers/ide/ide-disk.c   |    4 +++-
 drivers/ide/ide-floppy.c |    4 +++-
 drivers/ide/ide-tape.c   |    4 +++-
 drivers/scsi/ide-scsi.c  |    4 +++-
 5 files changed, 15 insertions(+), 5 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -78,9 +78,11 @@ static struct cdrom_info *ide_cd_get(str
 
 static void ide_cd_put(struct cdrom_info *cd)
 {
+	ide_drive_t *drive = cd->drive;
+
 	mutex_lock(&idecd_ref_mutex);
 	kref_put(&cd->kref, ide_cd_release);
-	ide_device_put(cd->drive);
+	ide_device_put(drive);
 	mutex_unlock(&idecd_ref_mutex);
 }
 
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -74,9 +74,11 @@ static struct ide_disk_obj *ide_disk_get
 
 static void ide_disk_put(struct ide_disk_obj *idkp)
 {
+	ide_drive_t *drive = idkp->drive;
+
 	mutex_lock(&idedisk_ref_mutex);
 	kref_put(&idkp->kref, ide_disk_release);
-	ide_device_put(idkp->drive);
+	ide_device_put(drive);
 	mutex_unlock(&idedisk_ref_mutex);
 }
 
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -179,9 +179,11 @@ static struct ide_floppy_obj *ide_floppy
 
 static void ide_floppy_put(struct ide_floppy_obj *floppy)
 {
+	ide_drive_t *drive = floppy->drive;
+
 	mutex_lock(&idefloppy_ref_mutex);
 	kref_put(&floppy->kref, idefloppy_cleanup_obj);
-	ide_device_put(floppy->drive);
+	ide_device_put(drive);
 	mutex_unlock(&idefloppy_ref_mutex);
 }
 
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -342,9 +342,11 @@ static struct ide_tape_obj *ide_tape_get
 
 static void ide_tape_put(struct ide_tape_obj *tape)
 {
+	ide_drive_t *drive = tape->drive;
+
 	mutex_lock(&idetape_ref_mutex);
 	kref_put(&tape->kref, ide_tape_release);
-	ide_device_put(tape->drive);
+	ide_device_put(drive);
 	mutex_unlock(&idetape_ref_mutex);
 }
 
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -112,9 +112,11 @@ static struct ide_scsi_obj *ide_scsi_get
 
 static void ide_scsi_put(struct ide_scsi_obj *scsi)
 {
+	ide_drive_t *drive = scsi->drive;
+
 	mutex_lock(&idescsi_ref_mutex);
 	scsi_host_put(scsi->host);
-	ide_device_put(scsi->drive);
+	ide_device_put(drive);
 	mutex_unlock(&idescsi_ref_mutex);
 }
 

