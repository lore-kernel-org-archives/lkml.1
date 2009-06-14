Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbZFNSTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbZFNSTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 14:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZFNSTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 14:19:41 -0400
Received: from mx73.mail.ru ([94.100.176.87]:43025 "EHLO mx45.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752885AbZFNSTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 14:19:40 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: hal@lists.freedesktop.org
Subject: 2.6.30: hald crashes on resume from STR apparently on LED device
Date: Sun, 14 Jun 2009 22:19:02 +0400
User-Agent: KMail/1.11.90 (Linux/2.6.30-desktop-1mnb; KDE/4.2.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1618156.Qu4h5okp3R";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906142219.06891.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1618156.Qu4h5okp3R
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I did not experience this crash under 2.6.29. I got it under 2.6.30=20
(both rc and final) with varying frequency. At least for me it is 2.6.30=20
regression.

hald aborts on D-Bus assertion with stack trace below.Program received=20
signal SIGABRT, Aborted.
0x00007f183ff9e915 in raise (sig=3D<value optimized out>) at=20
=2E./nptl/sysdeps/unix/sysv/linux/raise.c:64
64	  return INLINE_SYSCALL (tgkill, 3, pid, selftid, sig);
(gdb) bt
#0  0x00007f183ff9e915 in raise (sig=3D<value optimized out>) at=20
=2E./nptl/sysdeps/unix/sysv/linux/raise.c:64
#1  0x00007f183ff9ff8a in abort () at abort.c:88
#2  0x00007f1840793f35 in _dbus_abort () at dbus-sysdeps.c:88
#3  0x00007f184078fd6d in _dbus_warn_check_failed (
    format=3D0x7f184079c5a0 "arguments to %s() were incorrect, assertion=20
\"%s\" failed in file %s line %d.\nThis is normally a bug in some=20
application using the D-Bus library.\n") at dbus-internals.c:283
#4  0x00007f18407873f9 in dbus_pending_call_set_notify (pending=3D0x0,=20
function=3D0x41b320 <reply_from_singleton_device_changed>,=20
    user_data=3D0xc74c30, free_user_data=3D0x416000 <del_sdci>) at dbus-
pending-call.c:598
#5  0x0000000000415f6e in singleton_signal_device_changed=20
(connection=3D0xbdc140, device=3D0x7f18411af2c0, added=3D1)
    at hald_dbus.c:3481
#6  0x0000000000419fe2 in hald_singleton_device_added=20
(command_line=3D0xc601e0 "hald-addon-leds", device=3D0x7f18411af2c0)
    at hald_dbus.c:3570
#7  0x0000000000413e5f in gdl_store_changed (store=3D<value optimized=20
out>, device=3D0x7f18411af2c0,=20
    is_added=3D<value optimized out>, user_data=3D<value optimized out>) at=
=20
hald.c:134
#8  0x00007f1840c78bae in IA__g_closure_invoke (closure=3D0xbcba10,=20
return_value=3D0x0, n_param_values=3D3, param_values=3D0xc914a0,=20
    invocation_hint=3D0x7fff3cac7d20) at gclosure.c:767
#9  0x00007f1840c8f108 in signal_emit_unlocked_R (node=3D0xbca8a0,=20
detail=3D<value optimized out>, instance=3D<value optimized out>,=20
    emission_return=3D<value optimized out>, instance_and_params=3D<value=20
optimized out>) at gsignal.c:3247
#10 0x00007f1840c9059e in IA__g_signal_emit_valist (instance=3D0xbbd600,=20
signal_id=3D<value optimized out>, detail=3D0,=20
    var_args=3D0x7fff3cac7f10) at gsignal.c:2980
#11 0x00007f1840c90b33 in IA__g_signal_emit (instance=3D0xbc7,=20
signal_id=3D3015, detail=3D6) at gsignal.c:3037
#12 0x0000000000411d01 in hal_device_store_add (store=3D0xbbd600,=20
device=3D0x7f18411af2c0) at device_store.c:277
#13 0x0000000000430d72 in dev_callouts_add_done (d=3D0x7f18411af2c0,=20
userdata1=3D0xc6ee20, userdata2=3D<value optimized out>)
    at device.c:4666
#14 0x00000000004086c4 in hal_util_callout_device_add (d=3D0x7f18411af2c0,=
=20
callback=3D0x430d10 <dev_callouts_add_done>,=20
    userdata1=3D0xc6ee20, userdata2=3D0x0) at util.c:996
#15 0x0000000000408524 in hal_util_callout_device_preprobe=20
(d=3D0x7f18411af2c0,=20
    callback=3D0x4310e0 <dev_callouts_preprobing_done>,=20
userdata1=3D0xc6ee20, userdata2=3D0x657fa0) at util.c:1035
#16 0x0000000000425394 in hotplug_event_begin_sysfs=20
(hotplug_event=3D0xc6ee20) at hotplug.c:172
#17 0x00000000004257a8 in hotplug_event_process_queue () at=20
hotplug.c:295
#18 0x00000000004242b7 in hald_udev_data (source=3D<value optimized out>,=20
condition=3D<value optimized out>,=20
    user_data=3D<value optimized out>) at osspec.c:259
#19 0x00007f18409e1a4e in IA__g_main_context_dispatch (context=3D0xbc0320)=
=20
at gmain.c:1814
#20 0x00007f18409e51b8 in g_main_context_iterate (context=3D0xbc0320,=20
block=3D<value optimized out>,=20
    dispatch=3D<value optimized out>, self=3D<value optimized out>) at=20
gmain.c:2445
#21 0x00007f18409e5645 in IA__g_main_loop_run (loop=3D0xbbcc20) at=20
gmain.c:2653
#22 0x00000000004133ed in main (argc=3D<value optimized out>,=20
argv=3D0x7fff3cac9b50) at hald.c:821


Appearance of hald-addon-leds may be red herring; still here is the only=20
led device I have (for Intel 3946ABG).

udi =3D '/org/freedesktop/Hal/devices/leds_iwl_phy0_radio'
  info.addons.singleton =3D {'hald-addon-leds'} (string list)
  info.capabilities =3D {'leds'} (string list)
  info.category =3D 'leds'  (string)
  info.interfaces =3D {'org.freedesktop.Hal.Device.Leds'} (string list)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_8086_4222'  (string)
  info.subsystem =3D 'leds'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/leds_iwl_phy0_radio' =20
(string)
  leds.device_name =3D 'iwl-phy0'  (string)
  leds.function =3D 'radio'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'leds'  (string)
  linux.sysfs_path =3D=20
'/sys/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/leds/iwl-phy0::radio' =20
(string)


 This is Dell XPS M1330 notebook. I am ready to provide any required=20
information; so far crash is reproducible after several suspend/resume=20
cycles.=20

--nextPart1618156.Qu4h5okp3R
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAko1PxYACgkQR6LMutpd94x0dgCguLWoDbarvOUXlPMEZeo3sRWN
GwMAoIJPqacp72glJUp5sV7ZOVWKlUlI
=RKZ2
-----END PGP SIGNATURE-----

--nextPart1618156.Qu4h5okp3R--
