Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbZEECrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbZEECrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 22:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZEECrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 22:47:01 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55773 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZEECrA (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 22:47:00 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Chris Peterson <cpeterso@cpeterso.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: const-correctness warnings from gcc -Wwrite-strings?
In-Reply-To: Your message of "Mon, 04 May 2009 17:00:59 PDT."
             <a24804730905041700i66418576q7b146b05e78884d3@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <a24804730905041700i66418576q7b146b05e78884d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1241491620_53910P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 04 May 2009 22:47:00 -0400
Message-ID: <58227.1241491620@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1241491620_53910P
Content-Type: text/plain; charset=us-ascii

On Mon, 04 May 2009 17:00:59 PDT, Chris Peterson said:
> I am preparing a patch that would fix some const-correctness warnings
> when compiling the kernel with gcc -Wwrite-strings. I am not (yet?)
> proposing that the kernel Makefile should use -Wwrite-strings.
> 
> String constants are not writable, but without -Wwrite-strings, gcc
> pretends string constants have type non-const char[] to support lazy
> legacy code. :)

Do you have an estimate of how large/intrusive the patch will end up being?

Tossing in a few 'const' s in function signatures shouldn't be too bad.
A bigger problem will be code that does stuff like:

const char foo[] = "defaultstr";

void bar (char *wumpus)
{
	baz(wumpus?wumpus:foo);
}

which might get more interesting...

--==_Exmh_1241491620_53910P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ/6ikcC3lWbTT17ARAhIoAKCefMpFhMGOKhQbBSKdDd0qX4dZVQCg3RaY
qCWOmR+12lhb+hErxMDOb2w=
=eN08
-----END PGP SIGNATURE-----

--==_Exmh_1241491620_53910P--
