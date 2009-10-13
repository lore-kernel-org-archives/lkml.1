Return-Path: <linux-kernel-owner+w=401wt.eu-S1751391AbZJMENI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbZJMENI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 00:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZJMENH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 00:13:07 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41975 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZJMENG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 00:13:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roman Zippel andr <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hfs: fix oops on mount with corrupted btree extent records
In-Reply-To: Your message of "Mon, 12 Oct 2009 20:41:37 EDT."
             <4AD3CCC1.9020102@suse.com>
From: Valdis.Kletnieks@vt.edu
References: <4AD3CCC1.9020102@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1255407123_3557P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Oct 2009 00:12:03 -0400
Message-ID: <14762.1255407123@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.35.215 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4AD3FE14.01D1,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1255407123_3557P
Content-Type: text/plain; charset=us-ascii

On Mon, 12 Oct 2009 20:41:37 EDT, Jeff Mahoney said:
>  A particular fsfuzzer run caused an hfs file system to crash on mount. This
>  is due to a corrupted MDB extent record causing a miscalculation of
>  HFS_I(inode)->first_blocks for the extent tree. If the extent records
>  are zereod out, it won't trigger the first_blocks special case. Instead
>  it falls through to the extent code which we're still in the middle
>  of initializing.
> 
>  This patch catches the 0 size extent records, reports the corruption,
>  and fails the mount.

Just for completeness - does the current fsck.hfs already know how to fix it, or
at least heave stuff over the side so the filesystem is self-consistent again?
Or will a user who hits this need a new fsck.hfs to get it back to mountable?

--==_Exmh_1255407123_3557P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK0/4TcC3lWbTT17ARAi4gAKCFKumzgSHNv+7cLfcVLA7uiaVp5ACgqhkn
nR4oH3u/QhRiHGbwHTO5UBo=
=wNE3
-----END PGP SIGNATURE-----

--==_Exmh_1255407123_3557P--

