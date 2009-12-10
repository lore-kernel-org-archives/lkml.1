Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbZLJUVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbZLJUVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 15:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbZLJUU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 15:20:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672AbZLJUU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 15:20:58 -0500
Date: Thu, 10 Dec 2009 15:20:20 -0500
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
Subject: Re: [PATCH 01/41] VFS: BUG() if somebody tries to rehash an already hashed dentry
Message-ID: <20091210202020.GA10388@shell>
References: <1256152779-10054-2-git-send-email-vaurora@redhat.com> <200911300143.nAU1hwav006906@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911300143.nAU1hwav006906@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 08:43:58PM -0500, Erez Zadok wrote:
> In message <1256152779-10054-2-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> > From: Jan Blunck <jblunck@suse.de>
> > 
> > Break early when somebody tries to rehash an already hashed dentry.
> > Otherwise this leads to interesting corruptions in the dcache hash table
> > later on.
> > 
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > ---
> >  fs/dcache.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index 9e5cd3c..38bf982 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -1550,6 +1550,7 @@ void d_rehash(struct dentry * entry)
> >  {
> >  	spin_lock(&dcache_lock);
> >  	spin_lock(&entry->d_lock);
> > +	BUG_ON(!d_unhashed(entry));
> >  	_d_rehash(entry);
> >  	spin_unlock(&entry->d_lock);
> >  	spin_unlock(&dcache_lock);
> 
> This patch seems unrelated to union mounts.  If so, can you get it pushed
> upstream sooner?  Or is this a debugging patch useful only when developing
> union mounts?
>
> You also said that it can lead to "ineresting corruptions".  What kind of
> corruptions exactly?  Also, would it make more sense to allow _d_rehash() to
> hash in an unhashed dentry for the first time?

Hi Erez,

Thanks for your great review!  I am working my way through your
comments one by one.

This is a trivial patch which happened to be useful during our
development and seems like it might be useful for other VFS-related
development.  I will submit it as part of our VFS patch set and drop
it if the maintainers don't want it.

I don't have an opinion on _d_rehash(), I'm afraid.

-VAL
