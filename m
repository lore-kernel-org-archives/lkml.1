Return-Path: <linux-kernel-owner+w=401wt.eu-S1030910AbXDPTk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030910AbXDPTk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030917AbXDPTk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:40:59 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43378 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030910AbXDPTk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:40:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 02/10] allow unprivileged umount
References: <20070416110308.739051445@szeredi.hu>
	<20070416110403.068601478@szeredi.hu>
Date: Mon, 16 Apr 2007 13:39:19 -0600
In-Reply-To: <20070416110403.068601478@szeredi.hu> (Miklos Szeredi's message
	of "Mon, 16 Apr 2007 13:03:10 +0200")
Message-ID: <m1vefwjehk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> From: Miklos Szeredi <mszeredi@suse.cz>
>
> The owner doesn't need sysadmin capabilities to call umount().
>
> Similar behavior as umount(8) on mounts having "user=UID" option in
> /etc/mtab.  The difference is that umount also checks /etc/fstab,
> presumably to exclude another mount on the same mountpoint.
>

bool in the kernel?

int would be much more recognizable as this is not C++

Or do you have place to convert the rest of the kernel that is using
int to return a true/false value to bool?

> +static bool permit_umount(struct vfsmount *mnt, int flags)
> +{
> +	if (capable(CAP_SYS_ADMIN))
> +		return true;
> +
> +	if (!(mnt->mnt_flags & MNT_USER))
> +		return false;
> +
> +	if (flags & MNT_FORCE)
> +		return false;
> +
> +	return mnt->mnt_uid == current->uid;
> +}

Eric
