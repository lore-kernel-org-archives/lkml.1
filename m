Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbZHLUnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbZHLUnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 16:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbZHLUna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 16:43:30 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:62315 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZHLUn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 16:43:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type;
        b=p5uHW7S8Igf4C+sUO0dbAgp7THpHYEn4ef6jzc0GeOeBIJvBxriO4gKfsgttJyHxGG
         by2uKPX0Y7Un6yqX9dYOw/Nki1r3FvblxqrSKvd/vu/MB9mOlakQpwG/bQYdR51jA9Yw
         wyOhybC6V+WNjY2xbQktiIhNuGfO2uHYIEjWo=
Message-ID: <4A83296B.3080606@gmail.com>
Date: Wed, 12 Aug 2009 16:43:23 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: alacrityvm-devel@lists.sourceforge.net,
       alacrityvm-users@lists.sourceforge.net
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org
Subject: AlacrityVM numbers updated for 31-rc4
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig965E8CB54FAEC0A7B24CCFC8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig965E8CB54FAEC0A7B24CCFC8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I re-ran the numbers on 10GE against the actual alacrityvm v0.1 release
available in git on kernel.org.

I tried to include the newly announced "vhost" driver (Michael Tsirkin)
for virtio acceleration, but ran into issues getting the patches to apply=
=2E

For now, this includes native, virtio-u (virtio-userspace), and venet
all running on 31-rc4.  If I can resolve the issue with Michaels
patches, I will add "virtio-k" (virtio-kernel) to the mix as well.  For
now, here are the results for 1500mtu:

native:   7388Mb/s,   29.8us rtt (33505 tps udp-rr)
venet:    3654Mb/s,   56.8us rtt (17600 tps udp-rr)
virtio-u: 1955Mb/s, 4016.0us rtt (  249 tps udp-rr)

Note that on one particular boot-session, I actually saw venet run
consistently 4600Mb/s, and virtio-u run consistently 2800Mb/s.  I am not
sure why other runs resulted in deterministically lower numbers, but I
included the average of the low runs to be conservative, ~3600, ~1900
respectively).

Of interest here is that native made a huge jump (2.6.29 was more like
4Gb/s), and also that KVM regressed a bit, especially compared to native
numbers.  The cause for either of these changes is not known at this
time, but I will investigate the cause over the next few days.

In any case, I have updated the graphs on the AlacrityVM wiki to reflect
these latest numbers:

http://developer.novell.com/wiki/index.php/AlacrityVM

Kind Regards,
-Greg


--------------enig965E8CB54FAEC0A7B24CCFC8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqDKWsACgkQP5K2CMvXmqHOhgCfWd6BYp0Waa95XAhrQf1NqhBm
2EEAnj2/0Fngi3pu7fa3sbRxirTQd/+D
=7ezu
-----END PGP SIGNATURE-----

--------------enig965E8CB54FAEC0A7B24CCFC8--
