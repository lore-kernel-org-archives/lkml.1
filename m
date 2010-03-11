Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114Ab0CKPkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:40:40 -0500
Received: from ottmail.xandros.com ([142.46.212.35]:44981 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab0CKPki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:40:38 -0500
X-Greylist: delayed 978 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2010 10:40:38 EST
Date: Thu, 11 Mar 2010 10:20:23 -0500
From: Woody Suwalski <terraluna977@gmail.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Message-ID: <4B990A37.4040306@gmail.com>
In-Reply-To: <4B91317D.7000205@lougher.demon.co.uk>
References: <4B91317D.7000205@lougher.demon.co.uk>
Subject: Re: [GIT PULL V2] Squashfs updates for 2.6.34-rc1
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100205 SeaMonkey/2.0.3
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Lougher wrote:
> Hi Linus,
>
> Please consider pulling the following revised Squashfs update for 
> 2.6.34-rc1.
> I have removed all the lzma/bunzip2/inflate/lzo code changes (which as 
> far as I
> know were the blocking issue previously).
>
> What remains in the pull request is a clean-up/refactoring of the zlib
> wrapper code, outline knowledge of lzma/lzo compressed filesystems 
> (unsupported,
> but it gives users an understandable error message when they try to 
> mount them),
> and some trivial code tidying.
>
> Please pull.
>
> Thanks
>
> Phillip
>
> -------------
>
> The following changes since commit 
> 7284ce6c9f6153d1777df5f310c959724d1bd446:
>   Linus Torvalds (1):
>         Linux 2.6.33-rc4
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git 
> master
>
> Phillip Lougher (6):
>       Squashfs: move zlib decompression wrapper code into a separate file
>       Squashfs: factor out remaining zlib dependencies into separate 
> wrapper file
>       Squashfs: add a decompressor framework
>       Squashfs: add decompressor entries for lzma and lzo
>       Squashfs: get rid of obsolete variable in struct squashfs_sb_info
>       Squashfs: get rid of obsolete definition in header file
>
>  fs/squashfs/Makefile         |    2 +-
>  fs/squashfs/block.c          |   76 ++--------------------
>  fs/squashfs/cache.c          |    1 -
>  fs/squashfs/decompressor.c   |   68 +++++++++++++++++++
>  fs/squashfs/decompressor.h   |   55 +++++++++++++++
>  fs/squashfs/dir.c            |    1 -
>  fs/squashfs/export.c         |    1 -
>  fs/squashfs/file.c           |    1 -
>  fs/squashfs/fragment.c       |    1 -
>  fs/squashfs/id.c             |    1 -
>  fs/squashfs/inode.c          |    1 -
>  fs/squashfs/namei.c          |    1 -
>  fs/squashfs/squashfs.h       |    8 ++-
>  fs/squashfs/squashfs_fs.h    |    6 +-
>  fs/squashfs/squashfs_fs_sb.h |   40 ++++++------
>  fs/squashfs/super.c          |   49 +++++++-------
>  fs/squashfs/symlink.c        |    1 -
>  fs/squashfs/zlib_wrapper.c   |  150 
> ++++++++++++++++++++++++++++++++++++++++++
>  18 files changed, 335 insertions(+), 128 deletions(-)
>  create mode 100644 fs/squashfs/decompressor.c
>  create mode 100644 fs/squashfs/decompressor.h
>  create mode 100644 fs/squashfs/zlib_wrapper.c
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
Current 2.6.34-rc1 squashfs is broken.

I have a large (500M) squashfs root filesystem, which is mounted from 
initramfs.
After mounting I can chroot into it.

With 2.6.34-rc1 seems that some directories are corrupted - e.g. /lib 
may have only files up to libnss (alphabetically), or that some binaries 
are not executing - because I see they are all NULLs on read, e.t.c. 
Basically - the root is not usable.
Replacing the fs/squashfs source dir with a 2.6.33's one fixes the 
problem - so it is the new code issue...


Woody
