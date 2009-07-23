Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZGWQH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZGWQH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 12:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbZGWQH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 12:07:27 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50513 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbZGWQH0 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 12:07:26 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: 31-rc3-mmotm0716 - dead USB trackball mouse kills entire system
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248365208_2728P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Jul 2009 12:06:49 -0400
Message-ID: <4789.1248365209@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248365208_2728P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

(Throwing at everybody in MAINTAINERS that might know something...)

OK. To start off - I *know* it's a trackball that is on its last legs.
However, (a) it's my favorite mouse design *ever* and (b) it's out of
production, so I'm trying to delay as long as possible replacing it.
Especially when the entire problem is that the USB cord has one broken/lo=
ose
conductor, which means that four or five times a day I have to wiggle the=
 cord
a 1/16=22 to wake it back up, and I get this sort of spewage in my consol=
e logs
if running a -mmotm0702 or earlier kernel:

=5B  305.300116=5D usb 1-8.3: USB disconnect, address 6
=5B  305.480251=5D usb 1-8.3: new low speed USB device using ehci_hcd and=
 address 7
=5B  305.559595=5D SELinux:  Context staff_u:object_r:gconf_home_t:s0 is =
not valid (left unmapped).
=5B  305.570989=5D usb 1-8.3: New USB device found, idVendor=3D045e, idPr=
oduct=3D0023
=5B  305.570999=5D usb 1-8.3: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D0
=5B  305.571043=5D usb 1-8.3: Product: Microsoft Trackball Optical=AE
=5B  305.571050=5D usb 1-8.3: Manufacturer: Microsoft
=5B  305.571367=5D usb 1-8.3: configuration =231 chosen from 1 choice
=5B  305.580597=5D input: Microsoft Microsoft Trackball Optical=AE as /de=
vices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8.3/1-8.3:1.0/input/input9
=5B  305.580845=5D generic-usb 0003:045E:0023.0002: input,hidraw0: USB HI=
D v1.00 Mouse =5BMicrosoft Microsoft Trackball Optical=AE=5D on usb-0000:=
00:1d.7-8.3/input0
=5B  308.116101=5D usb 1-8.3: USB disconnect, address 7
=5B  308.291271=5D usb 1-8.3: new low speed USB device using ehci_hcd and=
 address 8
=5B  308.381867=5D usb 1-8.3: New USB device found, idVendor=3D045e, idPr=
oduct=3D0023
=5B  308.381876=5D usb 1-8.3: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D0
=5B  308.381883=5D usb 1-8.3: Product: Microsoft Trackball Optical=AE
=5B  308.381889=5D usb 1-8.3: Manufacturer: Microsoft
=5B  308.382181=5D usb 1-8.3: configuration =231 chosen from 1 choice
=5B  308.389974=5D input: Microsoft Microsoft Trackball Optical=AE as /de=
vices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8.3/1-8.3:1.0/input/input10
=5B  308.390266=5D generic-usb 0003:045E:0023.0003: input,hidraw0: USB HI=
D v1.00 Mouse =5BMicrosoft Microsoft Trackball Optical=AE=5D on usb-0000:=
00:1d.7-8.3/input0

Pretty much what you'd *expect* to see if a device keeps dropping in and =
out...

Well... Usually.  Today, on a -mmotm0716 kernel, the loose conductor stru=
ck
again, and no amount of wiggling would resurrect it as far as the system =
was
concerned.  Note however that it *did* wake up just fine when I finally
rebooted the machine, even though I had not touched the mouse any further=
 -
which says to me that the wires were making a connection again, but the k=
ernel
wasn't picking up on it.

Meanwhile, in my kernel logs, I had:

=5B  571.965568=5D drivers/hid/usbhid/hid-core.c: can't reset device, 000=
0:00:1d.7-8.3/input0, status -71
=5B  571.965661=5D usb 1-8: clear tt 3 (0060) error -32
=5B  571.981570=5D drivers/hid/usbhid/hid-core.c: can't reset device, 000=
0:00:1d.7-8.3/input0, status -71
=5B  571.981668=5D usb 1-8: clear tt 3 (0060) error -32
=5B  571.997698=5D drivers/hid/usbhid/hid-core.c: can't reset device, 000=
0:00:1d.7-8.3/input0, status -71
=5B  571.997782=5D usb 1-8: clear tt 3 (0060) error -32
=5B  572.013568=5D drivers/hid/usbhid/hid-core.c: can't reset device, 000=
0:00:1d.7-8.3/input0, status -71
=5B  572.013656=5D usb 1-8: clear tt 3 (0060) error -32
=5B  572.029694=5D drivers/hid/usbhid/hid-core.c: can't reset device, 000=
0:00:1d.7-8.3/input0, status -71
=5B  572.029783=5D usb 1-8: clear tt 3 (0060) error -32
=5B  572.045696=5D drivers/hid/usbhid/hid-core.c: can't reset device, 000=
0:00:1d.7-8.3/input0, status -71
=5B  572.045781=5D usb 1-8: clear tt 3 (0060) error -32
=5B  572.061567=5D drivers/hid/usbhid/hid-core.c: can't reset device, 000=
0:00:1d.7-8.3/input0, status -71
=5B  572.061655=5D usb 1-8: clear tt 3 (0060) error -32
=5B  572.077698=5D drivers/hid/usbhid/hid-core.c: can't reset device, 000=
0:00:1d.7-8.3/input0, status -71
=5B  572.077782=5D usb 1-8: clear tt 3 (0060) error -32
=5B  572.088910=5D usb 1-8.3: USB disconnect, address 6
=5B  572.267417=5D usb 1-8.3: new low speed USB device using ehci_hcd and=
 address 7
