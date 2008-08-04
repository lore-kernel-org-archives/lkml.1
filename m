Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYHDATe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYHDATe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 20:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYHDATZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 20:19:25 -0400
Received: from home.keithp.com ([63.227.221.253]:3401 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbYHDATY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 20:19:24 -0400
Subject: Re: files/process scaling problem? (was: [PATCH] Export
	shmem_file_setup and shmem_getpage for DRM-GEM)
From: Keith Packard <keithp@keithp.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: keithp@keithp.com, John Stoffel <john@stoffel.org>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200808040135.32563.ioe-lkml@rameria.de>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <18581.43362.460694.60862@stoffel.org>
	 <1217785943.23437.330.camel@koto.keithp.com>
	 <200808040135.32563.ioe-lkml@rameria.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C5MAdxYvXdex8ST+ZUZF"
Date: Sun, 03 Aug 2008 17:19:12 -0700
Message-Id: <1217809152.23437.401.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-C5MAdxYvXdex8ST+ZUZF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 01:35 +0200, Ingo Oeser wrote:

> What actions on many thousand fds are supported poorly or not at all?
> Are you only concerned about the memory requirements?

I didn't notice that the change in the maximum number of fds per process
from 1024 to 1024*1024 back in February. That makes it possible,
although requiring root privs, to allocate enough fds for this to work.

The other issue is that several important applications (including the X
server) use select instead of poll, and they have a small maximum number
of fds that they support. It seems like this could be worked around by
dup2'ing the shmem fds up a ways.

> Please elaborate or point me to a place where you did already :-)

I should have looked at fs/file.c.

--=20
keith.packard@intel.com

--=-C5MAdxYvXdex8ST+ZUZF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIlksAQp8BWwlsTdMRAkAIAJoDt///V5R6JHmDi5D8xJfq42DL1gCfQ52C
5zmo2XmntaHOey5p4fHT/Gc=
=iGaD
-----END PGP SIGNATURE-----

--=-C5MAdxYvXdex8ST+ZUZF--

