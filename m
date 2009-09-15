Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbZIOVzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbZIOVzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758726AbZIOVzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:55:44 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:18037 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZIOVzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:55:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=jzlSukiD/nxO/Cq60G+oQauJkOt1cIfDezpxCGS5zmwdkRkw5crDsWiAgK04V7nPgd
         iH4hR/jenl+21Ra3/6+KffGTJ4Th3D77enzksnWWWU4KLtgLvodK4Vx/myvpUoEAYoWV
         RT/6juuk6W0OPGu6paD5O3JLDt/QUPlsHgrPs=
Message-ID: <4AB00D5D.3080104@gmail.com>
Date: Tue, 15 Sep 2009 17:55:41 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Avi Kivity <avi@redhat.com>, "Ira W. Snyder" <iws@ovro.caltech.edu>,
       netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
References: <4AAF8A03.5020806@redhat.com> <4AAF909F.9080306@gmail.com> <4AAF95D1.1080600@redhat.com> <4AAF9BAF.3030109@gmail.com> <4AAFACB5.9050808@redhat.com> <4AAFF437.7060100@gmail.com> <20090915204036.GA27954@redhat.com> <4AAFFC8E.9010404@gmail.com> <20090915212545.GC27954@redhat.com> <4AB0098F.9030207@gmail.com> <20090915213854.GE27954@redhat.com>
In-Reply-To: <20090915213854.GE27954@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD474E6449406F2891D34A579"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD474E6449406F2891D34A579
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Sep 15, 2009 at 05:39:27PM -0400, Gregory Haskins wrote:
>> Michael S. Tsirkin wrote:
>>> On Tue, Sep 15, 2009 at 04:43:58PM -0400, Gregory Haskins wrote:
>>>> Michael S. Tsirkin wrote:
>>>>> On Tue, Sep 15, 2009 at 04:08:23PM -0400, Gregory Haskins wrote:
>>>>>> No, what I mean is how do you surface multiple ethernet and consol=
es to
>>>>>> the guests?  For Ira's case, I think he needs at minimum at least =
one of
>>>>>> each, and he mentioned possibly having two unique ethernets at one=
 point.
>>>>>>
>>>>>> His slave boards surface themselves as PCI devices to the x86
>>>>>> host.  So how do you use that to make multiple vhost-based devices=
 (say
>>>>>> two virtio-nets, and a virtio-console) communicate across the tran=
sport?
>>>>>>
>>>>>> There are multiple ways to do this, but what I am saying is that
>>>>>> whatever is conceived will start to look eerily like a vbus-connec=
tor,
>>>>>> since this is one of its primary purposes ;)
>>>>> Can't all this be in userspace?
>>>> Can you outline your proposal?
>>>>
>>>> -Greg
>>>>
>>> Userspace in x86 maps a PCI region, uses it for communication with pp=
c?
>>>
>> And what do you propose this communication to look like?
>=20
> Who cares? Implement vbus protocol there if you like.
>=20

Exactly.  My point is that you need something like a vbus protocol there.=
 ;)

Here is the protocol I run over PCI in AlacrityVM:

http://git.kernel.org/?p=3Dlinux/kernel/git/ghaskins/alacrityvm/linux-2.6=
=2Egit;a=3Dblob;f=3Dinclude/linux/vbus_pci.h;h=3Dfe337590e644017392e4c9d9=
236150adb2333729;hb=3Dded8ce2005a85c174ba93ee26f8d67049ef11025

And I guess to your point, yes the protocol can technically be in
userspace (outside of whatever you need for the in-kernel portion of the
communication transport, if any.

The vbus-connector design does not specify where the protocol needs to
take place, per se.  Note, however, for performance reasons some parts
of the protocol may want to be in the kernel (such as DEVCALL and
SHMSIGNAL).  It is for this reason that I just run all of it there,
because IMO its simpler than splitting it up.  The slow path stuff just
rides on infrastructure that I need for fast-path anyway, so it doesn't
really cost me anything additional.

Kind Regards,
-Greg


--------------enigD474E6449406F2891D34A579
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqwDV0ACgkQP5K2CMvXmqGoHwCfe40zj1s7CnCazpTfdiG2mEd8
2asAn3nUqfxZlOxIwgfzWBYERIeQDo1m
=Rz8Z
-----END PGP SIGNATURE-----

--------------enigD474E6449406F2891D34A579--
