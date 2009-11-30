Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZK3JQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZK3JQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZK3JQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:16:12 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45275 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZK3JQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:16:11 -0500
Date: Mon, 30 Nov 2009 04:15:41 -0500
Message-Id: <200911300915.nAU9Ff57026164@agora.fsl.cs.sunysb.edu>
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
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/41] union-mount: Changes to the namespace handling 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:21 PDT."
             <1256152779-10054-24-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-24-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> Creates the proper struct union_mount when mounting something into a
> union. If the topmost filesystem isn't capable of handling the white-out
> filetype it could only be mount read-only.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/namespace.c        |    7 ++++++
>  fs/union.c            |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mount.h |    3 ++
>  include/linux/union.h |   10 +++++++-
>  4 files changed, 75 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c

I'm curious if this fs/namespace.c patch could be merged with another
fs/namespace.c patch.

> diff --git a/include/linux/union.h b/include/linux/union.h
> index b035a82..0b6f356 100644
> --- a/include/linux/union.h
> +++ b/include/linux/union.h
> @@ -30,8 +30,9 @@ struct union_mount {
>  	atomic_t u_count;		/* reference count */
>  	struct mutex u_mutex;
>  	struct list_head u_unions;	/* list head for d_unions */
> -	struct hlist_node u_hash;	/* list head for searching */
> -	struct hlist_node u_rhash;	/* list head for reverse searching */
> +	struct list_head u_list;	/* list head for mnt_unions */
> +	struct hlist_node u_hash;	/* list head for seaching */

s/seaching/searching/

M-x ispell-comments-and-strings to the rescue.

> +	struct hlist_node u_rhash;	/* list head for reverse seaching */

A previous patch introduced struct union_mount; this patch modifies it.  Why
not introduce the final struct union_mount only once in this patchset?  It's
somewhat frustrating to have to read a patch as critical as the one defining
major new data structures, and try to understand it, only to find out that
the data structure is about to undergo major surgery later on.

Erez.
