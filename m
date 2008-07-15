Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbYGOALA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbYGOALA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318AbYGOAKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:10:47 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:54999 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760256AbYGOAKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:10:46 -0400
Date: Mon, 14 Jul 2008 21:10:40 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Wait for all codecs to be ready if doing a cold reset
Message-ID: <20080715001039.GA13399@vespa.holoscopio.com>
References: <20080706171548.GA9962@vespa.holoscopio.com> <s5hfxqlvec2.wl%tiwai@suse.de> <20080707173654.GA28388@vespa.holoscopio.com> <s5h1w24vfy4.wl%tiwai@suse.de> <20080708165931.GA2882@vespa.holoscopio.com> <s5hskujayfu.wl%tiwai@suse.de> <20080708173121.GA2860@vespa.holoscopio.com> <s5h63rezzlb.wl%tiwai@suse.de> <20080709172637.GA5355@vespa.holoscopio.com> <s5h8ww2r9qg.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <s5h8ww2r9qg.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2008 at 01:47:03AM +0200, Takashi Iwai wrote:
> At Wed, 9 Jul 2008 14:26:38 -0300,
> Thadeu Lima de Souza Cascardo wrote:
> >=20
> > On Wed, Jul 09, 2008 at 08:23:12PM +0200, Takashi Iwai wrote:
> > > At Tue, 8 Jul 2008 14:31:22 -0300,
> > > Thadeu Lima de Souza Cascardo wrote:
> > > >=20
> > > > On Wed, Jul 09, 2008 at 05:07:17PM +0200, Takashi Iwai wrote:
> > > > > At Tue, 8 Jul 2008 13:59:32 -0300,
> > > > > Thadeu Lima de Souza Cascardo wrote:
> > > > > >=20
> > > > > > On Tue, Jul 08, 2008 at 12:16:35PM +0200, Takashi Iwai wrote:
> > > > > > > At Mon, 7 Jul 2008 14:36:55 -0300,
> > > > > > > Thadeu Lima de Souza Cascardo wrote:
> > > > > > > >=20
> > > > > > > > On Mon, Jul 07, 2008 at 06:39:09PM +0200, Takashi Iwai wrot=
e:
> > > > > > > > > At Sun, 6 Jul 2008 14:15:56 -0300,
> > > > > > > > > Thadeu Lima de Souza Cascardo wrote:
> > > > > > > > > >=20
> > > > > > > > > > If AC97_POWER_SAVE is enabled, intel8x0 does a cold res=
et when
> > > > > > > > > > initializing the codecs. While resuming, it does not wa=
it for all codecs
> > > > > > > > > > to be active. Sound card does not work after a resume w=
ithout it,
> > > > > > > > > > however. This patch fixes it.
> > > > > > > > >=20
> > > > > > > > > Thanks for the patch.
> > > > > > > > >=20
> > > > > > > > > But, I still don't figure out why this is needed.
> > > > > > > > > In the else block (with the comment "resume phase"), you =
can find the
> > > > > > > > > loop to wait for the all *probed* codecs.  The difference=
 with the
> > > > > > > > > code you moved is that it checks only the bits correspond=
ing to the
> > > > > > > > > already probed codecs.  In other words, the other bits sh=
ould be
> > > > > > > > > irrelevant with the hardware.
> > > > > > > > >=20
> > > > > > > > > I guess it's not about the loop but the additional 1/4 se=
c delay that
> > > > > > > > > did fix the resume on your device.  Please check how is t=
he status
> > > > > > > > > bits and whether it passed the loop in the middle.
> > > > > > > > >=20
> > > > > > > > >=20
> > > > > > > > > Takashi
> > > > > > > > >=20
> > > > > > > > >=20
> > > > > > > >=20
> > > > > > > > The 1/4 sec delay came in my mind as one of the possible re=
asons, and
> > > > > > > > that's why I've made some tests. status and nstatus are 0x2=
00, while
> > > > > > > > codec_isr_bits is 0x300. The loop waits for the status regi=
ster give us
> > > > > > > > 0x300 as the active codecs, instead of the only one probed.=
 Since the
