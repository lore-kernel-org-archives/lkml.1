Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZIOPbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZIOPbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbZIOPbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:31:40 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:46306 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbZIOPbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:31:38 -0400
Subject: Re: alloc skb based on a given data buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: David Miller <davem@davemloft.net>, "mel@csn.ul.ie" <mel@csn.ul.ie>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "elendil@planet.nl" <elendil@planet.nl>,
       "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "penberg@cs.helsinki.fi" <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "Krauss, Assaf" <assaf.krauss@intel.com>,
       "Abbas, Mohamed" <mohamed.abbas@intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <1253006111.7549.61.camel@debian>
References: <1253003420.7549.51.camel@debian>
	 <20090915.013321.07006714.davem@davemloft.net>
	 <1253005050.7549.58.camel@debian>
	 <20090915.020903.93643290.davem@davemloft.net>
	 <1253006111.7549.61.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fzAflWusSa20Mep4aX4E"
Date: Tue, 15 Sep 2009 08:30:31 -0700
Message-Id: <1253028631.23427.55.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.91 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fzAflWusSa20Mep4aX4E
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-15 at 17:15 +0800, Zhu Yi wrote:
> On Tue, 2009-09-15 at 17:09 +0800, David Miller wrote:
> > From: Zhu Yi <yi.zhu@intel.com>
> > Date: Tue, 15 Sep 2009 16:57:29 +0800
> >=20
> > > Thanks. So we can put the 8K buffer into 2 skb_shinfo()->frags[] slot=
s
> > > and set nr_frags to 2, right? Is this supported allover the network c=
ode
> > > already? At a first glance, I didn't find any frags handling in mac80=
211
> > > stack.
> >=20
> > You have to pre-pull the link level protocol headers into the
> > linear area, but that's it.
> >=20
> > Again, see niu.c for details, it does:
> >=20
> > static void niu_rx_skb_append(struct sk_buff *skb, struct page *page,
> > 			      u32 offset, u32 size)
> > {
> > 	int i =3D skb_shinfo(skb)->nr_frags;
> > 	skb_frag_t *frag =3D &skb_shinfo(skb)->frags[i];
> >=20
> > 	frag->page =3D page;
> > 	frag->page_offset =3D offset;
> > 	frag->size =3D size;
> >=20
> > 	skb->len +=3D size;
> > 	skb->data_len +=3D size;
> > 	skb->truesize +=3D size;
> >=20
> > 	skb_shinfo(skb)->nr_frags =3D i + 1;
> > }
> >=20
> > to add pages to SKBs and then at the end it goes:
> >=20
> > 	skb_reserve(skb, NET_IP_ALIGN);
> > 	__pskb_pull_tail(skb, min(len, NIU_RXPULL_MAX));
> >=20
> > Right before giving the SKB to the networking stack.  NIU_RXPULL_MAX
> > should be a value that will be large enough to cover the largest
> > possible link level header.
>=20
> I see. Thanks for this info. I'll try implementing the same for iwlagn.

Hold, mac80211 can't cope with that at this point for sw crypto and
possibly other things.

johannes

--=-fzAflWusSa20Mep4aX4E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKr7MTAAoJEODzc/N7+QmaQLwP/1psaHMJvQwqhroEfiUvI1lL
kHDoeGDMCTed8tnZ3d8OfyEOlzINTnRxP0TsAo+jrkpL6fq6LuS7ZzuHwSI3yi3m
CxY7/9Lssp+0AstkiZTPKRLAbHp2UfDxE+pr24eDH3al3gLhUNm1QmhOv9gHCsrR
gIlIPI661po9bIzYFywA+LOSEsL4aaRugfQNArSUtHgBPTWIb8l8u5v0+hg1Y89P
z9J7sMh0WcJ1gUdiL6pD+2iPL1aM8kRq05AxpXCPy4swEFoPD89wjyM+0W3SZL4s
JsG9ropdJDO12tEQp+4MoQYQPX+eIcLgyWSV+kYMUZu6ggvR9LV5544BCqnr8tq9
ogCbbOEb9tm7BFCV9dNC6FXrMfg3yPheUP6hYwo00mfE/Brjwy64fIOrXHeTK4Gw
RmZTwndT0TaBwPcIFi6Mus+GyKOP3+35RFHWLPg99ev78xTpvRZ2PjPZ8IJRLsYF
UnEcCJZBRWelgHj4iZtDI3pyRQ5zx+rS//8NT9om15vSdbSGNJ0aZG5ox0pXC5uv
kGVGnmBr/V3Cjtb7W3NIHz0LQJwJqIsClEmVha0bjXc7tU9Fby0W09naFpWZKyFX
9t7PwP4D7DCKdhmKID6qDmoqnDBNjJhdDnHO9b199BaJju0f2qZzLvDXwEvlCBso
wb/AjDoqeQE/97V5pipl
=s1h9
-----END PGP SIGNATURE-----

--=-fzAflWusSa20Mep4aX4E--

