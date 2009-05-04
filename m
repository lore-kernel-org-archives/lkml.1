Return-Path: <linux-kernel-owner+w=401wt.eu-S932206AbZEDQlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbZEDQlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757723AbZEDQk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:40:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756849AbZEDQk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:40:57 -0400
Message-ID: <49FF1A7F.4010307@suse.com>
Date: Mon, 04 May 2009 12:40:31 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       David <david@unsolicited.net>
Subject: Re: [PATCH] reiserfs: Expand i_mutex to enclose lookup_one_len
References: <49FB1F20.8040400@suse.com> <20090503085236.GT8633@ZenIV.linux.org.uk> <20090503091507.GU8633@ZenIV.linux.org.uk> <49FE7448.2040302@suse.com> <20090504061327.GG8633@ZenIV.linux.org.uk>
In-Reply-To: <20090504061327.GG8633@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Al Viro wrote:
> On Mon, May 04, 2009 at 12:51:20AM -0400, Jeff Mahoney wrote:
> 
>> Huh. I didn't see that still in there. That's an artifact of an earlier
>> version of the code where I kept a reference to /.reiserfs_priv/xattrs.
>> Then I decided that .reiserfs_priv was all I needed to cache (to avoid
>> recursive i_mutex locking on the fs root) and dropped the caching of
>> xattrs. Looks like it didn't get totally cleared out.
> 
> It's not that simple ;-/  You check it in journalling code, AFAICS in order
> to decide how much will that sucker take (due to extra mkdir?) and something
> will need to be done with that check.

Yes, it's for an extra mkdir. Now that I've gotten some sleep and looked
at the code again, I see what you're saying. At least it's broken in a
performance way instead of causing a system crash or data corruption.

> Anyway, I'm going to push all that stuff to #for-next, so that -next would
> pick it.  I have *not* touched the xattr_root logics, so if you could do
> that on top of your patch + my incremental...

Ok, I'll fix that up and get some testing in.

- -Jeff


- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkn/Gn4ACgkQLPWxlyuTD7KclACeLNAOawW5fDxc2CqGZz4NUXpY
21AAoJdsK3EEPweBCuv1131j3Lm8x3lk
=0Iqb
-----END PGP SIGNATURE-----