> > > > > > > > cold reset in the case of a power saving cleans up all code=
c registers,
> > > > > > > > it is needed that we wait for all codecs again (like in the=
 probe case).
> > > > > > >=20
> > > > > > > You loaded the modem driver as well?
> > > > > > > If so, what happens if you unload modem driver?
> > > > > > >=20
> > > > > > >=20
> > > > > > > thanks,
> > > > > > >=20
> > > > > > > Takashi
> > > > > > >=20
> > > > > >=20
> > > > > > The modem driver has always been loaded. Unloading it with my p=
atch
> > > > > > works OK.
> > > > >=20
> > > > > Well, I meant to unload the modem driver *without* your patch.
> > > > > That is, does it the unmodified version work if you unload the mo=
dem
> > > > > driver beforehand (e.g. adding it to blacklist)?
> > > > >=20
> > > > >=20
> > > > > thanks,
> > > > >=20
> > > > > Takashi
> > > > >=20
> > > >=20
> > > > I blacklisted snd_intel8x0m, rebooted, it was not loaded, sound wor=
ked.
> > > > Suspended, resumed, sound didn't work, as usual.
> > >=20
> > > Thanks for checking.
> > >=20
> > > I still don't understand why you need to wait for all codecs.
> > > Certainly the secondary one is the modem codec, and it has nothing to
> > > do with the audio codec...
> > >=20
> > > I don't mind to apply the patch as is since it's harmless except for
> > > the extra delay.  But, the real question is whether it's the codec
> > > probe or just another delay.
> > >=20
> > > Note that not all devices have codecs filling all slots like yours.
> > > On the later ICH, it has three slots while usually two of them are
> > > used.  So, on these hardwares, your code results always in just a 25ms
> > > delay.
> > >=20
> > > Anyway, could you give your sign-off?
> > >=20
> > >=20
> > > thanks,
> > >=20
> > > Takashi
> >=20
> >=20
> > Maybe we could treat this as a quirk in my device, which is 8086:2485?
> >=20
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
>=20
> Thanks.
>=20
> Meanwhile, I reconsidered about this problem.  I think the check of
> the whole "active" codec slots can be done better in a way like the
> following.  Could you give it a try?
>=20
> If this still doesn't work, I suspect it's really the matter of
> additional delay.
>=20

It did not work, but it is not really a matter of additional delay
either. Perhaps, when resuming, we are not doing something else. Here is
what I've done:

I printed codec_isr_bits, codec_init_bits and status when probind and
when resuming.

--
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index a282c7c..9ab8383 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2346,6 +2346,7 @@ static int snd_intel8x0_ich_chip_init(struct intel8x0=
 *chip, int probing)
 				chip->codec_isr_bits;
 		}
 		chip->codec_init_bits =3D status;
+               snd_printk ("cascardo - resume: %x %x %x\n", chip->codec_is=
r_bits, chip->codec_init_bits, status);
 	} else {
 		/* resume phase */
 		/* wait until all the probed codecs are ready */
@@ -2357,6 +2358,7 @@ static int snd_intel8x0_ich_chip_init(struct intel8x0=
 *chip, int probing)
 				break;
 			schedule_timeout_uninterruptible(1);
 		} while (time_after_eq(end_time, jiffies));
+               snd_printk ("cascardo - resume: %x %x %x\n", chip->codec_is=
r_bits, chip->codec_init_bits, status);
 	}
