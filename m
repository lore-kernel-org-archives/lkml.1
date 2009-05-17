Return-Path: <linux-kernel-owner+w=401wt.eu-S1751945AbZEQLvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbZEQLvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 07:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbZEQLu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 07:50:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49600 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZEQLuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 07:50:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A0FFA15.6070101@s5r6.in-berlin.de>
Date: Sun, 17 May 2009 13:50:45 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch 3/4] reiserfs: fixup perms when xattrs are disabled
References: <20090517050200.786752018@suse.com> <20090517050332.303142159@suse.com>
In-Reply-To: <20090517050332.303142159@suse.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney wrote:
>  This patch CONFIG_REISERFS_FS_XATTR protection from reiserfs_permission.
> 
>  This is needed to avoid warnings during file deletions and chowns with
>  xattrs disabled.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Al has a minimally edited version in vfs-2.6.git/for-next:

[...]
> +#ifdef CONFIG_REISERFS_FS_XATTR
> +	/*
> +	 * Stat data v1 doesn't support ACLs.
> +	 */
> +	if (get_inode_sd_version(inode) != STAT_DATA_V1)
> +		return generic_permission(inode, mask, reiserfs_check_acl);
> +	else
> +#endif
> +		return generic_permission(inode, mask, NULL);
> +}
> +

The else is omitted, and hence the second return unindented.

Al, did you mean to let Linus pull from your tree once more?
(I have been using a reiserfs root FS with Jeff's four patches for a 
week and all went smoothly.)
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
