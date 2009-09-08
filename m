Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbZIHSE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbZIHSE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZIHSE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:04:58 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:30983 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751945AbZIHSE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:04:57 -0400
X-Trace: 255598949/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.1.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.1.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMEAK05pkpQKQHF/2dsb2JhbACBU91VhBgF
X-IronPort-AV: E=Sophos;i="4.44,353,1249254000"; 
   d="scan'208";a="255598949"
Date: Tue, 8 Sep 2009 19:04:11 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Miklos Szeredi <miklos@szeredi.hu>
cc: akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, matthew@wil.cx,
       agruen@suse.de, viro@zeniv.linux.org.uk, hch@lst.de,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] vfs: no "(unreachable)" prefix for SYSVIPC maps in
 /proc/PID/maps 
In-Reply-To: <E1Mkg2P-0000mi-H3@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0909081901190.2878@sister.anvils>
References: <E1Mkg2P-0000mi-H3@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Miklos Szeredi wrote:
> Another fix for vfs-fix-d_path-for-unreachable-paths.patch in -mm.
> 
> ----
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> The patch
> 
>   "vfs: fix d_path() for unreachable paths"
> 
> generally changed d_path() to report unreachable paths with a special
> prefix.  This has an effect on /proc/${PID}/maps as well for memory
> maps set up with shmem_file_setup() or hugetlb_file_setup().  These
> functions set up unlinked files under a kernel-private vfsmount.
> Since this vfsmount is unreachable from userspace, these maps will be
> reported with the "(unreachable)" prefix.
> 
> This is undesirable, because it changes the kernel ABI and might break
> applications for no good reason.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/hugetlbfs/inode.c |   17 +++++++++++++++++
>  mm/shmem.c           |   17 +++++++++++++++++
>  2 files changed, 34 insertions(+)

You can add my
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
to this and to the preceding two patches.

And give yourself a gold star for putting your updates into the right
section of mm/shmem.c, to cover both CONFIG_SHMEM=y and not set.

My heart sinks a little with these patches, particularly this
last; but I bet your heart sank a little to have to do them, and
I reluctantly agree with you that they're all probably necessary.
They do as you've said - I checked again with the 10.3 gnome-vfs.

Thanks,
Hugh
