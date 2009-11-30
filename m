Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbZK3IDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbZK3IDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZK3IDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:03:15 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38352 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbZK3IDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:03:14 -0500
Date: Mon, 30 Nov 2009 03:02:44 -0500
Message-Id: <200911300802.nAU82iLC022867@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH 19/41] union-mount: Introduce MNT_UNION and MS_UNION flags 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:17 PDT."
             <1256152779-10054-20-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-20-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> Add per mountpoint flag for Union Mount support. You need additional patches
> to util-linux for that to work - see:
> 
> git://git.kernel.org/pub/scm/utils/util-linux-ng/val/util-linux-ng.git
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/namespace.c        |    5 ++++-
>  include/linux/fs.h    |    1 +
>  include/linux/mount.h |    1 +
>  3 files changed, 6 insertions(+), 1 deletions(-)
[...]

> diff --git a/include/linux/mount.h b/include/linux/mount.h
> index 5d52753..e175c47 100644
> --- a/include/linux/mount.h
> +++ b/include/linux/mount.h
> @@ -35,6 +35,7 @@ struct mnt_namespace;
>  #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
>  #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
>  #define MNT_PNODE_MASK	0x3000	/* propagation flag mask */
> +#define MNT_UNION	0x4000	/* if the vfsmount is a union mount */

I it correct to just add another flag here?  How does it relate to this
'propagation mask' right above it?  If there's some code out there which
masks out which MNT flags get propagated and which don't, then you need to
make a decision whether MNT_UNION needs to be propagated as well.  Either
way, please document your decision in a comment here so no one will have to
ask the same question again.

Erez.
