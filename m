Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661AbZH0IZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbZH0IZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 04:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbZH0IZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 04:25:44 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45049 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZH0IZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 04:25:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EUnGfI0rkuducJJrSRZiUTvUErc74d/Uowi9MpUIBWi+zGMGwKkE6GslgWZPCMetf6
         fFwXD83znrKSw++qG4nipyj3qMF83cNk2eKrm33vqa09lcMCbejSRwqO+bvpkVehayJY
         iS7vxtG93trBCMB/MjxVeNSI3GwNxvFsGK7UI=
Date: Thu, 27 Aug 2009 11:29:27 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090827082927.GD3536@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <1250498613.28336.68.camel@minggr.sh.intel.com>
 <20090817113059.GA3245@localdomain.by>
 <d3f22a0908170622x7dd9ce73m5c3ea86406cc9935@mail.gmail.com>
 <20090818071359.GA3713@localdomain.by>
 <1250579915.13743.8.camel@minggr.sh.intel.com>
 <20090827075253.GB3536@localdomain.by>
 <1251359994.3282.11.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VV4b6MQE+OnNyhkM"
Content-Disposition: inline
In-Reply-To: <1251359994.3282.11.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VV4b6MQE+OnNyhkM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/27/09 15:59), Lin Ming wrote:
> > rc7-git5 (patched)
> >=20
> > [    0.178628] ACPI: EC: Look up EC in DSDT
> > [    0.196480] ACPI: Interpreter enabled
> > [    0.196575] ACPI: (supports S0 S1 S3 S4 S5)
> > [    0.197184] ACPI: Using IOAPIC for interrupt routing
> > [    0.197352] PCI: MCFG configuration 0: base e0000000 segment 0 buses=
 0 - 255
> > [    0.203511] ACPI Error (dswload-0790): [PCFG] Namespace lookup failu=
re, AE_ALREADY_EXISTS
> > [    0.203738] ACPI Exception: AE_ALREADY_EXISTS, During name lookup/ca=
talog 20090521 psloop-227
> > [    0.203964] ACPI Error (psparse-0537): Method parse/execution failed=
 [\_SB_.RBPE] (Node f7017678), AE_ALREADY_EXISTS
> > [    0.204256] ACPI: Marking method RBPE as Serialized because of AE_AL=
READY_EXISTS error
> > [    0.204510] ACPI Error (psparse-0537): Method parse/execution failed=
 [\_GPE._L01] (Node f701d198), AE_ALREADY_EXISTS
> > [    0.204803] ACPI: Marking method _L01 as Serialized because of AE_AL=
READY_EXISTS error
> > [    0.205063] ACPI Exception: AE_ALREADY_EXISTS, while evaluating GPE =
method [_L01] 20090521 evgpe-568
>=20
> Do you mean rc7-git5 sometime boot fails even with the patch applied?
>
No. Patched kernel boots ok. Even successfully booted kernel sometimes has =
the given lines in dmesg.
(I'll watch more.)
=20
> >=20
> >=20
> > [...]
> > +		if (!(region_obj->region.node->flags & ANOBJ_TEMPORARY)) {
> > +			acpi_ex_exit_interpreter();
> > +		}
> > [...]
> > Does it explain successful boot with delay (vga=3D791, prink delay, etc=
=2E)?
>=20
> Sorry, could you explain the question a bit more?
>=20
Sorry,
We had successful boots with small delays (like vga=3D791, prinTk delays an=
d so on) and oopses otherwise.

On (08/12/09 20:18), Len Brown wrote:
>The fact that boot_delay=3D10 makes the problem go away
>suggests some sort of race condition.  Is 10 the smallest
>value of printk_time that works, or is it a random value?
>


>Currently, we exit the interpreter when setup region, because it may
>execute control methods, such as _REG.
>
>The attached debug kernel patch (region-debug.patch) don't exit the
>interpreter if the region is temporary, namely, it is defined inside a
>method.
Ok, we don't exit in case of temporary region. How is it possible that we h=
ad 'normal'=20
boots with delays?=20


	Sergey
--VV4b6MQE+OnNyhkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqWQ+cACgkQfKHnntdSXjTifgQArk+KDMYo+R5ojKJHAoS7a52e
xkUzpEWpA5qR9x4eW49AHdmFh2LHZttohWf7S8Ab1HqK9ClVsnSgvx5PS+1kmx5V
PvZJMxGHTiPcjzXUmGSw1myYgnranDSz4J92LqzF55qYzOgUC90d4kkDJzo2N/gV
nZroMU+e4D1w/tIPpa8=
=R3VQ
-----END PGP SIGNATURE-----

--VV4b6MQE+OnNyhkM--
