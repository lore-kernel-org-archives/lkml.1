Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbYDUGYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbYDUGYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 02:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYDUGX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 02:23:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbYDUGXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 02:23:55 -0400
Message-ID: <480C323B.3060608@redhat.com>
Date: Sun, 20 Apr 2008 23:20:43 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080407)
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org
Subject: Re: [PATCH] utimensat() non-conformances and fixes
References: <47FA9DA1.8040508@gmail.com>
In-Reply-To: <47FA9DA1.8040508@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Michael Kerrisk wrote:
> 1. The draft POSIX.1-200x specification for utimensat() says that if a
> times[n].tv_nsec field is UTIME_OMIT or UTIME_NOW, then the value in the
> corresponding tv_sec field is ignored.  However the current Linux
> implementation requires the tv_sec value to be zero (or the EINVAL error
> results).  This requirement should be removed.

OK, for now.  I think the implemented behavior is better, though.


> However, the current implementation does not generate
> EPERM if one tv_nsec field is UTIME_NOW while the other is UTIME_OMIT -- it
> should give this error for that case.

This is probably a necessary change.  Non-synchronized changes might be
a security problem.


> However, in
> the same circumstances, when utimensat() is given a 'times' array in which
> both tv_nsec fields are UTIME_NOW, which provides equivalent functionality
> to specifying 'times' as NULL, the call succeeds.  I think that it should fail
> with the error EACCES in this case.

I guess so.


> (times == NULL && times[0].tv_nsec == UTIME_NOW && times[1].tv_nsec ==
> UTIME_NOW)
> 
> case should be treated like the traditional utimes() case where 'times'
> is NULL.  That is, the call should succeed for a file marked append-only
> and should give the error EACCES if the file is marked as immutable.

Is this something I changed?  I doubt I added this.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkgMMjsACgkQ2ijCOnn/RHT9dwCgxhprkeAg86sW11ilKtHaVYtO
Ae0An18utIREI/MnfwPO5HixxZbJz7zD
=hrvK
-----END PGP SIGNATURE-----
