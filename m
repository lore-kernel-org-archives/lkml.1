Return-Path: <linux-kernel-owner+w=401wt.eu-S1759787AbXE0WQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787AbXE0WQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 18:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbXE0WQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 18:16:25 -0400
Received: from daemonizer.de ([87.230.16.230]:52706 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbXE0WQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 18:16:24 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Mon, 28 May 2007 00:15:59 +0200
User-Agent: KMail/1.9.7
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705272125.25506.maxi@daemonizer.de> <200705272313.33129.mb@bu3sch.de>
In-Reply-To: <200705272313.33129.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1256911.S444X9Ocex";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705280016.02776.maxi@daemonizer.de>
X-Spam-Score: -4.1 (----)
X-Spam-Report: No, hits=-4.1 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.1.7-deb 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.3 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1256911.S444X9Ocex
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 27 May 2007, Michael Buesch wrote:
> On Sunday 27 May 2007 21:25:17 Maximilian Engelhardt wrote:
> > 2.6.21.1:
> > [  5] local 192.168.1.2 port 58414 connected with 192.168.1.1 port 5001
> > [  5]  0.0-60.6 sec  1.13 MBytes    157 Kbits/sec
> > [  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 57837
> > [  4]  0.0-63.1 sec  2.82 MBytes    375 Kbits/sec
> >
> > 2.6.22-rc3:
> > [  5] local 192.168.1.2 port 46557 connected with 192.168.1.1 port 5001
> > [  5]  0.0-60.4 sec  58.9 MBytes  8.18 Mbits/sec
> > [  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 51633
> > [  4]  0.0-63.1 sec  7.27 MBytes    967 Kbits/sec
>
> This is the diff between these two kernels.
> I'm not sure why you see a much better TX throughput here.
>
> Can you re-check to make sure it's not just some test-jitter?
>
2.6.21.1:

[  5] local 192.168.1.2 port 54423 connected with 192.168.1.1 port 5001
[  5]  0.0-60.3 sec  3.06 MBytes    426 Kbits/sec
[  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 41053
[  4]  0.0-163.0 sec    130 MBytes  6.67 Mbits/sec


2.6.22-rc3:

[  5] local 192.168.1.2 port 46002 connected with 192.168.1.1 port 5001
[  5]  0.0-61.5 sec  84.0 MBytes  11.5 Mbits/sec
[  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 44379
[  4]  0.0-93.8 sec  30.6 MBytes  2.74 Mbits/sec

=46or TX the iperf server reports the same values as the client (all values=
 are=20
from the client) but for RX they are differen:

2.6.21.1: (iperf server log):

[  5] local 192.168.1.1 port 5001 connected with 192.168.1.2 port 54423
[  5]  0.0-60.5 sec  3.06 MBytes    425 Kbits/sec
[  5] local 192.168.1.1 port 41053 connected with 192.168.1.2 port 5001
[  5]  0.0-63.1 sec    130 MBytes  17.2 Mbits/sec


2.6.22-rc3 (iperf server log):

[  4] local 192.168.1.1 port 5001 connected with 192.168.1.2 port 46002
[  4]  0.0-61.6 sec  84.0 MBytes  11.5 Mbits/sec
[  4] local 192.168.1.1 port 44379 connected with 192.168.1.2 port 5001
[  4]  0.0-63.3 sec  30.6 MBytes  4.06 Mbits/sec

I have no idea how iperf internally works and what can cause such different=
=20
results here.

>
> --- linux-2.6.21.1/drivers/net/b44.c    2007-05-27 22:58:01.000000000 +02=
00
> +++ linux-2.6.22-rc3/drivers/net/b44.c  2007-05-27 23:01:44.000000000 +02=
00
> @@ -825,12 +825,11 @@
>                         if (copy_skb =3D=3D NULL)
>                                 goto drop_it_no_recycle;
>
> -                       copy_skb->dev =3D bp->dev;
>                         skb_reserve(copy_skb, 2);
>                         skb_put(copy_skb, len);
>                         /* DMA sync done above, copy just the actual pack=
et
> */ -                       memcpy(copy_skb->data, skb->data+bp->rx_offset,
> len); -
> +                       skb_copy_from_linear_data_offset(skb,
> bp->rx_offset, +                                                      =20
> copy_skb->data, len); skb =3D copy_skb;
>                 }
>                 skb->ip_summed =3D CHECKSUM_NONE;
> @@ -1007,7 +1006,8 @@
>                         goto err_out;
>                 }
>
> -               memcpy(skb_put(bounce_skb, len), skb->data, skb->len);
> +               skb_copy_from_linear_data(skb, skb_put(bounce_skb, len),
> +                                         skb->len);
>                 dev_kfree_skb_any(skb);
>                 skb =3D bounce_skb;
>         }



--nextPart1256911.S444X9Ocex
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWgMiOimwv528XGERAjsHAKDR1KjfwQMgZRyMFZcGuwbHbaxJcQCgtMPZ
RX0ulE+gPKEVDo3hgfqfA6U=
=uMCj
-----END PGP SIGNATURE-----

--nextPart1256911.S444X9Ocex--
