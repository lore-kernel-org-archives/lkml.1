Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbZLJVYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbZLJVYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbZLJVYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:24:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429AbZLJVYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:24:02 -0500
Date: Thu, 10 Dec 2009 16:23:32 -0500
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
Message-ID: <20091210212332.GB10388@shell>
References: <1256152779-10054-4-git-send-email-vaurora@redhat.com> <200911300202.nAU22VGU007154@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911300202.nAU22VGU007154@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 09:02:31PM -0500, Erez Zadok wrote:
> In message <1256152779-10054-4-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> > From: Jan Blunck <jblunck@suse.de>
> > 
> > This patch changes lookup_hash() into returning a struct path.
> 
> Actually, lookup_hash now also takes a qstr.
> 
> This is a somewhat involved patch.  I think more documentation is needed to
> list all the places it touches and changes, b/c now struct path has to
> propagate in various other places.  (In general, passing struct path instead
> of struct dentry is going in the right direction: eventually we could get rid
> of lookup_one_len.)

Hm, it seems like a straightforward next step in the long-term project
of migration from dentries to paths.  I looked at some of the previous
dentry->path patches and they didn't include this kind of documentation.

> > @@ -1219,14 +1219,22 @@ out:
> >   * needs parent already locked. Doesn't follow mounts.
> >   * SMP-safe.
> >   */
> > -static struct dentry *lookup_hash(struct nameidata *nd)
> > +static int lookup_hash(struct nameidata *nd, struct qstr *name,
> > +		       struct path *path)
> >  {
> 
> I suggest you document above this function what the @name and @path are for,
> who is supposed to allocate and free them, caller/callee's responsibilities,
> side effects (if any), new return status upon success/failure, etc.

That would be good, but consistently documenting existing VFS
functionality would be a large project and not one I'm going to take
on. :)

-VAL
