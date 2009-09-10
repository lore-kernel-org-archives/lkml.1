Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbZIJFoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbZIJFoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 01:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZIJFoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 01:44:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34834 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZIJFoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 01:44:17 -0400
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, Valdis.Kletnieks@vt.edu, hugh.dickins@tiscali.co.uk,
       matthew@wil.cx, agruen@suse.de, viro@zeniv.linux.org.uk, hch@lst.de,
       linux-kernel@vger.kernel.org
In-reply-to: <20090909142403.c3b35d4d.akpm@linux-foundation.org> (message from
	Andrew Morton on Wed, 9 Sep 2009 14:24:03 -0700)
Subject: Re: [patch] vfs: no "(unreachable)" prefix for SYSVIPC maps in
 /proc/PID/maps
References: <E1Mkg2P-0000mi-H3@pomaz-ex.szeredi.hu> <20090909142403.c3b35d4d.akpm@linux-foundation.org>
Message-Id: <E1MlcRe-0005sc-8p@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 10 Sep 2009 07:43:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, Andrew Morton wrote:
> On Mon, 07 Sep 2009 17:21:49 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Another fix for vfs-fix-d_path-for-unreachable-paths.patch in -mm.
> > 
> 
> Now I'm confused.
> 
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > The patch
> > 
> >   "vfs: fix d_path() for unreachable paths"
> > 
> > generally changed d_path() to report unreachable paths with a special
> > prefix.  This has an effect on /proc/${PID}/maps as well for memory
> > maps set up with shmem_file_setup() or hugetlb_file_setup().  These
> > functions set up unlinked files under a kernel-private vfsmount.
> > Since this vfsmount is unreachable from userspace, these maps will be
> > reported with the "(unreachable)" prefix.
> > 
> > This is undesirable, because it changes the kernel ABI and might break
> > applications for no good reason.
> > 
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> 
> These three patches are fixes against
> vfs-fix-d_path-for-unreachable-paths.patch?

Yes.  They apply even without that patch, but don't make any sense...
Sorry about the confusion :(

Thanks,
Miklos
