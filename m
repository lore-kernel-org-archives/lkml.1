Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYIZPNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYIZPNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 11:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYIZPNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 11:13:15 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:53495 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYIZPNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 11:13:14 -0400
Subject: Re: bad DMAR interaction with iwlagn and SATA
From: Johannes Berg <johannes@sipsolutions.net>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andres Freund <andres@anarazel.de>,
       linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <20080926144708.GD9118@il.ibm.com>
References: <200809251511.20132.andres@anarazel.de>
	 <48DC44D4.8000103@garzik.org> <200809260419.07713.andres@anarazel.de>
	 <48DC4BC0.7090203@garzik.org>  <20080926144708.GD9118@il.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HyPdWJDP5lvgMzLqdLta"
Date: Fri, 26 Sep 2008 17:12:35 +0200
Message-Id: <1222441955.3798.13.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HyPdWJDP5lvgMzLqdLta
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-26 at 17:47 +0300, Muli Ben-Yehuda wrote:

> The way to debug this is to figure out why device 00:1f.2 is trying to
> read from DMA address fffbf000 and does not have permission to do
> so. This could be indicative of a driver bug where it is programming
> the device to read from some buffer that has not been allocated
> through the DMA API and thus does not have a valid IOMMU mapping, or a
> hardware quirk where the device tries to read from memory without host
> involvement. The former is much more likely.

The same is probably true for the iwlagn case which was

> [ 4184.617392] DMAR:[DMA Read] Request device [03:00.0] fault addr fa9460=
00=20
> [ 4184.617393] DMAR:[fault reason 06] PTE Read access is not set
> [ 4184.644081] iwlagn: Microcode HW error detected.  Restarting.

and indeed matches experience from myself and Marcel that DMA bugs seem
to lurk.

johannes

--=-HyPdWJDP5lvgMzLqdLta
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3PveAAoJEKVg1VMiehFYliUQAMZWXb06JFNOqEhMXbHF9a2O
QX3ZFwyz6IiEC/deb6U0uh/Zz5shxecXDOwcUfoq8EDvYZup4DQGE56dreyVxKJM
wlI27g9d6FAzqNjxmpyK0wuiAdLlmwwRbuYg9fklM06dF2shVesEjKFCDxBo8oxk
9PxVhkiCafq3+v1Qyew75ihRgA1in2fGHFW1fwgMX6wa4+1xPoPY+twRkdGvwwNe
S0J+/6WsaKRIiVRgqftvUZLlkTbXuFEphfGNvjTfwI2Cq/FuwUBJ+6JbI/yCBNN7
9f+8PEG9a2UxYqWu/9dHz9i/JNfKkmy8eRKrYn+2wg6bE8jsmiWAZvjvMYbs4XPc
RTJtgjJs+/vskVGOqiqbDVaEDPtcu3zvf6+g3BuPp7o75jg/j2BIdhQblIuS0ACF
LWCrbsoS2diToj4uiiHWw5/9iJkRbc1fNSlVT/SnTRa8jMUF9M/A2gCwZAnNUM9R
2jdj2dUbdUXJMVArqvNjpPHnkndTD1vDmhqbt0Uc8kGmjDVMdJwFatwGxViEruBy
iRNVqAbcrygVWrdeLT85mUZaeMc/J6qL7UWuRoXHxIgpl4+4xbaIv9esXcHFaLJl
wLF9y6QD2VZDHG3bLoQ11WAZktdSSPgrVrD1od/eKwR4C6QlUhRRHMa63QDt2o3f
PnCs1xYVQow/laFhpIV7
=O7VO
-----END PGP SIGNATURE-----

--=-HyPdWJDP5lvgMzLqdLta--

