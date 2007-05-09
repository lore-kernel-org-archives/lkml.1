Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXEIRRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXEIRRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbXEIRRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:17:36 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56063 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbXEIRRg (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:17:36 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 - Kconfig horkage
In-Reply-To: Your message of "Wed, 09 May 2007 10:07:56 PDT."
             <Pine.LNX.4.64.0705091007050.28520@schroedinger.engr.sgi.com>
From: Valdis.Kletnieks@vt.edu
References: <20070509012322.199f292b.akpm@linux-foundation.org> <5713.1178722647@turing-police.cc.vt.edu>
            <Pine.LNX.4.64.0705091007050.28520@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178731018_3418P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 May 2007 13:16:58 -0400
Message-ID: <7574.1178731018@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178731018_3418P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <7568.1178731018.1@turing-police.cc.vt.edu>

On Wed, 09 May 2007 10:07:56 PDT, Christoph Lameter said:
> On Wed, 9 May 2007, Valdis.Kletnieks@vt.edu wrote:
> > 1) Spotted in init/Kconfig:
> > 
> > config SLUB_DEBUG
> >         default y
> >         bool "Enable SLUB debugging support" if EMBEDDED
> >         help
> > 
> > Shouldn't that have an 'default SLUB' or 'if SLUB' or something attached to it?
> 
> Maybe. Is there a problem with SLUB_DEBUG being set if SLUB is not 
> selected?

% egrep 'SL[AU]B' /usr/src/linux-2.6.21-mm2/.config
# CONFIG_SLUB_DEBUG is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_DEBUG_SLAB is not set

Just seemed odd to do a 'make oldconfig' and get prompted for the value, and it
gave a value of 'Y' to a debug  option of a feature that wasn't selected.  :)

It took me a while to convince myself that somebody hadn't changed the default
to CONFIG_SLUB while I wasn't looking....

(Maybe the order of entries needs fixing - SLAB, SLAB_DEBUG, SLUB, SLUB_DEBUG,
so that oldconfig and friends don't pop the question for debugging till *after*
they ask if the feature should be included?

--==_Exmh_1178731018_3418P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGQgIKcC3lWbTT17ARAoHEAJ4gKG5oIMpQfLqXAoSvPXnu5gd1bQCggeSY
QojLHjC/zVrMxlOI+OZ0d4E=
=mpOl
-----END PGP SIGNATURE-----

--==_Exmh_1178731018_3418P--