=5B  572.357781=5D usb 1-8.3: New USB device found, idVendor=3D045e, idPr=
oduct=3D0023
=5B  572.357789=5D usb 1-8.3: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D0
=5B  572.357796=5D usb 1-8.3: Product: Microsoft Trackball Optical=AE
=5B  572.357802=5D usb 1-8.3: Manufacturer: Microsoft
=5B  572.358075=5D usb 1-8.3: configuration =231 chosen from 1 choice
=5B  572.365574=5D input: Microsoft Microsoft Trackball Optical=AE as /de=
vices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8.3/1-8.3:1.0/input/input9
=5B  572.365829=5D generic-usb 0003:045E:0023.0002: input,hidraw0: USB HI=
D v1.00 Mouse =5BMicrosoft Microsoft Trackball Optical=AE=5D on usb-0000:=
00:1d.7-8.3/input0

The =22can't reset device=22 is apparently new with mm-0716 - I've not se=
en it
before in at least the 6 weeks my logs go back. And it seems to be the
beginning of things going pear-shaped, even though it manages to reset th=
e
device. A few seconds, the events thread whinges that not all is fine in =
USB
land:

=5B  588.903158=5D usb 1-8.3: reset low speed USB device using ehci_hcd a=
nd address 7
=5B  593.903075=5D ------------=5B cut here =5D------------
=5B  593.903091=5D WARNING: at drivers/usb/host/ehci-hcd.c:906 ehci_urb_d=
equeue+0xa9/0x145()
=5B  593.903098=5D Hardware name: Latitude D820                  =20
=5B  593.903102=5D Modules linked in: ext4 jbd2 crc16 nvidia(P) =5Blast u=
nloaded: microcode=5D
=5B  593.903127=5D Pid: 10, comm: events/0 Tainted: P           2.6.31-rc=
3-mmotm0716 =235
=5B  593.903133=5D Call Trace:
=5B  593.903147=5D  =5B<ffffffff8103f459>=5D warn_slowpath_common+0x77/0x=
8f
=5B  593.903156=5D  =5B<ffffffff8103f480>=5D warn_slowpath_null+0xf/0x11
=5B  593.903165=5D  =5B<ffffffff812d66cb>=5D ehci_urb_dequeue+0xa9/0x145
=5B  593.903176=5D  =5B<ffffffff812c20f6>=5D unlink1+0xcd/0xe0
=5B  593.903185=5D  =5B<ffffffff812c2279>=5D usb_hcd_unlink_urb+0x60/0x84=

=5B  593.903194=5D  =5B<ffffffff812c34d0>=5D usb_kill_urb+0x4f/0xc7
=5B  593.903204=5D  =5B<ffffffff812c4ae4>=5D usb_start_wait_urb+0x9e/0xde=

