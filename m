Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbZLJNq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbZLJNq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZLJNq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:46:26 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:23275 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZLJNqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:46:25 -0500
Message-ID: <4B20FBA4.9040003@chelsio.com>
Date: Thu, 10 Dec 2009 19:16:12 +0530
From: Rakesh Ranjan <rakesh@chelsio.com>
Organization: Chelsio Communications
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: kxie@chelsio.com, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
       netdev@vger.kernel.org, davem@davemloft.net,
       James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu,
       linux-kernel@vger.kernel.org, Rakesh Ranjan <rakesh@chelsio.com>
Subject: Re: [PATCH 1/1] cxgb3i: Fix a login over vlan issue
References: <200912100535.nBA5ZM0L000413@localhost.localdomain> <4B20E05C.1010604@trash.net>
In-Reply-To: <4B20E05C.1010604@trash.net>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig5887D312ED191E8BB48F310B"
X-OriginalArrivalTime: 10 Dec 2009 13:48:37.0437 (UTC) FILETIME=[793E56D0:01CA799F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5887D312ED191E8BB48F310B
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Patrick McHardy wrote:
> kxie@chelsio.com wrote:
>> [PATCH 1/1] cxgb3i: Fix a login over vlan issue
>>
>> From: Karen Xie <kxie@chelsio.com>
>>
>> Fix a login over vlan issue, when parent interface is vlan and we are =
using
>>
>> cxgb3i sepecific private ip address in '/etc/iscsi/ifaces/' iface file=
=2E
>>
>> +/**
>> + * cxgb3i_find_dev - find the interface associated with the given add=
ress
>> + * @ipaddr: ip address
>> + */
>> +static struct net_device *cxgb3i_find_dev(__be32 ipaddr)
>> +{
>> +	struct flowi fl;
>> +	int err;
>> +	struct rtable *rt;
>> +
>> +	memset(&fl, 0, sizeof(fl));
>> +	fl.nl_u.ip4_u.daddr =3D ipaddr;
>> +
>> +	err =3D ip_route_output_key(&init_net, &rt, &fl);
>> +	if (!err)
>> +		return (&rt->u.dst)->dev;
>> +
>> +	return NULL;
>> +}
>=20
> This probably shouldn't be using init_net but the current namespace.

Hi Patrick,

Thanks for review, will fix that and send another path shortly.

Regards
Rakesh Ranjan



--------------enig5887D312ED191E8BB48F310B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJLIPukAAoJEBqoHbxtDU4Jmy0P/jnqtltKw+yM9ayXT4OAp6un
pCzI0WFMkOOrqFCh7V7D+YYOs185b2jnVXxnLhOjRql5DiPAmo90pLjfd9sKOWqi
fx9omZse5WPmsPFzzW9NPi9D18dOQVwaKZ+JsqspPJ6RqGisMCTXVt9MQJKqq+Hj
VJ+IeFrCbHziQtVl1cBSm9rGHX88VRzcVTEHaGrEI17qViXaB/nMrN5GhuWQ2m1Q
xmDZEb+Qhc3zMy8hu3Xcwaw0DaZC7rATsyTrTZD/Y+kzYn3ahL2IMZDbtGlTpR8Y
WF5ycVi6lR1JC7dZgvj1gAqWa3MylKIFKJd3Ijg6f/LpEKQr78vsgszlnFRbgg74
PNANz3fPvhd1G14yj2Rqli4Ov7DjQyB2Dn94ajo3SvBW2YXEFkc/kN65Qh1ZXDDE
Tga1chjo/xBznlfADVnprsTHezG4MGglAJg5n3hyWen0F7+V3b0MXx8nkI8dkrru
PXO/HVVvpIeMwlyzAFH9zVygggeyzfx8WSjdSeW1uPY5i8iXDF3EcUkC7iKQa6lh
gqiHz7WLhU+dgpz4kMg2I9pQ3QpEhV6TqAt+wJ8NQHByVxvi5b54ehVTcOrqMhka
BSrYxH8Wh8FgUxExkzA+cmJtXlHBIp28NyVQR2P2aDXVBsyvGFuhDtk+1BYLm6+h
Tbua5SUp9LZNMuHQ6kpF
=i8bp
-----END PGP SIGNATURE-----

--------------enig5887D312ED191E8BB48F310B--
