Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbXD0LJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbXD0LJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 07:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbXD0LJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 07:09:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609AbXD0LJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 07:09:03 -0400
Message-ID: <4631D9CD.4050106@suse.com>
Date: Fri, 27 Apr 2007 07:09:01 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       reiserfs-dev@namesys.com
Subject: Re: 2.6.21 reiserfs -- cicular locking?
References: <200704261640.15068.david-b@pacbell.net>	<20070426224408.fd525b46.akpm@linux-foundation.org>	<s5hy7kew2m8.wl%tiwai@suse.de> <s5hbqhaytph.wl%tiwai@suse.de>
In-Reply-To: <s5hbqhaytph.wl%tiwai@suse.de>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Takashi Iwai wrote:
> At Fri, 27 Apr 2007 12:09:03 +0200,
> I wrote:
>> I got a similar bug right now at the fresh boot of 2.6.21.
>>
>>
>> ReiserFS: sda2: found reiserfs format "3.6" with standard journal
>> ReiserFS: sda2: using ordered data mode
>> ReiserFS: sda2: journal params: device sda2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
>> ReiserFS: sda2: checking transaction log (sda2)
>> ReiserFS: sda2: Using r5 hash to sort names
>> ReiserFS: sda2: Removing [3613 1354701 0x0 SD]..done
>> ReiserFS: sda2: There were 1 uncompleted unlinks/truncates. Completed
>>
>> =======================================================
>> [ INFO: possible circular locking dependency detected ]
>> 2.6.21-work #1
>> -------------------------------------------------------
>> mktemp/1459 is trying to acquire lock:
>>  (&REISERFS_I(inode)->xattr_sem){..--}, at: [<e08a5236>] reiserfs_cache_default_acl+0x2a/0x9c [reiserfs]
>>
>> but task is already holding lock:
>>  (&inode->i_mutex){--..}, at: [<c016d7dc>] open_namei+0xe2/0x5a2
>>
>> which lock already depends on the new lock.
> The message disappears when I revert the patch:
> 
> commit 9b7f375505f5611efb562065b57814b28a81abc3
> Author: Jeff Mahoney <jeffm@suse.com>
> Date:   Mon Apr 23 14:41:17 2007 -0700
> 
>     reiserfs: fix xattr root locking/refcount bug
>     
> 
> So, likely a newly introduced bug after rc7...

I got a message with a trace similar to this from Vladimir before I
submitted that patch. I'm not sure how to annotate this, since the
xattr_sem can never be taken in the manner described. Internal inodes
are protected by I_PRIVATE.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGMdnNLPWxlyuTD7IRApM+AJwKynnSbQfGKByzvDFs5d0OqO82ggCfVzoP
MNzGHMUQdmn2Xg31QWhB3mQ=
=A37l
-----END PGP SIGNATURE-----
