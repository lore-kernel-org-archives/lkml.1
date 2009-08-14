Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZHNHhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZHNHhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 03:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbZHNHhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 03:37:19 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:38884 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbZHNHhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 03:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YvyUG1h+3/A1hF2xEX+HgO1YId4NF5hYSyY/hzWNTisL+XqMfxxTWlerg1tg47DBi+
         4e/l9paoQ3Vg6xemkc8pf/7vVfbWqmf5OYty29OPjHCZeBjSfpo1SFXray+9WB6EsimI
         aTx/Ilxq6TRURPKJMDNN0zK+UT4dV5Yc7jXe8=
Date: Fri, 14 Aug 2009 10:40:33 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Len Brown <lenb@kernel.org>, "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090814074033.GA3046@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
 <20090813124647.GA19195@localdomain.by>
 <1250217283.2987.16.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <1250217283.2987.16.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/14/09 10:34), Lin Ming wrote:
> Hi, Sergey
>=20
Hi Lin,

> Could you please help to locate the line of code that causes oops, as
> below?
>    =20
According to EIP, acpi_ex_system_memory_space_handler+0x75
0x0000023f <acpi_ex_system_memory_space_handler+94>:    call   0x240 <acpi_=
ex_system_memory_space_handler+95>
0x00000244 <acpi_ex_system_memory_space_handler+99>:    mov    $0x3004,%eax=
                                 =20
0x00000249 <acpi_ex_system_memory_space_handler+104>:   add    $0x10,%esp
0x0000024c <acpi_ex_system_memory_space_handler+107>:   jmp    0x3f5 <acpi_=
ex_system_memory_space_handler+532>
0x00000251 <acpi_ex_system_memory_space_handler+112>:   mov    $0x1,%eax
0x00000256 <acpi_ex_system_memory_space_handler+117>:   mov    0x8(%ebx),%e=
dx  	<<
0x00000259 <acpi_ex_system_memory_space_handler+120>:   mov    %edx,-0x28(%=
ebp)
0x0000025c <acpi_ex_system_memory_space_handler+123>:   cmp    %edx,-0x14(%=
ebp)
                                                         =20
which I belive is (marked with __):
        /*
         * Does the request fit into the cached memory mapping?
         * Is 1) Address below the current mapping? OR        =20
         *    2) Address beyond the current mapping? =20
         */
        if ((__ address __ < mem_info->mapped_physical_address) ||
            (((acpi_integer) address + length) > ((acpi_integer)
                                                  mem_info->
                                                  mapped_physical_address +
                                                  mem_info->mapped_length))=
) {
               =20

> 1. Compile the kernel with debug info
>    Kernel menuconfig -> Kernel hacking -> Compile the kernel with debug i=
nfo
>=20
> 2. Retest until it oops, here you get the address of code that causes oop=
s.
>    addr2line -e vmlinux <the address>
>=20
Sure, will try.


        Sergey

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqFFPEACgkQfKHnntdSXjTIYQQAvr7ZpltyigmVe9UjK7OU3CVs
pRRriga9XhpNQQoSwgF8E16x7tpTD50OQZVekKiwUtwY3skGi8s77Bi6lhLABPod
peZNO7MwbzTmrMjC/v57FvwStvBKOiQbWhccCU7lHJ67Znoyr1YiGH0Y5DB0hlbX
BS4BtFkELuzjJr6bdzs=
=NQH1
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
