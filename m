Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbXIFMp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbXIFMp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbXIFMpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:45:13 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:59449 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262AbXIFMpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:45:11 -0400
Subject: Re: BUG: scheduling while atomic: ifconfig/0x00000002/4170
From: Johannes Berg <johannes@sipsolutions.net>
To: Satyam Sharma <satyam@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Florian Lohoff <flo@rfc822.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com,
       Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <alpine.LFD.0.999.0709061818270.3781@enigma.security.iitk.ac.in>
References: <20070902184439.GA14306@paradigm.rfc822.org>
	 <6bffcb0e0709021659o3856cd06gabc054c949a84397@mail.gmail.com>
	 <alpine.LFD.0.999.0709060923340.26804@enigma.security.iitk.ac.in>
	 <20070906082301.GB21929@gondor.apana.org.au>
	 <1189080575.28781.65.camel@johannes.berg>
	 <alpine.LFD.0.999.0709061818270.3781@enigma.security.iitk.ac.in>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OEAwj4NgJ4JvB5JCyVGC"
Date: Thu, 06 Sep 2007 14:46:22 +0200
Message-Id: <1189082782.28781.73.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OEAwj4NgJ4JvB5JCyVGC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-06 at 18:22 +0530, Satyam Sharma wrote:

> Unless I missed something obvious (let me know if that's the case! :-)
> an RCU-protected list would suffer the same fate. list_for_each_xxx_rcu()
> must be under rcu_read_lock() which =3D=3D preempt_disable() ...

Right. But I'm thinking that since all list manipulations are done under
RTNL we only need to protect against removing things from the list while
the RX or TX path is using it, so only it would have to use it under
rcu_read_lock() [which it already takes due to key management] so we
could get rid of that sub_if_lock completely. There is one issue with
this I know about and that is the management skb queue but I'll have to
take a closer look.

johannes

--=-OEAwj4NgJ4JvB5JCyVGC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3/ae/ETPhpq3jKURAlr2AJ0ce7Jw3F7kk9YTsyTeNb0xzYh5ngCfZpwT
6eWDYesw2yNcEEa+vjVa46E=
=BPmk
-----END PGP SIGNATURE-----

--=-OEAwj4NgJ4JvB5JCyVGC--