=5B  593.903214=5D  =5B<ffffffff812c3b1d>=5D ? usb_init_urb+0x22/0x33
=5B  593.903224=5D  =5B<ffffffff812c4dd1>=5D usb_control_msg+0x172/0x196
=5B  593.903233=5D  =5B<ffffffff812be39b>=5D hub_port_init+0x348/0x71e
=5B  593.903244=5D  =5B<ffffffff812be80e>=5D usb_reset_and_verify_device+=
0x9d/0x3f0
=5B  593.903253=5D  =5B<ffffffff812c34a0>=5D ? usb_kill_urb+0x1f/0xc7
=5B  593.903263=5D  =5B<ffffffff81034cb0>=5D ? get_parent_ip+0x11/0x42
=5B  593.903273=5D  =5B<ffffffff81327812>=5D ? hid_cease_io+0x36/0x3b
=5B  593.903282=5D  =5B<ffffffff812bebfa>=5D usb_reset_device+0x99/0x11c
=5B  593.903291=5D  =5B<ffffffff8132808f>=5D ? hid_reset+0x0/0x128
=5B  593.903299=5D  =5B<ffffffff8132812a>=5D hid_reset+0x9b/0x128
=5B  593.903309=5D  =5B<ffffffff81051a48>=5D worker_thread+0x2ba/0x3e9
=5B  593.903317=5D  =5B<ffffffff810519ef>=5D ? worker_thread+0x261/0x3e9
=5B  593.903328=5D  =5B<ffffffff81056841>=5D ? autoremove_wake_function+0=
x0/0x34
=5B  593.903337=5D  =5B<ffffffff8105178e>=5D ? worker_thread+0x0/0x3e9
=5B  593.903346=5D  =5B<ffffffff81056433>=5D kthread+0x85/0x8d
=5B  593.903357=5D  =5B<ffffffff8100c41a>=5D child_rip+0xa/0x20
=5B  593.903367=5D  =5B<ffffffff8100bd80>=5D ? restore_args+0x0/0x30
=5B  593.903377=5D  =5B<ffffffff810563ae>=5D ? kthread+0x0/0x8d
=5B  593.903385=5D  =5B<ffffffff8100c410>=5D ? child_rip+0x0/0x20
=5B  593.903391=5D ---=5B end trace 816b51bf46b6656d =5D---

And 2 minutes later, things are *still* not fine, and other things
are hanging as well.  Since the 'events' thread is hung, both my mouse
and keyboard are dead (though alt-sysrq kept working, since it does its
magic behind 'events' back).

=5B  720.548076=5D INFO: task events/0:10 blocked for more than 120 secon=
ds.
=5B  720.548083=5D =22echo 0 > /proc/sys/kernel/hung_task_timeout_secs=22=
 disables this message.
=5B  720.548090=5D events/0      D 0000000000000000  4640    10      2 0x=
00000000
=5B  720.548104=5D  ffff88007f8d7ae0 0000000000000046 ffff88007f8d7a80 00=
00000000000046
=5B  720.548119=5D  0000000000000000 ffffffff81056a51 0000000000000000 ff=
ffffff8174c658
=5B  720.548133=5D  ffff88007f8d7a70 ffff88007f8d4660 000000000000df88 ff=
ff88007f8d4660
=5B  720.548147=5D Call Trace:
=5B  720.548166=5D  =5B<ffffffff81056a51>=5D ? prepare_to_wait+0x1c/0x5c
=5B  720.548178=5D  =5B<ffffffff814a2819>=5D ? _spin_unlock_irqrestore+0x=
72/0x80
=5B  720.548190=5D  =5B<ffffffff812c352a>=5D usb_kill_urb+0xa9/0xc7
=5B  720.548199=5D  =5B<ffffffff81056841>=5D ? autoremove_wake_function+0=
x0/0x34
=5B  720.548209=5D  =5B<ffffffff812c4ae4>=5D usb_start_wait_urb+0x9e/0xde=

=5B  720.548219=5D  =5B<ffffffff812c3b1d>=5D ? usb_init_urb+0x22/0x33
=5B  720.548229=5D  =5B<ffffffff812c4dd1>=5D usb_control_msg+0x172/0x196
=5B  720.548239=5D  =5B<ffffffff812be39b>=5D hub_port_init+0x348/0x71e
=5B  720.548250=5D  =5B<ffffffff812be80e>=5D usb_reset_and_verify_device+=
0x9d/0x3f0
=5B  720.548282=5D  =5B<ffffffff812c34a0>=5D ? usb_kill_urb+0x1f/0xc7
=5B  720.548295=5D  =5B<ffffffff81034cb0>=5D ? get_parent_ip+0x11/0x42
=5B  720.548308=5D  =5B<ffffffff81327812>=5D ? hid_cease_io+0x36/0x3b
=5B  720.548317=5D  =5B<ffffffff812bebfa>=5D usb_reset_device+0x99/0x11c
=5B  720.548326=5D  =5B<ffffffff8132808f>=5D ? hid_reset+0x0/0x128
=5B  720.548334=5D  =5B<ffffffff8132812a>=5D hid_reset+0x9b/0x128
=5B  720.548344=5D  =5B<ffffffff81051a48>=5D worker_thread+0x2ba/0x3e9
=5B  720.548352=5D  =5B<ffffffff810519ef>=5D ? worker_thread+0x261/0x3e9
=5B  720.548362=5D  =5B<ffffffff81056841>=5D ? autoremove_wake_function+0=
x0/0x34
=5B  720.548371=5D  =5B<ffffffff8105178e>=5D ? worker_thread+0x0/0x3e9
=5B  720.548380=5D  =5B<ffffffff81056433>=5D kthread+0x85/0x8d
=5B  720.548391=5D  =5B<ffffffff8100c41a>=5D child_rip+0xa/0x20
=5B  720.548402=5D  =5B<ffffffff8100bd80>=5D ? restore_args+0x0/0x30
=5B  720.548411=5D  =5B<ffffffff810563ae>=5D ? kthread+0x0/0x8d
=5B  720.548419=5D  =5B<ffffffff8100c410>=5D ? child_rip+0x0/0x20
=5B  720.548424=5D INFO: lockdep is turned off.
=5B  720.548455=5D INFO: task pcscd:2022 blocked for more than 120 second=
s.
=5B  720.548461=5D =22echo 0 > /proc/sys/kernel/hung_task_timeout_secs=22=
 disables this message.
