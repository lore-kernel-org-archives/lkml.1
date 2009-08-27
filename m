Return-Path: <linux-kernel-owner+w=401wt.eu-S1751545AbZH0HtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbZH0HtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 03:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZH0HtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 03:49:11 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:32921 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZH0HtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 03:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F27CsSRnC4Di0l/bCKIwTOGGhUgQf70LDnACIvRPh+8+b+r+3CR4KsaWgBllLccZOG
         OcF87YFH8yFxV0ZK4/IvZ/xM5tEF7tThMOQrtrWkqSzMCeGn9N8I1PsHTtOC7pVyYt8M
         gffHNMEJN9uZUZP4t6zy1kB1xBn+iZATrcECg=
Date: Thu, 27 Aug 2009 10:52:53 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090827075253.GB3536@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <1250498613.28336.68.camel@minggr.sh.intel.com>
 <20090817113059.GA3245@localdomain.by>
 <d3f22a0908170622x7dd9ce73m5c3ea86406cc9935@mail.gmail.com>
 <20090818071359.GA3713@localdomain.by>
 <1250579915.13743.8.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
In-Reply-To: <1250579915.13743.8.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/18/09 15:18), Lin Ming wrote:

Hello Lin,

rc7-git5 (patched)

[    0.178628] ACPI: EC: Look up EC in DSDT
[    0.196480] ACPI: Interpreter enabled
[    0.196575] ACPI: (supports S0 S1 S3 S4 S5)
[    0.197184] ACPI: Using IOAPIC for interrupt routing
[    0.197352] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.203511] ACPI Error (dswload-0790): [PCFG] Namespace lookup failure, =
AE_ALREADY_EXISTS
[    0.203738] ACPI Exception: AE_ALREADY_EXISTS, During name lookup/catalo=
g 20090521 psloop-227
[    0.203964] ACPI Error (psparse-0537): Method parse/execution failed [\_=
SB_.RBPE] (Node f7017678), AE_ALREADY_EXISTS
[    0.204256] ACPI: Marking method RBPE as Serialized because of AE_ALREAD=
Y_EXISTS error
[    0.204510] ACPI Error (psparse-0537): Method parse/execution failed [\_=
GPE._L01] (Node f701d198), AE_ALREADY_EXISTS
[    0.204803] ACPI: Marking method _L01 as Serialized because of AE_ALREAD=
Y_EXISTS error
[    0.205063] ACPI Exception: AE_ALREADY_EXISTS, while evaluating GPE meth=
od [_L01] 20090521 evgpe-568


[...]
+		if (!(region_obj->region.node->flags & ANOBJ_TEMPORARY)) {
+			acpi_ex_exit_interpreter();
+		}
[...]
Does it explain successful boot with delay (vga=3D791, prink delay, etc.)?


> And would you please test the region-debug.patch multiple times to
> verify if it really fixes the bug?
>=20
rc7-git5 (nopatch)
+ -

rc7-git5 (patched)
20+ reboots

	Sergey

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqWO1UACgkQfKHnntdSXjQOsQP9FI8WytB/gpnuM8KkmkdVNL9U
p0xYglqjUUnTdaBBM8CAFbv1tWx+yWHbLzA1UWz2cZLJwIPxnN9j0Xrd9pUY5hnT
kqMMWhyS6NwbE1xqhOG52DOaX+nO2xroVVv7xE2hSHk2CIricOyDsAH6yLQr+gse
N3EkkaKN3iSx3FDPpbY=
=8TDm
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
