Return-Path: <linux-kernel-owner+w=401wt.eu-S2992692AbXDTMmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992692AbXDTMmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 08:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992718AbXDTMmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 08:42:55 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49354 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992692AbXDTMmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 08:42:53 -0400
Date: Fri, 20 Apr 2007 07:42:49 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 0/8]  mount ownership and unprivileged mount syscall (v4)
Message-ID: <20070420124249.GC29498@sergelap.austin.ibm.com>
References: <20070420102532.385211890@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420102532.385211890@szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> This patchset has now been bared to the "lowest common denominator"
> that everybody can agree on.  Or at least there weren't any objections
> to this proposal.
> 
> Andrew, please consider it for -mm.
> 
> Thanks,
> Miklos
> ----
> 
> v3 -> v4:
> 
>  - simplify interface as much as possible, now only a single option
>    ("user=UID") is used to control everything
>  - no longer allow/deny mounting based on file/directory permissions,
>    that approach does not always make sense
> 
> ----
> This patchset adds support for keeping mount ownership information in
> the kernel, and allow unprivileged mount(2) and umount(2) in certain
> cases.
> 
> The mount owner has the following privileges:
> 
>   - unmount the owned mount
>   - create a submount under the owned mount
> 
> The sysadmin can set the owner explicitly on mount and remount.  When
> an unprivileged user creates a mount, then the owner is automatically
> set to the user.
> 
> The following use cases are envisioned:
> 
> 1) Private namespace, with selected mounts owned by user.
>    E.g. /home/$USER is a good candidate for allowing unpriv mounts and
>    unmounts within.
> 
> 2) Private namespace, with all mounts owned by user and having the
>    "nosuid" flag.  User can mount and umount anywhere within the
>    namespace, but suid programs will not work.
> 
> 3) Global namespace, with a designated directory, which is a mount
>    owned by the user.  E.g. /mnt/users/$USER is set up so that it is
>    bind mounted onto itself, and set to be owned by $USER.  The user
>    can add/remove mounts only under this directory.
> 
> The following extra security measures are taken for unprivileged
> mounts:
> 
>  - usermounts are limited by a sysctl tunable
>  - force "nosuid,nodev" mount options on the created mount

Very nice.  I like these semantics.

I'll try to rework my laptop in the next few days to use this patchset
as a test.

thanks,
-serge
