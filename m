Return-Path: <linux-kernel-owner+w=401wt.eu-S1761235AbXE1LM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbXE1LM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 07:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbXE1LMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 07:12:53 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:42208 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbXE1LMw (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 07:12:52 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1 - a different BUG: at mm/slab.c:777 __find_general_cachep()
In-Reply-To: Your message of "Mon, 28 May 2007 13:43:12 +0300."
             <84144f020705280343q7e1646ar6961e7c0fa6b327f@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <13451.1180348036@turing-police.cc.vt.edu>
            <84144f020705280343q7e1646ar6961e7c0fa6b327f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180350764_4040P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 28 May 2007 07:12:44 -0400
Message-ID: <15652.1180350764@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180350764_4040P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <15646.1180350764.1@turing-police.cc.vt.edu>

On Mon, 28 May 2007 13:43:12 +0300, Pekka Enberg said:
> On 5/28/07, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> > [4294667.472000] BUG: at mm/slab.c:777 __find_general_cachep()
> 
> [snip]
> 
> > Any suggestions before I go doing the bisect shuffle?
> 
> It's complaining about a kmalloc() with size zero. The warning is new
> and harmless for now, so no need to bisect this (it will point you at
> the mm/slab.c change by Christoph Lameter).

I knew *that* part.  Closer look at drivers/firmware/dmi-id.c indicates that
it's likely a busticated DMI field in my BIOS - looking around at the stuff in
/sys/devices/virtual/dmi/id I found that the files product_version, board_version
board_asset_tag, chassis_version, and chassis_asset_tag are empty (trying
to 'cat' them gets just a \n) - the other values all look sane.

This looks fishy:

#define ADD_DMI_ATTR(_name, _field)         if (dmi_get_system_info(_field))                 sys_dmi_attributes[i++] = & sys_dmi_##_name##_attr.attr;

Should that be making a check that it's not pointing at a null string?


--==_Exmh_1180350764_4040P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGWrkscC3lWbTT17ARAkIdAJ4h2qL1+S/aUpxS5ER9hban8tII+wCeIuLp
Td/6OgEnHThmStaqdIutk3s=
=a8TY
-----END PGP SIGNATURE-----

--==_Exmh_1180350764_4040P--
