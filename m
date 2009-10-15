Return-Path: <linux-kernel-owner+w=401wt.eu-S935134AbZJOQwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134AbZJOQwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934935AbZJOQwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:52:18 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:42845 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934632AbZJOQwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=EdAtpnEcgJCpaosOMRj/Ulw3QKz9SJpE24QNkeH7PIq5Fn35M+rd8OSn7NhEM+oR7j
         AMvoPH0LZAcC6lcztA1h+S+TRPvMy5SUZJgWutKz1hgG3mTJmJPTjm8zS2ftxwAZ9ffN
         KxqA/qMhdnVCzSqMl9X2/4O5+dJi607tpKJWE=
Message-ID: <4AD752CE.5070000@gmail.com>
Date: Thu, 15 Oct 2009 12:50:22 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Tips for module_init() dependencies
References: <4AD71D12.9060203@gmail.com> <1255621559.22917.35.camel@desktop>	 <4AD7469B.9070907@gmail.com> <1255623129.22917.41.camel@desktop>	 <4AD74B02.1070606@gmail.com> <1255623697.22917.45.camel@desktop>
In-Reply-To: <1255623697.22917.45.camel@desktop>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig97B4638551CC32F539293F70"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig97B4638551CC32F539293F70
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Daniel Walker wrote:
> On Thu, 2009-10-15 at 12:17 -0400, Gregory Haskins wrote:
>> Daniel Walker wrote:
>>> On Thu, 2009-10-15 at 11:58 -0400, Gregory Haskins wrote:
>>>
>>>> Hi Daniel,
>>>>
>>>> Possibly.
>>>>
>>>> A) Any suggestions on how? Can I express this in Kconfig or somethin=
g
>>>> (i.e. "depends on FOO").  I currently have "select FOO" in the BAR
>>>> object, but this doesn't seem to be sufficient to describe the relat=
ionship.
>>>>
>>>> B) Do I have to make the entire chain follow suit? (I have C deps on=
 B,
>>>> B deps on A kind of scenarios)
>>> Yeah, what Randy said .. As far as I know it should be just a build
>>> order issue .. In the make file when you specify your new module alon=
g
>>> with all the others where you put it is actually important .. In
>>> fs/Makefile you have this line,
>>>
>>> obj-$(CONFIG_CONFIGFS_FS)       +=3D configfs/
>>>
>>> and I would guess you want yours after that line if your adding to th=
at
>>> makefile.
>> Right, that makes sense.  However, the problem is that these
>> dependencies might not have anything to do with ./fs per se and
>> therefore would not necessarily be in the ./fs Makefile.  But I think
>> the Makefile dependency idea in general is the right approach, so I wi=
ll
>> experiment with this suggestion.
>=20
> I think the order for the core stuff is,
>=20
> kernel/ mm/ fs/ ipc/ security/ crypto/ block/
>=20
> and that all comes before drivers/ , so your adding to kernel/ or mm/ ?=

>=20
> Daniel
>=20

Its currently in kernel, though I am not married to this location per se.=


-Greg



--------------enig97B4638551CC32F539293F70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrXUs4ACgkQP5K2CMvXmqHWxQCffbWaIiwr0t1UaFv0s/qqdjlS
ogYAnjmkRwRMzkniZsEAd8ugyvtUZtwv
=6Lt8
-----END PGP SIGNATURE-----

--------------enig97B4638551CC32F539293F70--
