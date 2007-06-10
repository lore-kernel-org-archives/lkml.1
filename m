Return-Path: <linux-kernel-owner+w=401wt.eu-S1762679AbXFJID3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762679AbXFJID3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 04:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761403AbXFJIDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 04:03:12 -0400
Received: from mx34.mail.ru ([194.67.23.200]:14701 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760433AbXFJIDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 04:03:09 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Sun, 10 Jun 2007 12:03:03 +0400
User-Agent: KMail/1.9.7
Cc: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       "Samuel Ortiz" <samuel@sortiz.org>, linux-kernel@vger.kernel.org,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706070045.14040.arvidjaar@mail.ru> <200706071234.47517.bjorn.helgaas@hp.com>
In-Reply-To: <200706071234.47517.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12707956.tFO8Z8YbbB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706101203.04649.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart12707956.tFO8Z8YbbB
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 07 June 2007, Bjorn Helgaas wrote:
> On Wednesday 06 June 2007 02:45:01 pm Andrey Borzenkov wrote:
> > I am beginning to doubt whether drier
> > works on my system at all (i.e. before PnP change); have to find time to
> > test.
>
> In 2.6.21, smsc-ircc2 at least found the device.  So we definitely have
> a problem because in 2.6.22-rc, we don't find the device.
>
> What laptop do you have?  Maybe I can find one to play with.
>
> I think Windows always calls _SRS, even if it doesn't need to change
> the current resource settings.  Linux doesn't do that, and my HP nw8240
> firmware has a bug that leaves the IR device partly-enabled until _SRS
> is called.  Maybe yours has a similar bug.
>
> Can you set CONFIG_ACPI_DEBUG=3Dy, make it so smsc-ircc2 isn't loaded
> automatically, and try this (along with my previous patch to swap
> FIR and SIR):
>
>   # dmesg -n 8
>   # echo 0x200 > /sys/module/acpi/parameters/debug_level
>   # echo disable > /sys/bus/pnp/devices/00:0a/resources
>   # echo activate > /sys/bus/pnp/devices/00:0a/resources
>   # modprobe smsc-ircc2
>
> If you try this, can you collect the whole dmesg log?
>

well, dmesg (/var/log/messages) is around 35MB :) Even bz2 compressed it is=
=20
over 700KB. I put it here:=20
http://dump.ru:80/loadfile.php?filename=3Dfir_acpi_debug.bz2&id=3D379192=20

This is from /var/log/messages. I do not have serial console and cannot=20
capture output directly; I can only hope nothing is lost at this rate.

> It's also possible that some other driver like i2c is messing with
> the ISA/LPC bridge configuration and breaking the IR device config.
> Your lspnp output doesn't show any other ISA devices down there,
> but I know i2c likes to poke around and discover things that kinda,
> sorta work, but the BIOS didn't expose.
>
> Bjorn



--nextPart12707956.tFO8Z8YbbB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGa7A4R6LMutpd94wRAnbHAJoDo1eQXSQ7gKl1hp1OkX4m71kqFQCgr4LT
PAy8bfiWMCdVxVnbtZAXR5U=
=MC7z
-----END PGP SIGNATURE-----

--nextPart12707956.tFO8Z8YbbB--
