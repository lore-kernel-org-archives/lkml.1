Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbZHNHun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbZHNHun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 03:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbZHNHum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 03:50:42 -0400
Received: from mail-yw0-f193.google.com ([209.85.211.193]:59164 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbZHNHul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 03:50:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WlhzPs460U6xPS36X2KfQ22+Gh5eoTOHnvtbi4BPno0nulnqakIMW3AoONGaZD1MRI
         9U3NawsbpXC1e+5Jz6ywh4c1LyBYQpsBazNY3tucJqGRG2mAEkyG8pUKzRZLsUoU4xCC
         ZrDvn26Bd4XIwl72GYP2qu6gRDwMHaJIb6aGs=
Date: Fri, 14 Aug 2009 10:53:57 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Len Brown <lenb@kernel.org>, "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090814075357.GA3545@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
 <20090813124647.GA19195@localdomain.by>
 <1250217283.2987.16.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <1250217283.2987.16.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Could you please help to locate the line of code that causes oops, as
> below?
>=20

$ addr2line -e ./vmlinux -i -f c12a77ca
acpi_ex_system_memory_space_handler
/media/dev/kernel/kernel-git/linux-2.6/drivers/acpi/acpica/exregion.c:129

exregion.c:129
        [...]=20
        /*
         * Does the request fit into the cached memory mapping?
         * Is 1) Address below the current mapping? OR        =20
         *    2) Address beyond the current mapping? =20
         */
        if ((address < mem_info->mapped_physical_address) ||
            (((acpi_integer) address + length) > ((acpi_integer)
                                                  mem_info->
                                                  mapped_physical_address +=
  =20
                                                  mem_info->mapped_length))=
) {
                /*
                 * The request cannot be resolved by the current memory map=
ping;
                 * Delete the existing mapping and create a new one.       =
    =20
                 */
                if (mem_info->mapped_length) {
        [...]
            =20

        Sergey

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqFGBUACgkQfKHnntdSXjRM4AQAn12hwvEv2TRn/CiaYNMwWb0E
y3JX0ybU17dYp+BbhA68ta1gkbMaH7ozfqWtfZ+OSNeqFte6faMhDBuMFydrldzk
p+LzNssbM/9bVb0iKxVo7KrDj0kkmsbOyKRILK8hwjmzvhTdMUAP4CxfarELU51X
rkup6O7fDW+5UKlULz4=
=jpCt
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
