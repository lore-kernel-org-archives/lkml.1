Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbYF1SOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbYF1SOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 14:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYF1SO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 14:14:29 -0400
Received: from naru.obs2.net ([84.20.150.76]:53001 "EHLO narury.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbYF1SO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 14:14:28 -0400
X-Greylist: delayed 1321 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jun 2008 14:14:28 EDT
Date: Sat, 28 Jun 2008 20:52:25 +0300
From: Riku Voipio <riku.voipio@iki.fi>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       buytenh@wantstofly.org
Subject: Re: LEDs: how to handle gpios that control brightness for all LEDs
Message-ID: <20080628175225.GA32176@kos.to>
References: <20080628153109.GA20215@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20080628153109.GA20215@deprecation.cyrius.com>
X-message-flag: Warning: message not sent with a DRM-Certified client
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 28, 2008 at 05:31:09PM +0200, Martin Michlmayr wrote:
> I have a device that has various gpios that correspond to the colours
> (blue, red) of various LEDs.  They only accept 0/1, not the actual
> brightness.  However, there are two other gpios that can be used to
> control the brightness (of all LEDs): gpio V_LED 5V is bright, gpio
> V_LED 3.3V is dimmed and if neither of these two gpios are set, all
> LEDs stay off.

> Can I simply export these brightness gpios to userland or would it be
> better to handle the brightness setting in the kernel so that setting
> e.g. 100 to a LED would automatically set the V_LED 3.3V gpio and 255
> would set V_LED 5V.  If so, how should this be done?

There is a enum led_brightness, which defines LED_HALF and LED_FULL. You
would need a custom brightness function. Leds-gpio driver would need to
be extended for it. The main problem with this approach is the
unexpected effect for enduser, that adjusting brighntess of one led
affects all of them.

> Second, the LEDS class sets all gpios to off by default.  This is bad
> in my case because if neither of the brightness gpios (3.3V or 5V) are
> on, the SATA lights won't be shown either.  Is there a way to specify
> in the platform code that one gpio should be turned on by default?

default-on trigger is probably the easiest way.

--=20
"rm -rf" only sounds scary if you don't have backups

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIZnpZibPvMsrqrwMRAhf1AKDHGkUmVnxCyyAVvHxXACdFfRvYywCgkp6N
pGYdrBNOYnwyNytgmfqJ/Ic=
=ikvf
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
