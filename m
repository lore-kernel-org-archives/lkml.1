Return-Path: <linux-kernel-owner+w=401wt.eu-S1751454AbZELRVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbZELRVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZELRVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:21:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbZELRVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:21:17 -0400
Message-ID: <4A09AFD1.5090604@suse.com>
Date: Tue, 12 May 2009 13:20:17 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-parisc@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       reiserfs-devel@vger.kernel.org
Subject: Re: 2.6.30-rc5: reiserfs is broken on parisc (bisected)
References: <a4423d670905120940r5de3eab7v7e8e92d89107b962@mail.gmail.com>
In-Reply-To: <a4423d670905120940r5de3eab7v7e8e92d89107b962@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Alexander Beregalov wrote:
> Hi
> 
> ab17c4f02156c4f75d7fa43a5aa2a7f942d47201 is the first bad commit
> (reiserfs: fixup xattr_root caching)
> 
> Kernel panics when init tries to remount rootfs (reiserfs) with
> read-write access.
> Read-only access works fine.
> 
> No more messages on the screen before panic.
> 
> Is it endianess related?

No, not at all. There was a problem with the xattr code if the kernel
was built with xattrs disabled. It assumed that
REISERFS_SB(s)->xattr_root would be available, which isn't the case when
xattrs aren't enabled. Part of it has been cleaned up in -git1, and I've
sent Al some additional patches to fix the rest of it up.

There's a thread called "reiserfs xattr fixups" that contains 4 patches.
The patch marked with * is the one I believe will fix your problem.

- - reiserfs: cleanup ifdefs
- - reiserfs: deal with NULL xattr root w/ xattrs disabled *
- - reiserfs: fixup perms when xattrs are disabled
- - reiserfs: allow exposing privroot w/ xattrs enabled

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkoJr9EACgkQLPWxlyuTD7JbfACfSV+WiMxReRCr/YRDT8IBf7M8
jVkAn3fhf3R1i5cyi/YJ+vtO/WTd6Lre
=90Xq
-----END PGP SIGNATURE-----
