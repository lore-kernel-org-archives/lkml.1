Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbYAIH43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbYAIH43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 02:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYAIH4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 02:56:20 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60013 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYAIH4U (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 02:56:20 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Andi Kleen <andi@firstfloor.org>, Theodore Tso <tytso@mit.edu>,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: The ext3 way of journalling
In-Reply-To: Your message of "Tue, 08 Jan 2008 22:21:02 EST."
             <8DEA7347-120C-4A97-A208-2577ED88F799@mac.com>
From: Valdis.Kletnieks@vt.edu
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <p73odbwqmx2.fsf@bingen.suse.de> <slrnfo7b3a.6m2.tuomov@jolt.modeemi.cs.tut.fi> <20080108181525.GL27800@mit.edu> <p734pdoqbva.fsf@bingen.suse.de>
            <8DEA7347-120C-4A97-A208-2577ED88F799@mac.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199865353_3703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Jan 2008 02:55:53 -0500
Message-ID: <22619.1199865353@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199865353_3703P
Content-Type: text/plain; charset=us-ascii

On Tue, 08 Jan 2008 22:21:02 EST, Kyle Moffett said:

> lvcreate -s -n "${VOLUME}-snap" "${VG}/${VOLUME}"


> Basically you can fsck the offline snapshot in the background.

Something the lvcreate manpage is specifically not clear about is:

Does this create a snapshot of the *disk* at that moment, or does it capture
"disk plus still-to-be-written blocks in the cache"? (Phrased differently, does
it Do The Right Thing regarding "blocks queued before lvcreate" and "blocks
queued for write after lvcreate")?

If the snapshot doesn't capture the blocks queued but still unwritten by
kjournald and similar, then you're still hitting the same old problems that
you always get when you fsck an "active disk".

--==_Exmh_1199865353_3703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHhH4JcC3lWbTT17ARAnyZAJ4kNHkzWhExqI7Ixs3hzG5iltYaFACfWCYs
hcPh59JbkgM702ChJhH65Yc=
=f/oM
-----END PGP SIGNATURE-----

--==_Exmh_1199865353_3703P--
