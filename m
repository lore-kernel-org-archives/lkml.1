Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbYLOL65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbYLOL65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 06:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbYLOL6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 06:58:49 -0500
Received: from dovecot.org ([82.118.211.50]:52405 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbYLOL6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 06:58:48 -0500
X-Greylist: delayed 1629 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Dec 2008 06:58:48 EST
Message-Id: <E459FC1E-BD45-459A-A9BD-AC682DBCD2D2@iki.fi>
From: Timo Sirainen <tss@iki.fi>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-60--222096787"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: 2.6.27 inotify causes unkillable processes with 100% CPU usage
Date: Mon, 15 Dec 2008 13:31:29 +0200
Cc: nuitari-dovecot@nuitari.net, Arno Wald <arno.wald@netcologne.de>,
       David Rosenstrauch <darose@darose.net>
X-Pgp-Agent: GPGMail d51 (Leopard)
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-60--222096787
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

There appears to be a bug in 2.6.27 and inotify where it causes  
processes in running state to eat 100% CPU and they can't be killed  
with kill -9, requiring a reboot to get rid of them.

3 people (Cc'd) so far have reported this to me, all of them last  
week. The problem shows up when running my Dovecot IMAP server. Its  
imap processes start hanging, apparently it can happen after running  
for only a couple of minutes:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
6717 arno      20   0  2964 1608 1192 R  100  0.2   1158:05 imap

Only the imap processes hang (Dovecot has a few others). The only  
thing special about it is that it uses inotify. After disabling  
Dovecot's inotify support at least one of the people (Arno) reported  
that he can't reprocuce the bug anymore. He also couldn't reproduce  
the bug with 2.6.26 kernel.

I don't think Dovecot does anything special with its inotify code. It  
just listens on two directories. You can find the code here: http://hg.dovecot.org/dovecot-1.1/file/f9a000ee400d/src/lib/ioloop-notify-inotify.c

Kernels causing the hang:

2.6.27-9.slh.1-sidux-686
Arch Linux, kernel 2.6.27.8
Gentoo with 2.6.27-gentoo-r5, amd64, 2 dual core opterons

Not causing the hang:

2.6.26-6.slh.1-sidux-686


--Apple-Mail-60--222096787
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (Darwin)

iEYEARECAAYFAklGQBEACgkQyUhSUUBVislAQwCdELIvIxggRRFjSLVHxR1nN/MU
0TwAoJHq9DTELgo2Gyb/Y0VXZG800FW1
=CjPd
-----END PGP SIGNATURE-----

--Apple-Mail-60--222096787--
