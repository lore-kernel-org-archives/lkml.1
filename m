Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbYGIR0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbYGIR0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 13:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYGIR0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 13:26:45 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:46909 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYGIR0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 13:26:44 -0400
Date: Wed, 9 Jul 2008 14:26:38 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Wait for all codecs to be ready if doing a cold reset
Message-ID: <20080709172637.GA5355@vespa.holoscopio.com>
References: <20080706171548.GA9962@vespa.holoscopio.com> <s5hfxqlvec2.wl%tiwai@suse.de> <20080707173654.GA28388@vespa.holoscopio.com> <s5h1w24vfy4.wl%tiwai@suse.de> <20080708165931.GA2882@vespa.holoscopio.com> <s5hskujayfu.wl%tiwai@suse.de> <20080708173121.GA2860@vespa.holoscopio.com> <s5h63rezzlb.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <s5h63rezzlb.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 09, 2008 at 08:23:12PM +0200, Takashi Iwai wrote:
> At Tue, 8 Jul 2008 14:31:22 -0300,
> Thadeu Lima de Souza Cascardo wrote:
> >=20
> > On Wed, Jul 09, 2008 at 05:07:17PM +0200, Takashi Iwai wrote:
> > > At Tue, 8 Jul 2008 13:59:32 -0300,
> > > Thadeu Lima de Souza Cascardo wrote:
> > > >=20
> > > > On Tue, Jul 08, 2008 at 12:16:35PM +0200, Takashi Iwai wrote:
> > > > > At Mon, 7 Jul 2008 14:36:55 -0300,
> > > > > Thadeu Lima de Souza Cascardo wrote:
> > > > > >=20
> > > > > > On Mon, Jul 07, 2008 at 06:39:09PM +0200, Takashi Iwai wrote:
> > > > > > > At Sun, 6 Jul 2008 14:15:56 -0300,
> > > > > > > Thadeu Lima de Souza Cascardo wrote:
> > > > > > > >=20
> > > > > > > > If AC97_POWER_SAVE is enabled, intel8x0 does a cold reset w=
hen
> > > > > > > > initializing the codecs. While resuming, it does not wait f=
or all codecs
> > > > > > > > to be active. Sound card does not work after a resume witho=
ut it,
> > > > > > > > however. This patch fixes it.
> > > > > > >=20
> > > > > > > Thanks for the patch.
> > > > > > >=20
> > > > > > > But, I still don't figure out why this is needed.
> > > > > > > In the else block (with the comment "resume phase"), you can =
find the
> > > > > > > loop to wait for the all *probed* codecs.  The difference wit=
h the
> > > > > > > code you moved is that it checks only the bits corresponding =
to the
> > > > > > > already probed codecs.  In other words, the other bits should=
 be
> > > > > > > irrelevant with the hardware.
> > > > > > >=20
> > > > > > > I guess it's not about the loop but the additional 1/4 sec de=
lay that
> > > > > > > did fix the resume on your device.  Please check how is the s=
tatus
> > > > > > > bits and whether it passed the loop in the middle.
> > > > > > >=20
> > > > > > >=20
> > > > > > > Takashi
> > > > > > >=20
> > > > > > >=20
> > > > > >=20
> > > > > > The 1/4 sec delay came in my mind as one of the possible reason=
s, and
> > > > > > that's why I've made some tests. status and nstatus are 0x200, =
while
> > > > > > codec_isr_bits is 0x300. The loop waits for the status register=
 give us
> > > > > > 0x300 as the active codecs, instead of the only one probed. Sin=
ce the
> > > > > > cold reset in the case of a power saving cleans up all codec re=
gisters,
> > > > > > it is needed that we wait for all codecs again (like in the pro=
be case).
> > > > >=20
> > > > > You loaded the modem driver as well?
> > > > > If so, what happens if you unload modem driver?
> > > > >=20
> > > > >=20
> > > > > thanks,
> > > > >=20
> > > > > Takashi
> > > > >=20
> > > >=20
> > > > The modem driver has always been loaded. Unloading it with my patch
> > > > works OK.
> > >=20
> > > Well, I meant to unload the modem driver *without* your patch.
> > > That is, does it the unmodified version work if you unload the modem
> > > driver beforehand (e.g. adding it to blacklist)?
> > >=20
> > >=20
> > > thanks,
> > >=20
> > > Takashi
> > >=20
> >=20
> > I blacklisted snd_intel8x0m, rebooted, it was not loaded, sound worked.
> > Suspended, resumed, sound didn't work, as usual.
>=20
> Thanks for checking.
>=20
> I still don't understand why you need to wait for all codecs.
> Certainly the secondary one is the modem codec, and it has nothing to
> do with the audio codec...
>=20
> I don't mind to apply the patch as is since it's harmless except for
> the extra delay.  But, the real question is whether it's the codec
> probe or just another delay.
>=20
> Note that not all devices have codecs filling all slots like yours.
> On the later ICH, it has three slots while usually two of them are
> used.  So, on these hardwares, your code results always in just a 25ms
> delay.
>=20
> Anyway, could you give your sign-off?
>=20
>=20
> thanks,
>=20
> Takashi


Maybe we could treat this as a quirk in my device, which is 8086:2485?

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh09M0ACgkQyTpryRcqtS0vJwCghfdPqq0lgYwc829VqlyEahE0
ZPcAnRgSukPjTYpRCPP42pGtdpNThySQ
=zs7Y
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