=5B  720.548466=5D pcscd         D 0000000000000000  5640  2022      1 0x=
00020080
=5B  720.548480=5D  ffff880075287ae8 0000000000000046 0000000000000000 ff=
ff880002139e58
=5B  720.548494=5D  0000000000000003 0000000000000002 ffff880075287fd8 ff=
ff880075286000
=5B  720.548508=5D  ffff880075287a78 ffff880073e588e0 000000000000df88 ff=
ff880073e588e0
=5B  720.548522=5D Call Trace:
=5B  720.548533=5D  =5B<ffffffff81065fd6>=5D ? trace_hardirqs_on_caller+0=
x1f/0x145
=5B  720.548545=5D  =5B<ffffffff814a0718>=5D schedule_timeout+0x22/0xc5
=5B  720.548555=5D  =5B<ffffffff81171412>=5D ? avc_has_perm_noaudit+0x51d=
/0x546
=5B  720.548565=5D  =5B<ffffffff81065fd6>=5D ? trace_hardirqs_on_caller+0=
x1f/0x145
=5B  720.548574=5D  =5B<ffffffff814a2889>=5D ? _spin_unlock_irq+0x62/0x6f=

=5B  720.548583=5D  =5B<ffffffff814a1746>=5D __down_common+0xa7/0xe9
=5B  720.548593=5D  =5B<ffffffff814a17e7>=5D __down+0x18/0x1a
=5B  720.548601=5D  =5B<ffffffff8105ab38>=5D down+0x49/0x5d
=5B  720.548611=5D  =5B<ffffffff812cc5a1>=5D usbdev_ioctl+0x4e/0x14b0
=5B  720.548620=5D  =5B<ffffffff81171412>=5D ? avc_has_perm_noaudit+0x51d=
/0x546
=5B  720.548630=5D  =5B<ffffffff81171492>=5D ? avc_has_perm+0x57/0x69
=5B  720.548638=5D  =5B<ffffffff814a2c90>=5D ? unlock_kernel+0x98/0xa5
=5B  720.548648=5D  =5B<ffffffff81172209>=5D ? inode_has_perm+0x85/0x92
=5B  720.548659=5D  =5B<ffffffff810dd4c2>=5D vfs_ioctl+0x6a/0x82
=5B  720.548668=5D  =5B<ffffffff810dda01>=5D do_vfs_ioctl+0x4b0/0x4f6
=5B  720.548678=5D  =5B<ffffffff810dda9e>=5D sys_ioctl+0x57/0x95
=5B  720.548688=5D  =5B<ffffffff8110a817>=5D do_ioctl32_pointer+0xb/0xd
=5B  720.548697=5D  =5B<ffffffff8110cd13>=5D compat_sys_ioctl+0x437/0x4a8=

=5B  720.548705=5D  =5B<ffffffff810d8905>=5D ? path_put+0x1d/0x21
=5B  720.548714=5D  =5B<ffffffff81065374>=5D ? trace_hardirqs_off_caller+=
0x1f/0xa2
=5B  720.548724=5D  =5B<ffffffff8107d83f>=5D ? audit_syscall_entry+0xcb/0=
x19c
=5B  720.548736=5D  =5B<ffffffff8102b5f8>=5D sysenter_dispatch+0x7/0x2c
=5B  720.548745=5D  =5B<ffffffff814a1f32>=5D ? trace_hardirqs_on_thunk+0x=
3a/0x3f
=5B  720.548751=5D INFO: lockdep is turned off.

>From there, things went downhill fast (I tried to ssh in, but *that* got
hung up as well), and I ended up rebooting.


--==_Exmh_1248365208_2728P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKaIqYcC3lWbTT17ARAjpmAJ0Xb1iHMoAfK9lBMQxH7ralmmlCsgCeJa3u
R54ta4r7D/FCvdd3+/V6XQI=
=23T8
-----END PGP SIGNATURE-----

--==_Exmh_1248365208_2728P--
