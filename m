Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbZK3GEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbZK3GEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 01:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZK3GEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 01:04:47 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57095 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZK3GEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 01:04:46 -0500
Date: Mon, 30 Nov 2009 01:04:13 -0500
Message-Id: <200911300604.nAU64D0s021921@agora.fsl.cs.sunysb.edu>
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
Subject: Re: [PATCH 03/41] VFS: Make lookup_hash() return a struct path 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:01 PDT."
             <1256152779-10054-4-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-4-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:

> @@ -1937,7 +1942,8 @@ EXPORT_SYMBOL(filp_open);
>   */
>  struct dentry *lookup_create(struct nameidata *nd, int is_dir)
>  {
> -	struct dentry *dentry = ERR_PTR(-EEXIST);
> +	struct path path = { .dentry = ERR_PTR(-EEXIST) } ;

I assume the compiler will initialize path.mnt to NULL.  Is NULL what you
want?  Even if the compiler guarantees it, I think you should either
explicitly init .mnt to NULL or leave a comment explaining what's going on
-- so no future code reader will think that this was omitted; a comment can
clarify your intentions more explicitly.

A struct path often requires both .mnt and .dentry to be set; it's not like,
say, inode_operations, where clearly some fields can be initialized to NULL
just fine.

Erez.
