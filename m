Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbZIYH3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbZIYH3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZIYH3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:29:51 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:63570 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbZIYH3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:29:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TK4Hb86fr2PBXJmqb0337WRjuLH5vl2H658LD03+yQ64wDXoD7DNbS0I7hEpy5dZ2b
         Sq1uqhxYVX4Zm05EskfSKrscHAduC2d1GwtZ4mf0RgiKogyvdYlrEfRymfzLgV97Lm7O
         dlBinoxG624hjwb384NBhu9vx86BYGGtmZTBc=
Date: Fri, 25 Sep 2009 07:22:48 +0000
From: Andy Spencer <andy753421@gmail.com>
To: David Wagner <daw-news@cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Privilege dropping security module
Message-ID: <20090925072248.GB9821@c.hsd1.tn.comcast.net>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
 <4ABA892A.9090804@schaufler-ca.com>
 <20090923223110.GA1449@c.hsd1.tn.comcast.net>
 <h9g795$9om$1@taverner.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_c-9986-1253863392-0001-2"
Content-Disposition: inline
In-Reply-To: <h9g795$9om$1@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_c-9986-1253863392-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> If I understand correctly, this isn't sufficient to run untrusted code,
> because it only restricts access to the filesystem.  You gotta restrict
> access to the network, interaction with other processes, and so on.
> (For instance, does dpriv let the untrusted process take over another of
> your processes using ptrace?)

Yes, currently dpriv allows a process to take over another process using
ptrace. However, I plan on supporting limits on ptrace (and other
things) in the future.


> I suspect making all permissions recursive is going to lead to overly
> permissive policies.  Suppose I want to allow read access to everything
> under /lib and /usr/lib, read-execute access to everything under /bin
> and /usr/bin, and read-write access to everything under /tmp.  (But I
> do not want to allow any access to any other directories.)  How do I
> do it?

The important thing is that limits can be overridden while they are
still in the stage. This allows you to deny access to a directory, but
still allow access to specific subdirectories.

  $ echo -----X /        > /sys/kernel/security/dpriv/stage
  $ echo r--R-X /lib     > /sys/kernel/security/dpriv/stage
  $ echo r--R-X /usr/lib > /sys/kernel/security/dpriv/stage
  $ echo r-xR-X /bin     > /sys/kernel/security/dpriv/stage
  $ echo r-xR-X /usr/bin > /sys/kernel/security/dpriv/stage
  $ echo rw-RWX /tmp     > /sys/kernel/security/dpriv/stage
  $ echo commit          > /sys/kernel/security/dpriv/control

Does this answer your question? It should be noted that you can still
walk to any directory because X is allowed on /. To prevent this you
would have to allow X on / and then specifically deny X on /*/, but
expanding * is something that I would rather have done in userspace.

--=_c-9986-1253863392-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq8b+AACgkQz1OYJ/s1XTCZDACg037c6edQaOfmR+HbHSDJ8XG2
GsMAnRVceV2y5BntfkN2EKuwNxFd/BjY
=sF/J
-----END PGP SIGNATURE-----

--=_c-9986-1253863392-0001-2--
