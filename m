Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbZEJX3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbZEJX3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 19:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZEJX3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 19:29:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbZEJX3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 19:29:08 -0400
Message-ID: <4A07630E.8000503@suse.com>
Date: Sun, 10 May 2009 19:28:14 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Al Viro <viro@ftp.linux.org.uk>, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de
Subject: Re: [patch 3/4] reiserfs: fixup perms when xattrs are disabled
References: <20090510200535.893737918@suse.com> <20090510200649.900586983@suse.com> <20090510213518.GG8633@ZenIV.linux.org.uk>
In-Reply-To: <20090510213518.GG8633@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Al Viro wrote:
> On Sun, May 10, 2009 at 04:05:38PM -0400, Jeff Mahoney wrote:
> 
>> +#ifdef CONFIG_REISERFS_FS_XATTR
>> +	/*
>> +	 * Stat data v1 doesn't support ACLs.
>> +	 */
>> +	if (get_inode_sd_version(inode) != STAT_DATA_V1)
>> +		return generic_permission(inode, mask, reiserfs_check_acl);
>> +	else
>> +#endif
>> +		return generic_permission(inode, mask, NULL);
> 
> Matter of style: this kind of mixing the nesting structures is Not Nice(tm),
> so I'd rather turn that into
> 
> +#ifdef CONFIG_REISERFS_FS_XATTR
> +	/*
> +	 * Stat data v1 doesn't support ACLs.
> +	 */
> +	if (get_inode_sd_version(inode) != STAT_DATA_V1)
> +		return generic_permission(inode, mask, reiserfs_check_acl);
> +#endif
> +
> +	return generic_permission(inode, mask, NULL);

Works for me.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkoHYw4ACgkQLPWxlyuTD7JdrACfdMo7wPBtIGBadVEBKiviD4i9
H4oAoKf1GtugtaiTVZdwwveaTPxBRD/T
=JiZ1
-----END PGP SIGNATURE-----
