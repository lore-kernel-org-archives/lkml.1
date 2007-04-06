Return-Path: <linux-kernel-owner+w=401wt.eu-S1767749AbXDFP1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767749AbXDFP1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 11:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767748AbXDFP1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 11:27:03 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51330 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767749AbXDFP1B (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 11:27:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: Your message of "Thu, 05 Apr 2007 13:31:09 PDT."
             <20070405133109.fe416273.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <7763.1175792579@turing-police.cc.vt.edu>
            <20070405133109.fe416273.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175873184_4439P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 06 Apr 2007 11:26:24 -0400
Message-ID: <4532.1175873184@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175873184_4439P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <4522.1175873175.1@turing-police.cc.vt.edu>

On Thu, 05 Apr 2007 13:31:09 PDT, Andrew Morton said:
> On Thu, 05 Apr 2007 13:02:59 -0400, Valdis.Kletnieks@vt.edu wrote:

> > Am seeing an Oops 'cannot handle kernel paging request' during late
> > system startup, hand-copied traceback follows:
> > 
> > avc_has_perm_noaudit+0x2bf/0x506
> > avc_has_perm+0x2b/0x5b
> > selinux_socket_stream_connect+0x7e/0xc3
> > unix_stream_connect+0x202/0x3f3
> > sys_connect+0x7e/0xa4
> > tracesys+0xde/0xe1

> Thanks.
> 
> I'd have thought that the full trace could be captured with netconsole.

I didn't have a second box available at first.  Then I blew close to 45
minutes trying to figure out why netconsole was totally failing to work,
before I found this in .config:

# CONFIG_NETCONSOLE is not set

"Do'h!" -- H. Simpson

Unfortunately, defining netconsole caused NETPOLL to be defined, which caused
a recompile of half the known world, and the symptoms of the crash moved.

Film at 11, once I figure out what's going on, and fix the testbed in my
office so I can actually catch this sucker - I may have to string a serial
cable.  One solid good data point:

21-rc5 with only the -mm4 'origin.patch' applied is OK, so whatever the
issue is, it's not in Linus's tree.


--==_Exmh_1175873184_4439P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGFmagcC3lWbTT17ARApjzAJ9dW/rRYOxJSPLu+5HT16EzgeOGfACfbj6l
KmOu9/CH4V5v+oBR/iPIBlc=
=Hsvr
-----END PGP SIGNATURE-----

--==_Exmh_1175873184_4439P--
