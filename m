Return-Path: <linux-kernel-owner+w=401wt.eu-S1031063AbXDYPYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031063AbXDYPYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031069AbXDYPYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:24:24 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:54735 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031063AbXDYPYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:24:22 -0400
To: akpm@linux-foundation.org
CC: serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
In-reply-to: <E1HgcBv-00049Z-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Wed, 25 Apr 2007 09:45:31 +0200)
Subject: Re: [patch] unprivileged mounts update
References: <E1HgcBv-00049Z-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 25 Apr 2007 17:18:12 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> - refine adding "nosuid" and "nodev" flags for unprivileged mounts:
>     o add "nosuid", only if mounter doesn't have CAP_SETUID capability
>     o add "nodev", only if mounter doesn't have CAP_MKNOD capability
> 
> - allow unprivileged forced unmount, but only for FS_SAFE filesystems
> 
> - allow mounting over special files, but not symlinks
> 
> - for mounting and umounting check "fsuid" instead of "ruid"

Andrew, please skip this patch, for now.

Serge found a problem with the fsuid approach: setfsuid(nonzero) will
remove filesystem related capabilities.  So even if root is trying to
set the "user=UID" flag on a mount, access to the target (and in case
of bind, the source) is checked with user privileges.

Root should be able to set this flag on any mountpoint, _regardless_
of permissions.

It is possible to restore filesystem capabilities after setting fsuid,
but the interfaces are rather horrible at all levels.  mount(8) can
probably live with these, but I'm not sure that using "fsuid" over
"ruid" has enough advantages to force this.

Why did we want to use fsuid, exactly?

Thanks,
Miklos
