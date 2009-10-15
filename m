Return-Path: <linux-kernel-owner+w=401wt.eu-S933003AbZJOQAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbZJOQAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932871AbZJOQAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:00:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:18690 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666AbZJOQAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=CcXy9z1S+cZ0zLfF7mn7jFe1ppLEFcK1QRK3t3Mr7nUDFxzXcptUvjw4S1cNPw1i1u
         bNid8MfftmpHm0qbd1mfjNs/5TavNtxcEQ8/Ij/vmLNs+eA8P0zmizW8mB+9DJ3oQ5vp
         tlF2RkeEoyo0FIQ3bCRpG9RpgfbidwZ/ty/Us=
Message-ID: <4AD7469B.9070907@gmail.com>
Date: Thu, 15 Oct 2009 11:58:19 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Tips for module_init() dependencies
References: <4AD71D12.9060203@gmail.com> <1255621559.22917.35.camel@desktop>
In-Reply-To: <1255621559.22917.35.camel@desktop>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4FDD2BA1161FB0A6664911B0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4FDD2BA1161FB0A6664911B0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Daniel Walker wrote:
> On Thu, 2009-10-15 at 09:01 -0400, Gregory Haskins wrote:
>=20
>> may break, because the kernel seems to have no concept of
>> interdependency between foo_init() and bar_init(), and therefore
>> bar_init() may call foo() before foo_init() has executed.
>>
>> There are various ways to solve this problem, such as deferring callin=
g
>> foo() with a workqueue or something, but I was wondering if there was =
a
>> better/standard way to do this that I am missing?
>>
>> The problem I am having specifically is that I am trying to call
>> configfs_register_subsystem() in a module_init(), but this breaks when=

>> built into the kernel based on sheer bad luck that configfs gets
>> initialized after me.  To date I have worked around this by forcing my=

>> code to only support built-in, and using late_initcall() instead or
>> module_init.  This works, but it only means I am putting the problem o=
ff
>> (code that depends on *me* has to use similar tricks, etc.
>=20
> You can't modify the build order so your module get "builtin" after
> configfs?
>=20

Hi Daniel,

Possibly.

A) Any suggestions on how? Can I express this in Kconfig or something
(i.e. "depends on FOO").  I currently have "select FOO" in the BAR
object, but this doesn't seem to be sufficient to describe the relationsh=
ip.

B) Do I have to make the entire chain follow suit? (I have C deps on B,
B deps on A kind of scenarios)

Kind Regards,
-Greg



--------------enig4FDD2BA1161FB0A6664911B0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrXRpsACgkQP5K2CMvXmqH0AACffvS71ELVyrn5KpEH38LK/3qv
q34An1u85dAiMIL3sXzTP9XeMzRgLvV3
=4ZxE
-----END PGP SIGNATURE-----

--------------enig4FDD2BA1161FB0A6664911B0--
