Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbZEKNEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbZEKNEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZEKNEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:04:37 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:46582 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbZEKNEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=at39H1Ai+OcRvjbJUN6d3OM0XuHInMTW/RP//UrGFaaZfWXM1yhAX8moOrN4OY/+9+
         9QP8J/rd41qx7DrX/E75i/f/+TmyW4p0brKADm6ruxd10UK1eZVtO08gyCvA5PT3jwNL
         mgmg3ejVNzogds56hxLGRC5D/ekaTk32hM8MM=
Message-ID: <4A08225C.5000204@gmail.com>
Date: Mon, 11 May 2009 09:04:28 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A031471.7000406@novell.com> <200905080011.52958.arnd@arndb.de> <1241821998.29028.5.camel@pasglop> <200905111501.41563.arnd@arndb.de>
In-Reply-To: <200905111501.41563.arnd@arndb.de>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFB681D037E0457167631C9C8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFB681D037E0457167631C9C8
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Arnd Bergmann wrote:
> On Saturday 09 May 2009, Benjamin Herrenschmidt wrote:
>  =20
>> This was shot down by a vast majority of people, with the outcome bein=
g
>> an agreement that for IORESOURCE_MEM, pci_iomap and friends must retur=
n
>> something that is strictly interchangeable with what ioremap would hav=
e
>> returned.
>>
>> That means that readl and writel must work on the output of pci_iomap(=
)
>> and similar, but I don't see why __raw_writel would be excluded there,=
 I
>> think it's in there too.
>>    =20
>
> One of the ideas was to change pci_iomap to return a special token
> in case of virtual devices that causes iowrite32() to do an hcall,
> and to just define writel() to do iowrite32().
>
> Unfortunately, there is no __raw_iowrite32(), although I guess we
> could add this generically if necessary.
>
>  =20
>> Direct dereference is illegal in all cases though.
>>    =20
>
> right.
> =20
>  =20
>> The token returned by pci_iomap for other type of resources (IO for
>> example) is also only supported for use by iomap access functions
>> (ioreadXX/iowriteXX) , and IO ports cannot be passed directly to those=

>> neither.
>>    =20
>
> That still leaves the option to let drivers pass the IORESOURCE_PVIO
> for its own resources under some conditions, meaning that we will
> only use hcalls for I/O on these drivers but not on others, as Chris
> explained earlier.
>  =20

Between this, and Avi's "nesting" point, this is the direction I am
leaning in right now.

-Greg



--------------enigFB681D037E0457167631C9C8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoIIlwACgkQP5K2CMvXmqGGnACePt3CyP1huI9sJMHi8S7Bqmsl
T8cAn0tZTP5GPy1qav4ajeO79dJwXCP4
=yJ7s
-----END PGP SIGNATURE-----

--------------enigFB681D037E0457167631C9C8--
