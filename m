Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbXLBTpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbXLBTpX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 14:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbXLBTpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 14:45:01 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49146 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbXLBTpA (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 14:45:00 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Machek <pavel@ucw.cz>
Cc: tvrtko.ursulin@sophos.com, Andi Kleen <andi@firstfloor.org>, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
In-Reply-To: Your message of "Sat, 01 Dec 2007 08:43:32 GMT."
             <20071201084332.GB4446@ucw.cz>
From: Valdis.Kletnieks@vt.edu
References: <p738x4i9nyd.fsf@crumb.suse.de> <OFFB86F10D.D565B603-ON802573A2.005A558C-802573A2.005B85B0@sophos.com>
            <20071201084332.GB4446@ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196624688_2962P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 02 Dec 2007 14:44:48 -0500
Message-ID: <17957.1196624688@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196624688_2962P
Content-Type: text/plain; charset=us-ascii

On Sat, 01 Dec 2007 08:43:32 GMT, Pavel Machek said:

> So what you are trying to do is 'application may never read bad
> sequence of bits from disk', right?

No, in many of the use cases, we're trying to do "if application reads certain
specified sequences of bits from disk we know about it", which is subtly
different.  Often, *absolute* prevention isn't required, as long as we can
generate audit trails and/or alerts...

> Now, how do you propose to solve mmap(MAP_SHARED)? The app on the other cpu may
> see the bad bits before kernel has chance to see them.

For many usage cases (such as virus scanners), mmap() isn't really an issue,
because if another process is *already* trying to mmap() the file before it's
even finished downloading from the network interface, you have other problems.
In that case, what you *really* want to be hooking is read() from a network
socket, not a disk file - and I don't think you can mmap() a socket anyhow,
right?

Similarly, if you're using these exit points to do *indexing*, you really don't
care if it got mmap()'ed - at worst, it isn't indexed until the other CPU gets
around to it.



--==_Exmh_1196624688_2962P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHUwswcC3lWbTT17ARAvRFAJ9ngiPXwfAy6Ahkk1PC5rsHv3pwcQCgzUug
XWAs2kxXxWMmk21uQoamj0M=
=MwR7
-----END PGP SIGNATURE-----

--==_Exmh_1196624688_2962P--
