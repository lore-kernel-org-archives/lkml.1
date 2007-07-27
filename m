Return-Path: <linux-kernel-owner+w=401wt.eu-S936268AbXG0OKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936268AbXG0OKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932652AbXG0OKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:10:23 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:49015 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbXG0OKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tRctE8+5BDqrdQDpIigAa5jABjqYOK65c19XYuRRoT2HDyqDSeX8NpyhEa0vLf/fYN/Y0LhT/iJxWDejhreu9Qtu3lLoEUulN5WzhRUxB+OCQ95q1v0DKXecB6ZAvvANI7Hm32G9JVyBcJIKBNZv+glQBtBynxnJPY6XGcO23GE=
Message-ID: <524f69650707270710u7c21aea0v5d997484f33b3434@mail.gmail.com>
Date: Fri, 27 Jul 2007 09:10:21 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: request for patches: showing mount options
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kzak@redhat.com, ericvh@gmail.com,
       lucho@ionkov.net, zippel@linux-m68k.org, hpa@zytor.com,
       raven@themaw.net, rathamahata@php4.ru, dhowells@redhat.com,
       sfrench@samba.org, mhalcrow@us.ibm.com, phillip@hellewell.homeip.net,
       hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
       wli@holomorphy.com, shaggy@austin.ibm.com, vandrove@vc.cvut.cz,
       trond.myklebust@fys.uio.no, aia21@cantab.net, mark.fasheh@oracle.com,
       kurt.hackel@oracle.com, reiserfs-devel@vger.kernel.org,
       bfennema@falcon.csc.calpoly.edu, dushistov@mail.ru,
       xfs-masters@oss.sgi.com, arnd@arndb.de, holzheu@de.ibm.com
In-Reply-To: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What do you consider the best example so far of a kernel module's
equivalent of "parse_mount_options" (handling a mix of options of
different types) and show_options.

On 7/27/07, Miklos Szeredi <miklos@szeredi.hu> wrote:
> [please consider pruning the CC list if discussing some aspect, which
> doesn't concern all]
>
> I've done an audit of all filesystems with regards to showing mount
> options in /proc/<pid>/mounts.  Unfortunately most of them show none
> or only a part of all accepted options (for details see list of
> filesystems at the end of the mail).
>
> This is currently not a big problem, because mount(8) stores the given
> options in /etc/mtab.  However we want to get rid of mtab, and this
> requires, that the option showing be fixed up.
>
> It would be easiest if this was done by the VFS instead of having to
> deal with it in filesystems.  However there are differences in how
> filesytems handle options during mount and remount, and it would be
> impossible to take this into account in all cases.
>
> If you are CC-ed, and responsible for one of these filesystems, please
> take a moment to fully implement the ->show_options() method.  In most
> cases it should be an easy task.
>
> If for some reason you are unable to do this, please let me know and
> I'll fix it up.
>
> Here are some guidelines for showing options.  I'll also add these to
> Documentation/filesystems/vfs.txt
>
> +   If a filesystem accepts mount options, it must define show_options()
> +   to show all the currently active options.  The rules are:
> +
> +     - options MUST be shown which are not default or their values differ
> +       from the default
> +
> +     - options MAY be shown which are enabled by default or have their
> +       default value
> +
> +   Options used only internally between a mount helper and the kernel
> +   (such as file descriptors), or which only have an effect during the
> +   mounting (such as ones controlling the creation of a journal) are exempt
> +   from the above rules.
>
> Thanks,
> Miklos
>
> -------
> legend:
>
>   all - fs has options, but doesn't define ->show_options()
>   some - fs defines ->show_options(), but some options are not shown
>   noopt - fs does not have options
>   good - fs shows all options
>   patch - I have a patch
>
>
> 9p          some
> adfs        all (maintainer?)
> affs        all
> afs         all
> autofs      all
> autofs4     some
> befs        all
> bfs         noopt
> cifs        some (odd parser)
> coda        noopt
> configfs    noopt
> cramfs      noopt
> debugfs     noopt
> devpts      patch
> ecryptfs    some
> efs         noopt
> ext2        patch
> ext3        patch
> ext4        patch
> fat         some
> freevxfs    noopt
> fuse        patch
> gfs2        good
> hfs         good
> hfsplus     good
> hostfs      patch
> hpfs        all
> hppfs       noopt
> hugetlbfs   all
> isofs       all (maintainer?)
> jffs2       noopt
> jfs         some
> minix       noopt
> msdos       ->fat
> ncpfs       all (FS_BINARY_MOUNTDATA?)
> nfs         some
> nfsd        noopt
> ntfs        good (odd parser)
> ocfs2       all
> openpromfs  noopt
> proc        noopt
> qnx4        noopt
> ramfs       noopt
> reiserfs    all
> romfs       noopt
> smbfs       good (odd parser) (maintainer?)
> sysfs       noopt
> sysv        noopt
> udf         all
> ufs         all
> vfat        ->fat
> xfs         some (odd parser)
>
> mm/shmem.c                                    patch
> drivers/oprofile/oprofilefs.c                 noopt
> drivers/infiniband/hw/ipath/ipath_fs.c        noopt
> drivers/misc/ibmasm/ibmasmfs.c                noopt
> drivers/usb/core (usbfs)                      noopt
> drivers/usb/gadget (gadgetfs)                 noopt
> drivers/isdn/capi/capifs.c                    noopt
> kernel/cpuset.c                               noopt
> fs/binfmt_misc.c                              noopt
> net/sunrpc/rpc_pipe.c                         noopt
> arch/powerpc/platforms/cell/spufs             all
> arch/s390/hypfs                               all
> ipc/mqueue.c                                  noopt
> security (securityfs)                         noopt
> security/selinux/selinuxfs.c                  noopt
>
> in -mm:
>
> reiser4                some (odd parser)
> kernel/container.c     good (odd parser)
>


-- 
Thanks,

Steve
