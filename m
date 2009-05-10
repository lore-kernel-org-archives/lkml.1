Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbZEJVfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbZEJVfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZEJVfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:35:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43058 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbZEJVfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:35:18 -0400
Date: Sun, 10 May 2009 22:35:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de
Subject: Re: [patch 3/4] reiserfs: fixup perms when xattrs are disabled
Message-ID: <20090510213518.GG8633@ZenIV.linux.org.uk>
References: <20090510200535.893737918@suse.com> <20090510200649.900586983@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090510200649.900586983@suse.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 04:05:38PM -0400, Jeff Mahoney wrote:

> +#ifdef CONFIG_REISERFS_FS_XATTR
> +	/*
> +	 * Stat data v1 doesn't support ACLs.
> +	 */
> +	if (get_inode_sd_version(inode) != STAT_DATA_V1)
> +		return generic_permission(inode, mask, reiserfs_check_acl);
> +	else
> +#endif
> +		return generic_permission(inode, mask, NULL);

Matter of style: this kind of mixing the nesting structures is Not Nice(tm),
so I'd rather turn that into

+#ifdef CONFIG_REISERFS_FS_XATTR
+	/*
+	 * Stat data v1 doesn't support ACLs.
+	 */
+	if (get_inode_sd_version(inode) != STAT_DATA_V1)
+		return generic_permission(inode, mask, reiserfs_check_acl);
+#endif
+
+	return generic_permission(inode, mask, NULL);
