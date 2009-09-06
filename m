Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbZIFLX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbZIFLX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 07:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZIFLX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 07:23:28 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:8826 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752235AbZIFLX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 07:23:27 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: David Miller <davem@davemloft.net>, stable@kernel.org
Cc: rjw@sisk.pl, walt@holmansrus.com, kernel-testers@vger.kernel.org,
       khc@pm.waw.pl, linux-kernel@vger.kernel.org
In-Reply-To: <20090826.151153.169388217.davem@davemloft.net>
References: <828279661.71251246859811.JavaMail.root@mail.holmansrus.com>
	 <200908262312.04000.rjw@sisk.pl>
	 <20090826.151153.169388217.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0RQE40nOC8Xf3v/rpvxh"
Date: Sun, 06 Sep 2009 12:22:58 +0100
Message-Id: <1252236178.7811.28024.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [Bug #14057] Strange network timeouts w/ e100
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=J3dlmwtYxHkA:10 a=J1Y8HTJGAAAA:8 a=5yaUfDCwtmA_YLwlh94A:9 a=ANMogYAyzoeRSyGu7PYA:7 a=wd7QYUmB9gLrCIz6gyZ-zvHzhT0A:4 a=4N9Db7Z2_RYA:10 a=sKB1M3ajbwxOvQiolnkA:9 a=PkWbXo_0OcWv-m3yUHh6oXIOeYUA:4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0RQE40nOC8Xf3v/rpvxh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-26 at 15:11 -0700, David Miller wrote:=20
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Wed, 26 Aug 2009 23:12:03 +0200
>=20
> >> Krzysztof has a patch which has corrected this issue for me.  Thanks,
> >=20
> > Thanks for the update.
> >=20
> > Do you have a pointer to the patch, please?
>=20
> commit 6ff9c2e7fa8ca63a575792534b63c5092099c286
> Author: Krzysztof Ha=C5=82asa <khc@pm.waw.pl>
> Date:   Sun Aug 23 19:02:13 2009 -0700
>=20
>     E100: fix interaction with swiotlb on X86.

This fixes 303d67c2 which has been included in at least the 2.6.27.29
and 2.6.30.5 stable releases so I think this should be a candidate for
those stable branches too.

Ian.

>=20
>     E100 places it's RX packet descriptors inside skb->data and uses them
>     with bidirectional streaming DMA mapping. Data in descriptors is
>     accessed simultaneously by the chip (writing status and size when
>     a packet is received) and CPU (reading to check if the packet was
>     received). This isn't a valid usage of PCI DMA API, which requires us=
e
>     of the coherent (consistent) memory for such purpose. Unfortunately e=
100
>     chips working in "simplified" RX mode have to store received data
>     directly after the descriptor. Fixing the driver to conform to the AP=
I
>     would require using unsupported "flexible" RX mode or receiving data
>     into a coherent memory and using CPU to copy it to network buffers.
>    =20
>     This patch, while not yet making the driver conform to the PCI DMA AP=
I,
>     allows it to work correctly on X86 with swiotlb (while not breaking
>     other architectures).
>    =20
>     Signed-off-by: Krzysztof Ha=C5=82asa <khc@pm.waw.pl>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>=20
> diff --git a/drivers/net/e100.c b/drivers/net/e100.c
> index 41b648a..3a6735d 100644
> --- a/drivers/net/e100.c
> +++ b/drivers/net/e100.c
> @@ -1899,7 +1899,7 @@ static int e100_rx_indicate(struct nic *nic, struct=
 rx *rx,
>  				nic->ru_running =3D RU_SUSPENDED;
>  		pci_dma_sync_single_for_device(nic->pdev, rx->dma_addr,
>  					       sizeof(struct rfd),
> -					       PCI_DMA_BIDIRECTIONAL);
> +					       PCI_DMA_FROMDEVICE);
>  		return -ENODATA;
>  	}
> =20
> NrybX=C7=A7v^)=DE=BA{.n+{zX=DC=A8}=C6=A0z&j:+vzZ++zfh~izw?&)=DF=A2f^j=C7=
=ABym@Aa=7F0hi=7F
--=20
Ian Campbell

Q:	Why did the chicken cross the road?
A:	To see his friend Gregory peck.

Q:	Why did the chicken cross the playground?
A:	To get to the other slide.

--=-0RQE40nOC8Xf3v/rpvxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqjm5IACgkQM0+0qS9rzVm3HACgoiyLCat7BfO441pbsQNOabH2
s10An2P4RfjoXeDPvHF/8SE/8Ap+UWJm
=ienr
-----END PGP SIGNATURE-----

--=-0RQE40nOC8Xf3v/rpvxh--

