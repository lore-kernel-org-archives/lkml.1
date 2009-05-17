Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbZEQOAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbZEQOAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 10:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZEQOAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 10:00:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:33810 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbZEQOAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 10:00:22 -0400
Message-ID: <4A101838.4070600@suse.com>
Date: Sun, 17 May 2009 09:59:20 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch 3/4] reiserfs: fixup perms when xattrs are disabled
References: <20090517050200.786752018@suse.com> <20090517050332.303142159@suse.com> <4A0FFA15.6070101@s5r6.in-berlin.de>
In-Reply-To: <4A0FFA15.6070101@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Stefan Richter wrote:
> Jeff Mahoney wrote:
>>  This patch CONFIG_REISERFS_FS_XATTR protection from reiserfs_permission.
>>
>>  This is needed to avoid warnings during file deletions and chowns with
>>  xattrs disabled.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> 
> Al has a minimally edited version in vfs-2.6.git/for-next:
> 
> [...]
>> +#ifdef CONFIG_REISERFS_FS_XATTR
>> +    /*
>> +     * Stat data v1 doesn't support ACLs.
>> +     */
>> +    if (get_inode_sd_version(inode) != STAT_DATA_V1)
>> +        return generic_permission(inode, mask, reiserfs_check_acl);
>> +    else
>> +#endif
>> +        return generic_permission(inode, mask, NULL);
>> +}
>> +
> 
> The else is omitted, and hence the second return unindented.

Oops, of course. I'd forgotten about that once I thought Al had merged them.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkoQGDgACgkQLPWxlyuTD7LQtwCcCPb3UC7sQann3C5j7ZvhGNIK
X2QAniRCmLRUazgPunHzzkXVK0XY04QZ
=c79O
-----END PGP SIGNATURE-----
