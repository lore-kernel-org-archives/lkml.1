Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZK3CIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZK3CIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 21:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbZK3CIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 21:08:39 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49637 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbZK3CIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 21:08:38 -0500
Date: Sun, 29 Nov 2009 20:43:58 -0500
Message-Id: <200911300143.nAU1hwav006906@agora.fsl.cs.sunysb.edu>
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
Subject: Re: [PATCH 01/41] VFS: BUG() if somebody tries to rehash an already hashed dentry 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:18:59 PDT."
             <1256152779-10054-2-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-2-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> Break early when somebody tries to rehash an already hashed dentry.
> Otherwise this leads to interesting corruptions in the dcache hash table
> later on.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/dcache.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 9e5cd3c..38bf982 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1550,6 +1550,7 @@ void d_rehash(struct dentry * entry)
>  {
>  	spin_lock(&dcache_lock);
>  	spin_lock(&entry->d_lock);
> +	BUG_ON(!d_unhashed(entry));
>  	_d_rehash(entry);
>  	spin_unlock(&entry->d_lock);
>  	spin_unlock(&dcache_lock);

This patch seems unrelated to union mounts.  If so, can you get it pushed
upstream sooner?  Or is this a debugging patch useful only when developing
union mounts?

You also said that it can lead to "ineresting corruptions".  What kind of
corruptions exactly?  Also, would it make more sense to allow _d_rehash() to
hash in an unhashed dentry for the first time?

Erez.

PS. apologies for the belated review.  I need a thanksgiving break once a
month to catch up to emails. :-)
