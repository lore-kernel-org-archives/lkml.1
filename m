Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYCNHTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYCNHTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 03:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYCNHTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 03:19:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbYCNHTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 03:19:07 -0400
Message-ID: <47DA257C.9060409@redhat.com>
Date: Fri, 14 Mar 2008 00:13:00 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080303)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: bharata@linux.vnet.ibm.com, libc-alpha@sourceware.org,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [RFC] Union mount readdir support in glibc
References: <20080311055527.GA7256@in.ibm.com> <47D9F6CC.6010009@redhat.com> <20080314053925.GA10722@ZenIV.linux.org.uk>
In-Reply-To: <20080314053925.GA10722@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Al Viro wrote:
> How about "the first entry returned by getdents(3) after open() is a whiteout
> for e.g. '.'"?  No fstat needed, zero impact for normal directories,
> zero impact for any binaries on old kernels (where you wouldn't have
> unions) and zero impact for old binaries on new kernels unless they
> do getdents() on directory that happens to be a union.

Your definition of "zero impact" doesn't quite match mine.  This would
require significant changes.


> And no lockstep...

Of course there is lockstep.  It is not under the application's control
whether a directory is a union fs or not.  Every implementation except a
pure kernel implementation has this problem.


>> - - How does this work with NFS?
> 
> It won't, kernel-side or done in userland.

Why wouldn't a kernel-side implementation work?


> Actually, do we really need it other than to 0 and to current position
> (i.e. full rewind and a no-op)?

Ever heard of the little function "telldir"?

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkfaJXwACgkQ2ijCOnn/RHSRpQCZAXNktqSs6WRvxIlTlzUd6GC5
PrAAnRecjUcM6ZHoclzXrFFCsBWuIgid
=8pZl
-----END PGP SIGNATURE-----
