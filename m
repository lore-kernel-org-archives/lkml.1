Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbZLWMxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbZLWMxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 07:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZLWMxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 07:53:38 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:47638 "EHLO
	QMTA08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755109AbZLWMxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 07:53:37 -0500
Message-ID: <4B3212ED.4090208@byu.net>
Date: Wed, 23 Dec 2009 05:54:05 -0700
From: Eric Blake <ebb9@byu.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: =?ISO-8859-1?Q?Jean-Pierre_Andr=E9?= <jean-pierre.andre@wanadoo.fr>,
       fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>,
       Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, ctrn3e8 <ctrn3e8@gmail.com>,
       bug-coreutils <bug-coreutils@gnu.org>
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>	<87d427jscr.fsf@devron.myhome.or.jp> <4B3097C4.3060803@wanadoo.fr>	<874onjjnln.fsf@devron.myhome.or.jp> <4B30B67A.7080703@wanadoo.fr>	<87ljgvi1an.fsf@devron.myhome.or.jp> <4B30F0C9.2020702@wanadoo.fr> <87my1aevro.fsf@devron.myhome.or.jp>
In-Reply-To: <87my1aevro.fsf@devron.myhome.or.jp>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

According to OGAWA Hirofumi on 12/22/2009 10:58 AM:
>> I suggest I port Miklos patch to fuse-lite soon,
>> and delay the low-level case (and microsecond
>> precision) until January. Does that suit your needs ?
> 
> Thanks. Sounds good. I'm not using ntfs-3g actually, I just bridged the
> bug report on lkml to others. Eric?

I'm also bridging the report from a coreutils user (now cc'd).  Since I
also don't use ntfs-3g, I'm hoping that ctrn3e8 will be able to help test
whether the latest patch to ntfs-3g makes a difference in properly setting
times.  To me, delaying precision while fixing UTIME_OMIT semantics is a
reasonable approach.

By the way, is there any reliable way, other than uname() and checking for
a minimum kernel version, to tell if all file systems will properly
support UTIME_OMIT?  For coreutils 8.3, we will be inserting a workaround
where instead of using UTIME_OMIT, we call fstatat() in advance of
utimensat() and pass the original timestamp down.  But it would be nice to
avoid the penalty of the extra stat if there were a reliable way to ensure
that, regardless of file system, the use of UTIME_OMIT will be honored.
After all, coreutils wants touch(1) to work regardless of how old the
user's kernel and file system drivers are.

- --
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Cygwin)
Comment: Public key at home.comcast.net/~ericblake/eblake.gpg
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksyEu0ACgkQ84KuGfSFAYCrzACgirIjqmS7vFOBcI8xau6jHEa0
4L0AnAjJkje+tSMF/FZkTbkohg/fhQ+i
=ngx0
-----END PGP SIGNATURE-----
