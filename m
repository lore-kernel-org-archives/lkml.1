Return-Path: <linux-kernel-owner+w=401wt.eu-S1423233AbXDYGji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423233AbXDYGji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423235AbXDYGji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:39:38 -0400
Received: from attic.omnifarious.org ([216.254.16.17]:44683 "EHLO
	attic.omnifarious.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423233AbXDYGjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:39:37 -0400
Subject: Re: Question about Reiser4
From: "Eric M. Hopper" <hopper@omnifarious.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070424001934.GC1663@thunk.org>
References: <462C4858.3050006@redhat.com>
	 <Pine.LNX.4.64.0704230555020.25153@server.thyself>
	 <462C4D32.4000909@redhat.com>
	 <Pine.LNX.4.64.0704230611430.25153@server.thyself>
	 <462C5034.9090403@redhat.com>
	 <Pine.LNX.4.64.0704230640540.25153@server.thyself>
	 <20070423010445.454eda63.akpm@linux-foundation.org>
	 <20070423135216.GA2744@omnifarious.org> <20070423225640.GA1663@thunk.org>
	 <462D46DF.4090802@zytor.com>  <20070424001934.GC1663@thunk.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tVh1sIkvssCkhV79AES5"
Organization: Omnifarious Software
Date: Tue, 24 Apr 2007 23:39:36 -0700
Message-Id: <1177483176.3315.32.camel@bats.omnifarious.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tVh1sIkvssCkhV79AES5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-04-23 at 20:19 -0400, Theodore Tso wrote:
> Sure, but Hans wants to change /etc/inetd.conf into /etc/inetd.conf.d,
> where you have: /etc/inetd.conf.d/telnet/port,
> /etc/inetd.conf.d/telnet/protocol, /etc/inetd.conf.d/telnet/wait,
> /etc/inetd.conf.d/telnet/userid, /etc/inetd.conf.d/telnet/daemon,
> etc. for each individual line in /etc/inetd.conf.  (And where each
> file might only contains 2-4 characters each: i.e., "23", "tcp",
> "root", etc.)

One interesting thing is that /proc already does this.  You can often
generate interesting behavior by writing something into a file in /proc.
If the config file for inetd.conf.d/tellnet/port changed, inetd could
automatically reconfigure that service, and just that service.  No more
re-reading a config file and trying to figure out what changed, you are
notified as soon as it changes on the FS by the FS change detection code
already in place.

It seems to me that being able to be more transparent about how your
on-disk data structures are structured has many interesting implications
and possible advantages.  It should be able to be explored by the wider
sphere of app developers.  Perhaps you are right, and the performance
implications of making all those system calls will be too much.  Or
maybe there's some good way nobody has thought of yet to handle that
problem.  But until the idea can be experimented on and played with,
nobody will know.

And realistically for that to happen Reiser4 has to be available as an
option in the kernels shipped by the major distributions.  And this in
turn requires that it be part of the mainline kernel.

Also, regardless of whether tiny files and on-disk datastructure
transparency exist, I think filesystems should also support ACID.  I
would, in fact, be much happier with ACID support at the filesystem
level than on-disk datastructure transparency.  And while Reiser4
doesn't do this, as I understand it (and I might be wrong) there is some
limited support for transactions built into it beyond simple lock
handling.

--=20
Eric Hopper (hopper@omnifarious.org  http://www.omnifarious.org/~hopper/)

--=-tVh1sIkvssCkhV79AES5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP MESSAGE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGLveojtsvlOwvazYRAk5rAJ4x6zZDRrUCwDR6KqxpXfTHCz8tgwCfWjUM
UMti//a9dTY41APrh0KHfPE=
=SurD
-----END PGP MESSAGE-----

--=-tVh1sIkvssCkhV79AES5--
