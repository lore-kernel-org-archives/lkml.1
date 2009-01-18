Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbZARUsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbZARUsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 15:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbZARUsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 15:48:13 -0500
Received: from flock1.newmail.ru ([82.204.219.207]:58119 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754483AbZARUsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 15:48:12 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.29-rc2] Inconsistent lock state on resume in hres_timers_resume
Date: Sun, 18 Jan 2009 23:47:22 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-1avb; KDE/4.1.96; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <200901181642.00886.arvidjaar@mail.ru> <20090118195645.GA6634@elte.hu> <200901182121.24863.rjw@sisk.pl>
In-Reply-To: <200901182121.24863.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1239319.QoMQa1RnBg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901182347.26083.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1239319.QoMQa1RnBg
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 18 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 23:21:24 Rafael J. Wysocki =
wrote:

> > > As far as I can tell, timekeeping_resume is called via class
> > > ->resume method; and according to comments in sysdev_resume() and
> > > device_power_up(), they are called with interrupts disabled.
> > >
> > > Looking at suspend_enter, irqs *are* disabled at this point.
> > >
> > > So it actually looks like something (may be some driver)
> > > unconditionally enabled irqs in resume path.
> > >
> > > I believe the patch should be hold back until this is clarified.
> >
> > That's a nice theory!
>
> That would be a bad bug.
>

If the below is correct, I wonder, why I am the only one to see it?=20

[  134.727381] PM: Syncing filesystems ... done.
[  134.767483] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[  134.809435] Freezing user space processes ... (elapsed 0.02 seconds)=20
done.
[  134.831823] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
)=20
done.
[  134.832520] Suspending console(s) (use no_console_suspend to debug)
[  134.844050] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  135.335944] sd 0:0:0:0: [sda] Stopping disk
[  136.019819] pci 0000:01:00.0: power state changed by ACPI to D3
[  136.034461] e100 0000:00:0a.0: PME# enabled
[  136.034699] e100 0000:00:0a.0: wake-up capability enabled by ACPI
[  136.034868] e100 0000:00:0a.0: PCI INT A disabled
[  136.097607] ALI 5451 0000:00:06.0: PCI INT A disabled
[  136.110484] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[  136.894487] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[  136.906958] ohci_hcd 0000:00:02.0: PME# enabled
[  136.907177] ohci_hcd 0000:00:02.0: wake-up capability enabled by ACPI
[  136.907208] ohci_hcd 0000:00:02.0: PCI INT A disabled
[  136.923328] ACPI: Preparing to enter system sleep state S3
[  136.937129] ------------[ cut here ]------------
[  136.937142] WARNING: at /home/bor/src/linux-git/drivers/base/sys.c:400=20
sysdev_suspend+0x268/0x270()
[  136.937151] Hardware name: PORTEGE 4000
[  136.937184] timekeeping_suspend+0x0/0x80 enabled IRQs
=2E..
[  136.937323] Pid: 4305, comm: pm-suspend Not tainted 2.6.29-rc2-1avb #5
[  136.937330] Call Trace:
[  136.937358]  [<c011f8b3>] warn_slowpath+0x73/0xd0
[  136.937373]  [<c0143028>] ? mark_held_locks+0x48/0x90
[  136.937395]  [<c0309245>] ? _spin_unlock_irqrestore+0x35/0x60
[  136.937406]  [<c0143269>] ? trace_hardirqs_on_caller+0x139/0x190
[  136.937433]  [<c0106c07>] ? init_pit_timer+0x67/0xf0
[  136.937442]  [<c01432cb>] ? trace_hardirqs_on+0xb/0x10
[  136.937451]  [<c0140e05>] ? lock_release_holdtime+0x35/0x210
[  136.937466]  [<c013db50>] ? clockevents_notify+0x30/0x80
[  136.937475]  [<c030928d>] ? _spin_unlock+0x1d/0x20
[  136.937484]  [<c013db50>] ? clockevents_notify+0x30/0x80
[  136.937495]  [<c0273828>] sysdev_suspend+0x268/0x270
[  136.937504]  [<c013ab30>] ? timekeeping_suspend+0x0/0x80
[  136.937535]  [<c027929f>] device_power_down+0xef/0x110
[  136.937564]  [<c0150462>] suspend_devices_and_enter+0xb2/0x150
[  136.937575]  [<c0150c6f>] ? freeze_processes+0x3f/0x90
[  136.937584]  [<c0150654>] enter_state+0xf4/0x140
[  136.937594]  [<c015071d>] state_store+0x7d/0xc0
[  136.937602]  [<c01506a0>] ? state_store+0x0/0xc0
[  136.937629]  [<c0202de4>] kobj_attr_store+0x24/0x30
[  136.937640]  [<c01dd57c>] sysfs_write_file+0x9c/0x100
[  136.937673]  [<c01991ac>] vfs_write+0x9c/0x160
[  136.937683]  [<c0103494>] ? restore_nocheck_notrace+0x0/0xe
[  136.937692]  [<c01dd4e0>] ? sysfs_write_file+0x0/0x100
[  136.937701]  [<c019932d>] sys_write+0x3d/0x70
[  136.937711]  [<c0103371>] sysenter_do_call+0x12/0x31
[  136.937718] ---[ end trace a8e2ee01b2b45f69 ]---
[  136.937727] ------------[ cut here ]------------

This is with this patch:


diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index c98c31e..7245496 100644
=2D-- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -341,13 +341,17 @@ static void __sysdev_resume(struct sys_device *dev)
 	struct sysdev_driver *drv;
=20
 	/* First, call the class-specific one */
=2D	if (cls->resume)
+	if (cls->resume) {
 		cls->resume(dev);
+		WARN(!irqs_disabled(), "%pF enabled IRQs\n", cls->resume);
+	}
=20
 	/* Call auxillary drivers next. */
 	list_for_each_entry(drv, &cls->drivers, entry) {
=2D		if (drv->resume)
+		if (drv->resume) {
 			drv->resume(dev);
+			WARN(!irqs_disabled(), "%pF enabled IRQs\n", drv->resume);
+		}
 	}
 }
=20
@@ -384,6 +388,7 @@ int sysdev_suspend(pm_message_t state)
 			list_for_each_entry(drv, &cls->drivers, entry) {
 				if (drv->suspend) {
 					ret =3D drv->suspend(sysdev, state);
+					WARN(!irqs_disabled(), "%pF enabled IRQs\n", drv-
>suspend);
 					if (ret)
 						goto aux_driver;
 				}
@@ -392,6 +397,7 @@ int sysdev_suspend(pm_message_t state)
 			/* Now call the generic one */
 			if (cls->suspend) {
 				ret =3D cls->suspend(sysdev, state);
+				WARN(!irqs_disabled(), "%pF enabled IRQs\n", cls->suspend);
 				if (ret)
 					goto cls_driver;
 			}


--nextPart1239319.QoMQa1RnBg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklzlV0ACgkQR6LMutpd94zSeQCffVaO8SG4ctGCVuIikeJ1Fcxu
DVMAn3+PSPZvWZTL7IQeNaJoDBYPkASq
=7ic5
-----END PGP SIGNATURE-----

--nextPart1239319.QoMQa1RnBg--
