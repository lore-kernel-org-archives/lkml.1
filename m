Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZLAJOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZLAJOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 04:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZLAJOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 04:14:43 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:38253 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbZLAJOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 04:14:40 -0500
Subject: Re: linux-next: net/wireless/wireless-current tree build warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20091201133524.32756cef.sfr@canb.auug.org.au>
References: <20091201133524.32756cef.sfr@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tEG7/D3K2eJZ0eLBtnAH"
Date: Tue, 01 Dec 2009 10:14:33 +0100
Message-ID: <1259658873.32171.39.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tEG7/D3K2eJZ0eLBtnAH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Stephen,

On Tue, 2009-12-01 at 13:35 +1100, Stephen Rothwell wrote:
> Hi John,
>=20
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
>=20
> drivers/net/wireless/iwlwifi/iwl-tx.c: In function 'iwl_tx_agg_stop':
> drivers/net/wireless/iwlwifi/iwl-tx.c:1356: warning: passing argument 1 o=
f 'ieee80211_stop_tx_ba_cb_irqsafe' from incompatible pointer type
> include/net/mac80211.h:2128: note: expected 'struct ieee80211_vif *' but =
argument is of type 'struct ieee80211_hw *'
>=20
> Introduced by a bad merge (mine) between commit
> 827d42c9ac91ddd728e4f4a31fefb906ef2ceff7 ("mac80211: fix spurious delBA
> handling") form the wireless-current tree and commit
> c951ad3550ab40071bb0f222ba6125845769c08a ("mac80211: convert aggregation
> to operate on vifs/stas") from the net/wireless trees.  I didn't notice
> that the former had added a call to the function modified in the latter.
>=20
> I applied the following patch for today:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 1 Dec 2009 13:19:44 +1100
> Subject: [PATCH] wireless: fix for mismerge
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/wireless/iwlwifi/iwl-tx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless=
/iwlwifi/iwl-tx.c
> index 58b132f..00da5e1 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-tx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
> @@ -1353,7 +1353,7 @@ int iwl_tx_agg_stop(struct iwl_priv *priv , const u=
8 *ra, u16 tid)
>  	if (priv->stations[sta_id].tid[tid].agg.state =3D=3D
>  				IWL_EMPTYING_HW_QUEUE_ADDBA) {
>  		IWL_DEBUG_HT(priv, "AGG stop before setup done\n");
> -		ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, ra, tid);
> +		ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, ra, tid);

Perfect fixup, I had originally sent different versions of the patch for
different trees, but you couldn't know that, especially not since the
delba handling fix didn't (and won't) make it into wireless-next at all.

johannes

--=-tEG7/D3K2eJZ0eLBtnAH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLFN50AAoJEODzc/N7+QmaFd0P/0dtyZrGjClLGZwymLqGLyGF
cPGv5lig6kdsFqByVp6Su10rIPviUs14XoYBV64Tb9v3lyOapJD0nMIBDlanqeM1
FWijtk2yq4SIcdfuXSuhvA/VREI2d5bbQcvdKdeOGljCUq7hZAUFZl+H/xjQrKeS
kUrbFMm4YOXgXrhTFp6xlaVh8vEMj77L1YWnvHGbt+bQOWo+o7i5AgOMYz3UYLa4
PgOkA9l4YBH6wd77s7GVzJgquenv8PVFdSIOm1yr6T7mP3iPJfHw3O/Vn3W1ynMH
xgEizGtGBCfQU8ttXWUFLVXtixz/9IpAoEXm4YwsbutgcbIZEbYjeKyXH6DfoEM1
JeAQhy+Y6DhaJZ3NVGE3Y3QdO+8RRg6S1vbjcqGJ2B4IfNBMYm0uNuEGCliLnnFc
ViQn9c7xE6iEbIwzN8OTih9IqxhNcG0A7+cgjnILnqh4qXKY7GC+mJJBKcfwdkEN
CIOAdz8meRAN4Ax2lTgLV8NCev7+3js6S+Pp3Tg20eL9NeCJXwybEYgEccoLRgnL
Fyo8WWb8pV5PHEMPg3svikcCzXAaPN9G66wrSusjOzNTUJqWRf2QwwZYOvvWHOtA
2rPu6U+8RGi9AGzn4Yk96Jjh/+1Q1G91chdQX/uMuZgOrjAOxmbk48IV/IakEFj0
2W0ZTmgRn586rcnxVbeS
=tVGd
-----END PGP SIGNATURE-----

--=-tEG7/D3K2eJZ0eLBtnAH--

