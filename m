Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbYKPI3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbYKPI3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 03:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYKPI3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 03:29:13 -0500
Received: from mx30.mail.ru ([194.67.23.238]:24268 "EHLO mx30.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbYKPI3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 03:29:11 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>, linux-acpi@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] ACPI toshiba: only register rfkill if bt is enabled
Date: Sun, 16 Nov 2008 11:28:58 +0300
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, philipl@overt.org
References: <20081029081934.GB26314@gambetta>
In-Reply-To: <20081029081934.GB26314@gambetta>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1318726.bFehqVtMlN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811161129.02028.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1318726.bFehqVtMlN
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 29 October 2008, Frederik Deweerdt wrote:
> [resending as it didn't make it to the list, removing netdev from cc
> also]
> Hello  Andrey,
>=20
> It looks like a part of the rfkill initialization was done whenever
> BT was on or not. The following patch checks for BT presence before
> registering the rfkill to the input layer. Does it solve the problem for
> you?
>=20

This patch fixes regression in 2.6.28. Patch has been tested and
acnowledged. Rafael, could you add it to list of open regressions?
Thank you!

> Regards,
> Frederik
>=20
> Register toshiba RFKill Switch only if bluetooth is enabled
>=20
> Part of the rfkill initialization was done whenever BT was on or not. The
> following patch checks for BT presence before registering the rfkill to
> the input layer. Some minor cleanups (> 80 char lines) were also added
> in the process.
>=20
> On Tue, Oct 28, 2008 at 10:10:37PM +0300, Andrey Borzenkov wrote:
> [...]
> > [   66.633036] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
> > [   66.633054] toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
> > [   66.637764] input: Toshiba RFKill Switch as /devices/virtual/input/i=
nput3
> [...]
> > [  113.920753] ------------[ cut here ]------------
> > [  113.920828] kernel BUG at /home/bor/src/linux-git/net/rfkill/rfkill.=
c:347!
> > [  113.920845] invalid opcode: 0000 [#1]=20
> > [  113.920877] last sysfs file: /sys/devices/pci0000:00/0000:00:04.0/ho=
st0/target0:0:0/0:0:0:0/block/sda/size
> > [  113.920900] Dumping ftrace buffer:
> > [  113.920919]    (ftrace buffer empty)
> > [  113.920933] Modules linked in: af_packet irnet ppp_generic slhc irco=
mm_tty ircomm binfmt_misc loop dm_mirror dm_region_hash dm_log dm_round_rob=
in dm_multipath dm_mod alim15x3 ide_core nvram toshiba cryptomgr aead crypt=
o_blkcipher michael_mic crypto_algapi orinoco_cs orinoco hermes_dld hermes =
pcmcia firmware_class snd_ali5451 snd_ac97_codec ac97_bus snd_seq_dummy snd=
_seq_oss snd_seq_midi_event snd_seq snd_seq_device smsc_ircc2 snd_pcm_oss s=
nd_pcm rtc_cmos irda snd_timer snd_mixer_oss rtc_core snd crc_ccitt yenta_s=
ocket rtc_lib rsrc_nonstatic i2c_ali1535 pcmcia_core pcspkr psmouse soundco=
re i2c_core evdev sr_mod snd_page_alloc alim1535_wdt cdrom fan sg video out=
put toshiba_acpi rfkill thermal backlight ali_agp processor ac button input=
_polldev battery agpgart ohci_hcd usbcore reiserfs pata_ali libata sd_mod s=
csi_mod [last unloaded: scsi_wait_scan]
> > [  113.921765]=20
> > [  113.921785] Pid: 3272, comm: ipolldevd Not tainted (2.6.28-rc2-1avb =
#3) PORTEGE 4000
> > [  113.921801] EIP: 0060:[<dfaa4683>] EFLAGS: 00010246 CPU: 0
> > [  113.921854] EIP is at rfkill_force_state+0x53/0x90 [rfkill]
> > [  113.921870] EAX: 00000000 EBX: 00000000 ECX: 00000003 EDX: 00000000
> > [  113.921885] ESI: 00000000 EDI: ddd50300 EBP: d8d7af40 ESP: d8d7af24
> > [  113.921900]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> > [  113.921918] Process ipolldevd (pid: 3272, ti=3Dd8d7a000 task=3Dd8d93=
c90 task.ti=3Dd8d7a000)
> > [  113.921933] Stack:
> > [  113.921945]  d8d7af38 00000246 dfb029d8 dfb029c0 dfb029d8 dfb029c0 d=
dd50300 d8d7af5c
> > [  113.922014]  dfb018e2 01000246 01000000 ddd50300 ddd50314 ddabb8a0 d=
8d7af68 dfb381c1
> > [  113.922098]  00000000 d8d7afa4 c012ec0a 00000000 00000002 00000000 c=
012eba8 ddabb8c0
> > [  113.922240] Call Trace:
> > [  113.922240]  [<dfb018e2>] ? bt_poll_rfkill+0x5c/0x82 [toshiba_acpi]
> > [  113.922240]  [<dfb381c1>] ? input_polled_device_work+0x11/0x40 [inpu=
t_polldev]
> > [  113.922240]  [<c012ec0a>] ? run_workqueue+0xea/0x1f0
> > [  113.922240]  [<c012eba8>] ? run_workqueue+0x88/0x1f0
> > [  113.922240]  [<dfb381b0>] ? input_polled_device_work+0x0/0x40 [input=
_polldev]
> > [  113.922240]  [<c012f047>] ? worker_thread+0x87/0xf0
> > [  113.922240]  [<c0132b00>] ? autoremove_wake_function+0x0/0x50
> > [  113.922240]  [<c012efc0>] ? worker_thread+0x0/0xf0
> > [  113.922240]  [<c013280f>] ? kthread+0x3f/0x80
> > [  113.922240]  [<c01327d0>] ? kthread+0x0/0x80
> > [  113.922240]  [<c01040d7>] ? kernel_thread_helper+0x7/0x10
> > [  113.922240] Code: 43 54 89 73 54 39 c6 74 11 89 d9 ba 01 00 00 00 b8=
 40 68 aa df e8 3e 35 69 e0 89 f8 e8 77 fd 85 e0 31 c0 83 c4 10 5b 5e 5f 5d=
 c3 <0f> 0b eb fe 89 f6 8d bc 27 00 00 00 00 be f4 4d aa df bb 5f 01=20
> > [  113.922240] EIP: [<dfaa4683>] rfkill_force_state+0x53/0x90 [rfkill] =
SS:ESP 0068:d8d7af24
> > [  113.924700] ---[ end trace 0e404eb40cadd5f0 ]---
>=20
> Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
>=20
> diff --git a/drivers/acpi/toshiba_acpi.c b/drivers/acpi/toshiba_acpi.c
> index 66aac06..c1c9d87 100644
> --- a/drivers/acpi/toshiba_acpi.c
> +++ b/drivers/acpi/toshiba_acpi.c
> @@ -824,34 +824,38 @@ static int __init toshiba_acpi_init(void)
>  			toshiba_acpi_exit();
>  			return -ENOMEM;
>  		}
> -	}
> =20
> -	/* Register input device for kill switch */
> -	toshiba_acpi.poll_dev =3D input_allocate_polled_device();
> -	if (!toshiba_acpi.poll_dev) {
> -		printk(MY_ERR "unable to allocate kill-switch input device\n");
> -		toshiba_acpi_exit();
> -		return -ENOMEM;
> -	}
> -	toshiba_acpi.poll_dev->private =3D &toshiba_acpi;
> -	toshiba_acpi.poll_dev->poll =3D bt_poll_rfkill;
> -	toshiba_acpi.poll_dev->poll_interval =3D 1000; /* msecs */
> -
> -	toshiba_acpi.poll_dev->input->name =3D toshiba_acpi.rfk_name;
> -	toshiba_acpi.poll_dev->input->id.bustype =3D BUS_HOST;
> -	toshiba_acpi.poll_dev->input->id.vendor =3D 0x0930; /* Toshiba USB ID */
> -	set_bit(EV_SW, toshiba_acpi.poll_dev->input->evbit);
> -	set_bit(SW_RFKILL_ALL, toshiba_acpi.poll_dev->input->swbit);
> -	input_report_switch(toshiba_acpi.poll_dev->input, SW_RFKILL_ALL, TRUE);
> -	input_sync(toshiba_acpi.poll_dev->input);
> -
> -	ret =3D input_register_polled_device(toshiba_acpi.poll_dev);
> -	if (ret) {
> -		printk(MY_ERR "unable to register kill-switch input device\n");
> -		rfkill_free(toshiba_acpi.rfk_dev);
> -		toshiba_acpi.rfk_dev =3D NULL;
> -		toshiba_acpi_exit();
> -		return ret;
> +		/* Register input device for kill switch */
> +		toshiba_acpi.poll_dev =3D input_allocate_polled_device();
> +		if (!toshiba_acpi.poll_dev) {
> +			printk(MY_ERR
> +			       "unable to allocate kill-switch input device\n");
> +			toshiba_acpi_exit();
> +			return -ENOMEM;
> +		}
> +		toshiba_acpi.poll_dev->private =3D &toshiba_acpi;
> +		toshiba_acpi.poll_dev->poll =3D bt_poll_rfkill;
> +		toshiba_acpi.poll_dev->poll_interval =3D 1000; /* msecs */
> +
> +		toshiba_acpi.poll_dev->input->name =3D toshiba_acpi.rfk_name;
> +		toshiba_acpi.poll_dev->input->id.bustype =3D BUS_HOST;
> +		/* Toshiba USB ID */
> +		toshiba_acpi.poll_dev->input->id.vendor =3D 0x0930;
> +		set_bit(EV_SW, toshiba_acpi.poll_dev->input->evbit);
> +		set_bit(SW_RFKILL_ALL, toshiba_acpi.poll_dev->input->swbit);
> +		input_report_switch(toshiba_acpi.poll_dev->input,
> +				    SW_RFKILL_ALL, TRUE);
> +		input_sync(toshiba_acpi.poll_dev->input);
> +
> +		ret =3D input_register_polled_device(toshiba_acpi.poll_dev);
> +		if (ret) {
> +			printk(MY_ERR
> +			       "unable to register kill-switch input device\n");
> +			rfkill_free(toshiba_acpi.rfk_dev);
> +			toshiba_acpi.rfk_dev =3D NULL;
> +			toshiba_acpi_exit();
> +			return ret;
> +		}
>  	}
> =20
>  	return 0;
>=20
> ----- End forwarded message -----
>=20
>=20



--nextPart1318726.bFehqVtMlN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkf2c0ACgkQR6LMutpd94yxgQCbBEtKK6Pdvu1LQgBavHDe9X3z
HPIAnA/WXJXSfcgetgUeeVvsl7errTEP
=qqym
-----END PGP SIGNATURE-----

--nextPart1318726.bFehqVtMlN--
