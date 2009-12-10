Return-Path: <linux-kernel-owner+w=401wt.eu-S1761106AbZLJVY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761106AbZLJVY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760972AbZLJVYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:24:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457AbZLJVYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:24:53 -0500
Date: Thu, 10 Dec 2009 16:24:35 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
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
Message-ID: <20091210212434.GC10388@shell>
References: <1256152779-10054-4-git-send-email-vaurora@redhat.com> <200911300604.nAU64D0s021921@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911300604.nAU64D0s021921@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 01:04:13AM -0500, Erez Zadok wrote:
> In message <1256152779-10054-4-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> 
> > @@ -1937,7 +1942,8 @@ EXPORT_SYMBOL(filp_open);
> >   */
> >  struct dentry *lookup_create(struct nameidata *nd, int is_dir)
> >  {
> > -	struct dentry *dentry = ERR_PTR(-EEXIST);
> > +	struct path path = { .dentry = ERR_PTR(-EEXIST) } ;
> 
> I assume the compiler will initialize path.mnt to NULL.  Is NULL what you
> want?  Even if the compiler guarantees it, I think you should either
> explicitly init .mnt to NULL or leave a comment explaining what's going on
> -- so no future code reader will think that this was omitted; a comment can
> clarify your intentions more explicitly.

That is an unpleasant thing to look at.  I rewrote the exit paths so
that this initialization was unnecessary.

Thanks,

-VAL
