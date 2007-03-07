Return-Path: <linux-kernel-owner+w=401wt.eu-S965711AbXCGWSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965711AbXCGWSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965700AbXCGWSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:18:08 -0500
Received: from verein.lst.de ([213.95.11.210]:38118 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965707AbXCGWSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:18:05 -0500
Date: Wed, 7 Mar 2007 23:17:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: Steven French <sfrench@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: remove useless cargo-cult checks
Message-ID: <20070307221746.GA3620@lst.de>
References: <20070307152912.GA15650@lst.de> <OF8579A98D.13CFCC0A-ON87257297.006728AA-86257297.006794F0@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF8579A98D.13CFCC0A-ON87257297.006728AA-86257297.006794F0@us.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 12:51:04PM -0600, Steven French wrote:
> > file->f_path.dentry or file->f_path.dentry.d_inode can't be NULL
> 
> OK - I don't really mind removing these checks - and I agree that I there
> is not an obvious way that they can be null, yet we had a case in which
> file->f_dentry was reported as NULL a few years back in a bug report that
> we could not reproduce.

There's a good reason you couldn't reproduce it, because it most likely
must have been a really bad hack in the submitters kernel.  Setting
up file->f_dentry is one of the first thing we do after allocating the
file struct.

> 
> The change to f_path.dentry did hit all filesystems (not sure who did it
> last year) and that patch did hit lkml - so this is not something new that
> just slipped in.

I know - that patch just made the enormous amount of useless checks
vissible.

> Is there an easy way to mirror particular patches going into the
> cifs-2.6.git tree (which is pulled into mm) to lkml?

Maybe some git expert can comment on that.

> The cifs patches go in mm for at least a week before they go into kernel
> but some of them I would like to post again to lkml.

polling -mm is a little hard as it's an enormous blob, so posting to
lkml or -fsdevel would definitively be quite helpfull.

