Return-Path: <linux-kernel-owner+w=401wt.eu-S1759672AbYHNOEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672AbYHNOEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYHNOEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 10:04:34 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:10569 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbYHNOEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 10:04:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAOfYo0jCTsYx/2dsb2JhbACBYrRHgVU
From: Laurent Pinchart <laurentp@cse-semaphore.com>
Organization: CSE Semaphore
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/3] gpiolib: make gpio_to_chip() public
Date: Thu, 14 Aug 2008 16:04:18 +0200
User-Agent: KMail/1.9.9
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       "Greg Kroah-Hartman" <greg@kroah.com>, linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Li Yang <leoli@freescale.com>, linux-kernel@vger.kernel.org,
       Timur Tabi <timur@freescale.com>
References: <20080808161717.GA19095@polina.dev.rtsoft.ru> <20080808161813.GA31258@polina.dev.rtsoft.ru>
In-Reply-To: <20080808161813.GA31258@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart14178632.D6J4HNaLpq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808141604.22287.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart14178632.D6J4HNaLpq
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 08 August 2008, Anton Vorontsov wrote:
> We'll need this function to write platform-specific hooks to deal
> with pin's dedicated functions. Quite obviously this will work only
> for the platforms with 1-to-1 GPIO to PIN mapping.
>=20
> This is stopgap solution till we think out and implement a proper
> api (pinlib?).

How do you support reverting the GPIO mode to non-dedicated ?

> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/gpio/gpiolib.c     |    3 ++-
>  include/asm-generic/gpio.h |    1 +
>  2 files changed, 3 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 8d29405..9536fa8 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -81,10 +81,11 @@ static void gpio_ensure_requested(struct gpio_desc *d=
esc)
>  }
> =20
>  /* caller holds gpio_lock *OR* gpio is marked as requested */
> -static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
> +struct gpio_chip *gpio_to_chip(unsigned gpio)
>  {
>  	return gpio_desc[gpio].chip;
>  }
> +EXPORT_SYMBOL_GPL(gpio_to_chip);
> =20
>  /* dynamic allocation of GPIOs, e.g. on a hotplugged device */
>  static int gpiochip_find_base(int ngpio)
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 0f99ad3..d70ee45 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -81,6 +81,7 @@ struct gpio_chip {
>  	unsigned		exported:1;
>  };
> =20
> +extern struct gpio_chip *gpio_to_chip(unsigned gpio);
>  extern const char *gpiochip_is_requested(struct gpio_chip *chip,
>  			unsigned offset);
>  extern int __must_check gpiochip_reserve(int start, int ngpio);

=2D-=20
Laurent Pinchart
CSE Semaphore Belgium

Chaussee de Bruxelles, 732A
B-1410 Waterloo
Belgium

T +32 (2) 387 42 59
=46 +32 (2) 387 42 75

--nextPart14178632.D6J4HNaLpq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkikO2YACgkQ8y9gWxC9vpeFqACfUmwTi5QVu4AJLF+iGhKf0sV9
mYUAoIPsIbJU5uMo53u8Ag0W0aHjJuKA
=k6H2
-----END PGP SIGNATURE-----

--nextPart14178632.D6J4HNaLpq--
