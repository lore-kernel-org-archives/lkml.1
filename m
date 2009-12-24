Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbZLXAte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbZLXAte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 19:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZLXAte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 19:49:34 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:40486 "EHLO
	QMTA05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063AbZLXAtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 19:49:33 -0500
Message-ID: <4B32BABC.7020908@byu.net>
Date: Wed, 23 Dec 2009 17:50:04 -0700
From: Eric Blake <ebb9@byu.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: ctrn3e8 <ctrn3e8@gmail.com>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       =?ISO-8859-1?Q?Jean-Pie?= =?ISO-8859-1?Q?rre_Andr=E9?= 
	<jean-pierre.andre@wanadoo.fr>,
       fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>,
       Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, bug-coreutils <bug-coreutils@gnu.org>
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>	<87d427jscr.fsf@devron.myhome.or.jp> <4B3097C4.3060803@wanadoo.fr>	<874onjjnln.fsf@devron.myhome.or.jp> <4B30B67A.7080703@wanadoo.fr>	<87ljgvi1an.fsf@devron.myhome.or.jp> <4B30F0C9.2020702@wanadoo.fr> <87my1aevro.fsf@devron.myhome.or.jp> <4B3212ED.4090208@byu.net> <4B32B303.6070807@gmail.com>
In-Reply-To: <4B32B303.6070807@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

According to ctrn3e8 on 12/23/2009 5:17 PM:
> The strace has the following function call  (and it may be because I am
> looking at the trace rather than the actual source):

> utimensat(0, NULL, {UTIME_OMIT, UTIME_NOW}, 0) = 0

> The two don't seem to match.  Is this just because of the way the trace is printed?

Yes.  When the tv_nsec field is UTIME_OMIT or UTIME_NOW, the tv_sec field
is irrelevant.  Therefore, to save on space, strace omits the tv_sec field
in its output.  But rest assured that the kernel has read access to all
four 32-bit words located at the timespec pointer passed in the syscall.

> No mention of ntfs-3g support for nanosecond time stamping.

Read the rest of the thread on lkml - that is a known issue, which will
probably not be solved any sooner than January (all the patches this week
only dealt with mishandling of UTIME_OMIT).

- --
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Cygwin)
Comment: Public key at home.comcast.net/~ericblake/eblake.gpg
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksyurwACgkQ84KuGfSFAYDJ2gCgv9YMVwl7HL//ThRvQKJH5hSR
S/EAn0WzRr7FrFbkDHUtEfRdtXDdkqxT
=YpCl
-----END PGP SIGNATURE-----