=20
 	if (chip->device_type =3D=3D DEVICE_SIS) {
--

Here is what I've got:

cascardo@vespa:~/code/linux/build/alsa$ dmesg | grep cascardo
[ 1835.512078] cascardo - probe: 300 200 200
[ 1848.511084] cascardo - resume: 300 200 200

Then, I've waited for codec_isr_bits, instead of codec_init_bits when
resuming, and here is what I've got.


[ 2033.909078] cascardo - probe: 300 200 200
[ 2069.692183] cascardo - resume: 300 200 300
cascardo@vespa:~/code/linux/build/alsa$


Considering that status is 0x0200 when probing, which means we spend
those HZ/4 for nothing, and the driver works, there is something the
driver should do when resuming so it could work with status 0x0200.
However, we wait for 0x0300 and we get it in less than one second.

Remember this only happens when there is a cold reset while resuming. If
not cold reseting, here is what I get:

[ 3855.656460] cascardo - probe: 300 300 300
[ 3866.633160] cascardo - resume: 300 300 300

Printing the control register the driver writes in this section of the
code:

--
@@ -2305,3 +2305,3 @@ static int snd_intel8x0_ich_chip_init(struct intel8x0=
 *chip, int probing)
        /* finish cold or do warm reset */
        cnt |=3D (cnt & ICH_AC97COLD) =3D=3D 0 ? ICH_AC97COLD : ICH_AC97WAR=
M;
        iputdword(chip, ICHREG(GLOB_CNT), cnt);
--

I've got
[ 4261.231603] cascardo - reset: 0x6
[ 4269.748091] cascardo - reset: 0x2

The first while probing (which means we do a warm reset) and the second
while resuming, which does not mean a cold reset, but finishing a cold
reset. All this is with ac97 power save enabled:

cascardo@vespa:~/code/linux/build/alsa$ cat /sys/module/snd_ac97_codec/para=
meters/power_save
Y
cascardo@vespa:~/code/linux/build/alsa$

This version I've built does not have your patch for power_save to be an
integer with the timeout in seconds. So this works as a timeout of 2
seconds. I've tried the driver with 4 seconds of timeout, without my
patch, and it didn't work either. So I don't think this timeout is
related.

So, my question is: is there any device (perhaps the later ICH) that
needs a cold reset with power_save enabled? Mine didn't and, perhaps, we
should simply remove that ifdef and do the reset as usual, which will
work out for me.

Thanks for the attention,
Thadeu Cascardo.

>=20
> thanks,
>=20
> Takashi
> ---
> diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
> index 048d99e..a282c7c 100644
> --- a/sound/pci/intel8x0.c
> +++ b/sound/pci/intel8x0.c
> @@ -404,6 +404,7 @@ struct intel8x0 {
>  	unsigned int *codec_bit;
>  	unsigned int codec_isr_bits;
>  	unsigned int codec_ready_bits;
> +	unsigned int codec_init_bits;
> =20
>  	spinlock_t reg_lock;
>  =09
> @@ -2278,7 +2279,7 @@ static void do_ali_reset(struct intel8x0 *chip)
>  static int snd_intel8x0_ich_chip_init(struct intel8x0 *chip, int probing)
>  {
>  	unsigned long end_time;
> -	unsigned int cnt, status, nstatus;
> +	unsigned int cnt, status;
>  =09
>  	/* put logic to right state */
>  	/* first clear status bits */
> @@ -2344,20 +2345,15 @@ static int snd_intel8x0_ich_chip_init(struct inte=
l8x0 *chip, int probing)
>  			status |=3D igetdword(chip, ICHREG(GLOB_STA)) &
>  				chip->codec_isr_bits;
>  		}
> -
> +		chip->codec_init_bits =3D status;
>  	} else {
>  		/* resume phase */
> -		int i;
> -		status =3D 0;
> -		for (i =3D 0; i < chip->ncodecs; i++)
> -			if (chip->ac97[i])
> -				status |=3D chip->codec_bit[chip->ac97_sdin[i]];
>  		/* wait until all the probed codecs are ready */
>  		end_time =3D jiffies + HZ;
>  		do {
> -			nstatus =3D igetdword(chip, ICHREG(GLOB_STA)) &
> +			status =3D igetdword(chip, ICHREG(GLOB_STA)) &
>  				chip->codec_isr_bits;
> -			if (status =3D=3D nstatus)
> +			if (status =3D=3D chip->codec_init_bits)
>  				break;
>  			schedule_timeout_uninterruptible(1);
>  		} while (time_after_eq(end_time, jiffies));

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh76v8ACgkQyTpryRcqtS3ChwCgiBPc9vy604u3VQuIc9B/stqi
gJkAnRGM11NQOEGiWv0FypL83IPaU7HW
=gmjm
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
