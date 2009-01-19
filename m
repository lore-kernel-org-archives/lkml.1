Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbZASEXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbZASEXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 23:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbZASEXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 23:23:08 -0500
Received: from flock1.newmail.ru ([82.204.219.207]:56050 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752746AbZASEXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 23:23:07 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.29-rc2] Inconsistent lock state on resume in hres_timers_resume
Date: Mon, 19 Jan 2009 07:22:07 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-1avb; KDE/4.1.96; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <200901181642.00886.arvidjaar@mail.ru> <200901182347.26083.arvidjaar@mail.ru> <200901190117.49748.rjw@sisk.pl>
In-Reply-To: <200901190117.49748.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart21625522.8phyIJRBl4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901190722.10762.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart21625522.8phyIJRBl4
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 19 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 03:17:49 Rafael J. Wysocki =
wrote:
> On Sunday 18 January 2009, Andrey Borzenkov wrote:
> > On 18 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 23:21:24 Rafael J. Wyso=
cki wrote:
> > > > > As far as I can tell, timekeeping_resume is called via class
> > > > > ->resume method; and according to comments in sysdev_resume()
> > > > > and device_power_up(), they are called with interrupts
> > > > > disabled.
> > > > >
> > > > > Looking at suspend_enter, irqs *are* disabled at this point.
> > > > >
> > > > > So it actually looks like something (may be some driver)
> > > > > unconditionally enabled irqs in resume path.
> > > > >
> > > > > I believe the patch should be hold back until this is
> > > > > clarified.
> > > >
> > > > That's a nice theory!
> > >
> > > That would be a bad bug.
> >

With sligtly modified patch:

[  133.000279] PM: Syncing filesystems ... done.                           =
    =20
[  133.062027] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin       =
    =20
[  133.102942] Freezing user space processes ... (elapsed 0.02 seconds)=20
done.  =20
[  133.123635] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
)=20
done.                                                                      =
       =20
[  133.124813] Suspending console(s) (use no_console_suspend to debug)     =
    =20
[  133.136151] sd 0:0:0:0: [sda] Synchronizing SCSI cache                  =
    =20
[  133.648916] sd 0:0:0:0: [sda] Stopping disk                             =
    =20
[  134.339703] pci 0000:01:00.0: power state changed by ACPI to D3         =
    =20
[  134.354447] e100 0000:00:0a.0: PME# enabled                             =
    =20
[  134.354679] e100 0000:00:0a.0: wake-up capability enabled by ACPI       =
    =20
[  134.354845] e100 0000:00:0a.0: PCI INT A disabled                       =
    =20
[  134.420836] ALI 5451 0000:00:06.0: PCI INT A disabled                   =
    =20
[  134.433823] ALI 5451 0000:00:06.0: power state changed by ACPI to D3    =
    =20
[  135.192366] pata_ali 0000:00:04.0: can't derive routing for PCI INT A   =
    =20
[  135.203635] ohci_hcd 0000:00:02.0: PME# enabled                         =
    =20
[  135.203854] ohci_hcd 0000:00:02.0: wake-up capability enabled by ACPI   =
    =20
[  135.203886] ohci_hcd 0000:00:02.0: PCI INT A disabled                   =
    =20
[  135.220184] ACPI: Preparing to enter system sleep state S3              =
    =20
[  135.233610] ------------[ cut here ]------------                        =
    =20
[  135.233624] WARNING: at /home/bor/src/linux-
git/kernel/time/timekeeping.c:357 timekeeping_suspend+0xe9/0x230()         =
                                     =20
[  135.233633] Hardware name: PORTEGE 4000                                 =
    =20
[  135.233638] [0] Interrupts enabled in timekeeping_suspend               =
    =20
[  135.233772] Pid: 4232, comm: pm-suspend Not tainted 2.6.29-rc2-1avb #7  =
    =20
[  135.233779] Call Trace:                                                 =
    =20
[  135.233809]  [<c011f8b3>] warn_slowpath+0x73/0xd0                       =
    =20
[  135.233825]  [<c0143419>] ? trace_hardirqs_on_caller+0x139/0x190        =
    =20
[  135.233835]  [<c014347b>] ? trace_hardirqs_on+0xb/0x10                  =
    =20
[  135.233844]  [<c013831a>] ? up+0x2a/0x40                                =
    =20
[  135.233870]  [<c02346ba>] ? acpi_os_signal_semaphore+0x25/0x29          =
    =20
