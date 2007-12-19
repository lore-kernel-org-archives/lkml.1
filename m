Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbXLSDIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbXLSDIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 22:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbXLSDIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 22:08:23 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60109 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbXLSDIW (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 22:08:22 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
       Rene Herman <rene.herman@keyaccess.nl>, yakui.zhao@intel.com,
       Chris Holvenstot <cholvenstot@comcast.net>,
       linux-kernel@vger.kernel.org, trenn@suse.de,
       Andrew Morton <akpm@osdl.org>
Subject: Re: pnpacpi : exceeded the max number of IO resources
In-Reply-To: Your message of "Wed, 05 Dec 2007 13:39:04 MST."
             <200712051339.04936.bjorn.helgaas@hp.com>
From: Valdis.Kletnieks@vt.edu
References: <1196428488.7066.6.camel@localhost> <1196729713.13969.1.camel@sli10-desk.sh.intel.com> <20071204011540.GA2713@darkstar.lan>
            <200712051339.04936.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1198033659_2768P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Dec 2007 22:07:39 -0500
Message-ID: <26206.1198033659@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1198033659_2768P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Dec 2007 13:39:04 MST, Bjorn Helgaas said:

> > -#define PNP_MAX_PORT		24
> > +#define PNP_MAX_PORT		128
> >  #define PNP_MAX_MEM		12
> >  #define PNP_MAX_IRQ		2
> >  #define PNP_MAX_DMA		2
> 
> I don't think we can increase PNP_MAX_PORT to 128.  Only one or two
> devices need that many, so just bumping the max wastes a LOT of space.
> A struct resource is seven longs, so on a 32-bit system with sixteen
> PNP devices, we'd be wasting (128-24)*7*4*16 = almost 47Kbytes.
> 
> In hindsight, I should not have removed drivers/acpi/motherboard.c
> until we had dynamic PNP resource tables.  We could revert that
> change [1], but the driver's been gone since 2.6.21, so I don't
> think it's that urgent.  It's just that we used to silently ignore
> resources past the limits, and in -mm, we now print a KERN_ERR message.
> 
> So I think we should either remove the message altogether (so we're
> exactly like 2.6.23 in this regard), or at least tone it down to
> a KERN_WARN or something.
> 
> And we need to get Thomas' dynamic patch into -mm ASAP :-)

*ping*! :)

My laptop still hits the PNP_MAX_MEM=12 warning in -rc5-mm1 - what's the
status on Thomas's patch?  No biggie - I just want to make sure it hasn't
been dropped through the cracks someplace....

--==_Exmh_1198033659_2768P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHaIr7cC3lWbTT17ARAj4EAKDxwSNyOd17emL8BYAFUlNSTwIa0ACfd58u
zdTW+wgZYVQLSVnBd7qqlZY=
=Esrb
-----END PGP SIGNATURE-----

--==_Exmh_1198033659_2768P--
