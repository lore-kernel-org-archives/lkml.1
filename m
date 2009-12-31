Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZLaCAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZLaCAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 21:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZLaCAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 21:00:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42393 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbZLaCAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 21:00:11 -0500
Date: Thu, 31 Dec 2009 13:00:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IlJlbsOpIEJvbGxkb3JmIg==?= <xsecute@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: wireless tree build warnings
Message-Id: <20091231130005.6fa2b865.sfr@canb.auug.org.au>
In-Reply-To: <4B3BF6D1.6010209@googlemail.com>
References: <20091231105709.c50f22c0.sfr@canb.auug.org.au>
	<4B3BF6D1.6010209@googlemail.com>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__31_Dec_2009_13_00_05_+1100_kDYm/IAAsx3ZK4k3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Dec_2009_13_00_05_+1100_kDYm/IAAsx3ZK4k3
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ren=C3=A9, On Thu, 31 Dec 2009 01:56:49 +0100 Ren=C3=A9 Bolldorf <xsecut=
e@googlemail.com> wrote:
>
> On 12/31/09 00:57, Stephen Rothwell wrote:
> > Hi John,
> >
> > Today's linux-next build (i386 defconfig) produced thes warnings:
> >
> > net/mac80211/work.c: In function 'ieee80211_remain_on_channel_timeout':
> > net/mac80211/work.c:534: warning: cast from pointer to integer of diffe=
rent size
> > net/mac80211/work.c: In function 'ieee80211_remain_done':
> > net/mac80211/work.c:1030: warning: cast from pointer to integer of diff=
erent size
> > net/mac80211/work.c: In function 'ieee80211_wk_remain_on_channel':
> > net/mac80211/work.c:1056: warning: cast from pointer to integer of diff=
erent size
> > net/mac80211/work.c: In function 'ieee80211_wk_cancel_remain_on_channel=
':
> > net/mac80211/work.c:1072: warning: cast from pointer to integer of diff=
erent size
> >
> > Introduced by commits e4da8c37af626001ff704fb29ea14eb58f5f7208
> > ("mac80211: make off-channel work generic") and
> > b8bc4b0aa9bfba755c64b11b8f60e6cfab25dc9d ("mac80211: support
> > remain-on-channel command").
> >
>=20
> shouldn't it be u32 instead of u64? Please correct me if I'am wrong.
>=20
> Example:
> cfg80211_ready_on_channel(wk->sdata->dev, (u32)wk, wk->chan,
> 		wk->chan_type, wk->remain.duration, GFP_KERNEL);
> instead of:
> cfg80211_ready_on_channel(wk->sdata->dev, (u64)wk, wk->chan,
> 		wk->chan_type, wk->remain.duration, GFP_KERNEL);

the prototype is:

void cfg80211_ready_on_channel(struct net_device *dev, u64 cookie,
                               struct ieee80211_channel *chan,
                               enum nl80211_channel_type channel_type,
                               unsigned int duration, gfp_t gfp);

And in the case in point, "wk" is a pointer, so casting that to a u32
would be even worse on a 64bit architecture.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__31_Dec_2009_13_00_05_+1100_kDYm/IAAsx3ZK4k3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAks8BaUACgkQjjKRsyhoI8y4yQCfUBXeCfKufE8Pf9Ioe0hsz/QX
0ZAAn2HozEa/XRfT52mjB15VYiuTAKiL
=FrV8
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Dec_2009_13_00_05_+1100_kDYm/IAAsx3ZK4k3--
