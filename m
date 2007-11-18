Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbXKRJk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbXKRJk7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 04:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbXKRJks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 04:40:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbXKRJkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 04:40:46 -0500
Message-ID: <474007B3.30205@redhat.com>
Date: Sun, 18 Nov 2007 01:36:51 -0800
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv3 0/4] sys_indirect system call
References: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com> <473FED5F.2010303@zytor.com>
In-Reply-To: <473FED5F.2010303@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

H. Peter Anvin wrote:
> It seems to me that we could accomplish the same thing by passing the
> number of parameters in the upper bits of the system call number
> register (%eax in the case of x86.)

This isn't really a generic solution.  The number of parameters is
limited to six.  There are syscalls with six parameters already.  There
are many more with five which could only handle one more parameter.

Also, is it really simpler?  You'd need to have another table which
contains the default number of parameters a system call takes so that
you can fill in the default value of zero.  This extra memory access has
to be performed for every system call.

I think it is unlikely that this approach is faster.  To the contrary,
I'd guess.

I don't have much invested into this but it seems the sys_indirect
approach is so much simpler.  Overhead is only paid if you really need
it which is rarely the case.  Plus, you might have heard Linus and Zack
talk about syslets again.  Starting syslets can be done using the same
interface, I guess.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHQAez2ijCOnn/RHQRAjoHAJ4/Qq4ygaZ4uq6uCIVNq4hfN1m2pACgpJFi
Z/vBsGFpUc/EUz+VW66jEIY=
=B19x
-----END PGP SIGNATURE-----
