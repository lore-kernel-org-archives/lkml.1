Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZHKMdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZHKMdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZHKMdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:33:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57058 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbZHKMdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:33:36 -0400
Date: Tue, 11 Aug 2009 20:07:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wl1271: fix compiler warnings on 64 bit archs
Message-Id: <20090811200746.cde6aed9.sfr@canb.auug.org.au>
In-Reply-To: <1249981107-21746-1-git-send-email-luciano.coelho@nokia.com>
References: <1249981107-21746-1-git-send-email-luciano.coelho@nokia.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__11_Aug_2009_20_07_46_+1000_YpKPv1a8Wa0_ZenE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Aug_2009_20_07_46_+1000_YpKPv1a8Wa0_ZenE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Luciano,

On Tue, 11 Aug 2009 11:58:27 +0300 Luciano Coelho <luciano.coelho@nokia.com=
> wrote:
>
> +++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
> @@ -100,8 +100,8 @@ static int wl1271_boot_upload_firmware_chunk(struct w=
l1271 *wl, void *buf,
> =20
>  	wl1271_debug(DEBUG_BOOT, "starting firmware upload");
> =20
> -	wl1271_debug(DEBUG_BOOT, "fw_data_len %d chunk_size %d", fw_data_len,
> -		CHUNK_SIZE);
> +	wl1271_debug(DEBUG_BOOT, "fw_data_len %d chunk_size %d",
> +		     (u32) fw_data_len, CHUNK_SIZE);

fw_data_len is a size_t and so should be printed with %zd.

> @@ -148,7 +148,7 @@ static int wl1271_boot_upload_firmware_chunk(struct w=
l1271 *wl, void *buf,
>  	addr =3D dest + chunk_num * CHUNK_SIZE;
>  	p =3D buf + chunk_num * CHUNK_SIZE;
>  	wl1271_debug(DEBUG_BOOT, "uploading fw last chunk (%d B) 0x%p to 0x%x",
> -		     fw_data_len % CHUNK_SIZE, p, addr);
> +		     (u32) fw_data_len % CHUNK_SIZE, p, addr);

ditto.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Aug_2009_20_07_46_+1000_YpKPv1a8Wa0_ZenE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqBQvIACgkQjjKRsyhoI8ydkgCeIolwJ9m+0xtTWGtdAq4TPwsa
OGsAnjjotT5f0naCnbLL9whr6hZ1KImH
=tjeH
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Aug_2009_20_07_46_+1000_YpKPv1a8Wa0_ZenE--