[  135.233902]  [<c024aea0>] ? acpi_ut_release_mutex+0x54/0x58             =
    =20
[  135.233935]  [<c02423f9>] ? acpi_get_data+0x51/0x60                     =
    =20
[  135.233952]  [<c024c5c7>] ? acpi_bus_data_handler+0x0/0x5               =
    =20
[  135.233962]  [<c024be26>] ? acpi_bus_get_device+0x20/0x32               =
    =20
[  135.233973]  [<c024bec6>] ? acpi_bus_power_manageable+0xe/0x25          =
    =20
[  135.234002]  [<c02226a4>] ? acpi_pci_power_manageable+0x14/0x20         =
    =20
[  135.234012]  [<c021c972>] ? pci_set_power_state+0x92/0x2c0              =
    =20
[  135.234049]  [<c021ab5a>] ? pci_find_capability+0x5a/0x80               =
    =20
[  135.234059]  [<c013ac19>] timekeeping_suspend+0xe9/0x230                =
    =20
[  135.234090]  [<c0273825>] sysdev_suspend+0xb5/0x270                     =
    =20
[  135.234119]  [<c0278adf>] ? device_pm_lock+0xf/0x20                     =
    =20
[  135.234128]  [<c027944f>] device_power_down+0xef/0x110                  =
    =20
[  135.234156]  [<c0150612>] suspend_devices_and_enter+0xb2/0x150          =
    =20
[  135.234167]  [<c0150e1f>] ? freeze_processes+0x3f/0x90                  =
    =20
[  135.234176]  [<c0150804>] enter_state+0xf4/0x140                        =
    =20
[  135.234185]  [<c01508cd>] state_store+0x7d/0xc0                         =
    =20
[  135.234193]  [<c0150850>] ? state_store+0x0/0xc0                        =
    =20
[  135.234219]  [<c0202f94>] kobj_attr_store+0x24/0x30                     =
    =20
[  135.234229]  [<c01dd72c>] sysfs_write_file+0x9c/0x100                   =
    =20
[  135.234262]  [<c019935c>] vfs_write+0x9c/0x160                          =
    =20
[  135.234277]  [<c0103494>] ? restore_nocheck_notrace+0x0/0xe             =
    =20
[  135.234285]  [<c01dd690>] ? sysfs_write_file+0x0/0x100                  =
    =20
[  135.234294]  [<c01994dd>] sys_write+0x3d/0x70                           =
    =20
[  135.234303]  [<c0103371>] sysenter_do_call+0x12/0x31                    =
    =20
[  135.234310] ---[ end trace 0160afff8645b4ac ]---                        =
    =20

I am absolutely confused. According to Documentation/power/devices.txt,=20
timekeeping_suspend and timekeeping_resume are class interfaces and allowed=
=20
to sleep. "Allowed to sleep" means to me - irqa enabled? But=20
device_power_down obviously runs under irqs disabled?


diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 900f1b6..1f9f98f 100644
=2D-- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -353,15 +353,35 @@ static int timekeeping_suspend(struct sys_device *dev=
,=20
pm_message_t state)
 {
 	unsigned long flags;
=20
+	WARN_ONCE(!irqs_disabled(),
+			"[0] Interrupts enabled in timekeeping_suspend\n");
+
 	timekeeping_suspend_time =3D read_persistent_clock();
=20
+	WARN_ONCE(!irqs_disabled(),
+			"[1] Interrupts enabled in timekeeping_suspend\n");
+
 	write_seqlock_irqsave(&xtime_lock, flags);
+
+	WARN_ONCE(!irqs_disabled(),
+			"[2] Interrupts enabled in timekeeping_suspend\n");
+
 	clocksource_forward_now();
+
+	WARN_ONCE(!irqs_disabled(),
+			"[3] Interrupts enabled in timekeeping_suspend\n");
+
 	timekeeping_suspended =3D 1;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
=20
+	WARN_ONCE(!irqs_disabled(),
+			"[4] Interrupts enabled in timekeeping_suspend\n");
+
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
=20
+	WARN_ONCE(!irqs_disabled(),
+			"[5] Interrupts enabled in timekeeping_suspend\n");
+
 	return 0;
 }
=20


--nextPart21625522.8phyIJRBl4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklz//IACgkQR6LMutpd94zRPgCgvv1QbJ3wSSO7+bBT5xor47YC
ph0AoMWd4dbDIhlFPerP35daocrY0UsS
=8ylH
-----END PGP SIGNATURE-----

--nextPart21625522.8phyIJRBl4--
