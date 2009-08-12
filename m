Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbZHLQNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbZHLQNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZHLQNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:13:48 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:43358 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbZHLQNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:13:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=ghPWb2cDmrYYczNjsS3QUj0m075MRdREQ7xNLJzFlqbNJI6gDG6v1vbff5uVPa3Va7
         qV+mTKbO7in1IsGbadv56t0fLo/Xe6lk1bLBtwU8WvonOcXkVAwbUJwGjXzKh84BhRHx
         XQKDLLoOcKkHJ9B69fmLrxw1JoFNhUEo0Dl5s=
Message-ID: <4A82EA37.3010902@gmail.com>
Date: Wed, 12 Aug 2009 12:13:43 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Patrick Mullaney <pmullaney@novell.com>
Subject: Re: [PATCHv2 0/2] vhost: a kernel-level virtio server
References: <20090811212743.GA26309@redhat.com> <200908121452.01802.arnd@arndb.de> <20090812130612.GC29200@redhat.com> <200908121540.44928.arnd@arndb.de> <4A82C8F1.4030703@gmail.com> <20090812140224.GA29345@redhat.com>
In-Reply-To: <20090812140224.GA29345@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4E37A2FAF65F7E8AF474EC70"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4E37A2FAF65F7E8AF474EC70
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Wed, Aug 12, 2009 at 09:51:45AM -0400, Gregory Haskins wrote:
>> Arnd Bergmann wrote:
>>> On Wednesday 12 August 2009, Michael S. Tsirkin wrote:
>>>>> If I understand it correctly, you can at least connect a veth pair
>>>>> to a bridge, right? Something like
>>>>>
>>>>>            veth0 - veth1 - vhost - guest 1=20
>>>>> eth0 - br0-|
>>>>>            veth2 - veth3 - vhost - guest 2
>>>>>           =20
>>>> Heh, you don't need a bridge in this picture:
>>>>
>>>> guest 1 - vhost - veth0 - veth1 - vhost guest 2
>>> Sure, but the setup I described is the one that I would expect
>>> to see in practice because it gives you external connectivity.
>>>
>>> Measuring two guests communicating over a veth pair is
>>> interesting for finding the bottlenecks, but of little
>>> practical relevance.
>>>
>>> 	Arnd <><
>> Yeah, this would be the config I would be interested in.
>=20
> Hmm, this wouldn't be the config to use for the benchmark though: there=

> are just too many variables.  If you want both guest to guest and guest=

> to host, create 2 nics in the guest.
>=20
> Here's one way to do this:
>=20
> 	-net nic,model=3Dvirtio,vlan=3D0 -net user,vlan=3D0
> 	-net nic,vlan=3D1,model=3Dvirtio,vhost=3Dveth0
> 	-redir tcp:8022::22
>=20
> 	-net nic,model=3Dvirtio,vlan=3D0 -net user,vlan=3D0
> 	 -net nic,vlan=3D1,model=3Dvirtio,vhost=3Dveth1
> 	-redir tcp:8023::22
>=20
> In guests, for simplicity, configure eth1 and eth0
> to use separate subnets.

I can try to do a few variations, but what I am interested is in
performance in a real-world L2 configuration.  This would generally mean
 all hosts (virtual or physical) in the same L2 domain.

If I get a chance, though, I will try to also wire them up in isolation
as another data point.

Regards,
-Greg



--------------enig4E37A2FAF65F7E8AF474EC70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqC6jcACgkQP5K2CMvXmqG0FQCfVhCkLU4jF4NKuVMP5GrYh+cH
NF4AoIqK9SqEu0RYq/LqHoplHQBbErgz
=ydLy
-----END PGP SIGNATURE-----

--------------enig4E37A2FAF65F7E8AF474EC70--
