Return-Path: <linux-kernel-owner+w=401wt.eu-S1030855AbXCHW4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030855AbXCHW4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030851AbXCHW4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:56:10 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:32981 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030855AbXCHW4I (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:56:08 -0500
Message-Id: <200703082255.l28MtkE8030073@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: David Howells <dhowells@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, hch@infradead.org, arjan@infradead.org
Subject: Re: [PATCH 1/5] AF_RXRPC: Add blkcipher accessors for using kernel data directly
In-Reply-To: Your message of "Thu, 08 Mar 2007 22:48:29 GMT."
             <20070308224829.17456.97200.stgit@warthog.cambridge.redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <20070308224806.17456.13944.stgit@warthog.cambridge.redhat.com>
            <20070308224829.17456.97200.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1173394546_10421P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Mar 2007 17:55:46 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1173394546_10421P
Content-Type: text/plain; charset=us-ascii

On Thu, 08 Mar 2007 22:48:29 GMT, David Howells said:
> 
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 779aa78..ce092fe 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -40,7 +40,10 @@
>  #define CRYPTO_ALG_LARVAL		0x00000010
>  #define CRYPTO_ALG_DEAD			0x00000020
>  #define CRYPTO_ALG_DYING		0x00000040
> -#define CRYPTO_ALG_ASYNC		0x00000080
> +
> +#define CRYPTO_ALG_CAP_MASK		0x00000180	/* capabilities mask */
> +#define CRYPTO_ALG_ASYNC		0x00000080	/* capable of async operation */
> +#define CRYPTO_ALG_DMA			0x00000100	/* capable of using of DMA */

Would it make sense to define ALG_CAP_MASK as 0xF80 or similar, to reserve
a few bits? The alternative has somebody else grabbing 0x200 for some other
purpose, and then when you want to add another capability bit, you end up
with a CAP_MASK of 0x580 - this way leads to madness and bugs....

--==_Exmh_1173394546_10421P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF8JRycC3lWbTT17ARAjMPAJ9BIP7d6PhCrkqVDe/De9gUeO8fLACgj17e
yrFpNbkD+p7QqSTezk754Mw=
=ngWq
-----END PGP SIGNATURE-----

--==_Exmh_1173394546_10421P--
