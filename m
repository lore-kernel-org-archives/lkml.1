Return-Path: <linux-kernel-owner+w=401wt.eu-S965654AbXA3Rwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965654AbXA3Rwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 12:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965652AbXA3Rwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 12:52:37 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:59451 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965650AbXA3Rwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 12:52:36 -0500
Date: Tue, 30 Jan 2007 12:52:19 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Christoph Hellwig <hch@infradead.org>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH 4/4] fs/unionfs/: Don't duplicate the struct nameidata
Message-ID: <20070130175219.GA8508@filer.fsl.cs.sunysb.edu>
References: <11701030631109-git-send-email-jsipek@cs.sunysb.edu> <11701030643398-git-send-email-jsipek@cs.sunysb.edu> <20070130094233.GA6972@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130094233.GA6972@infradead.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 09:42:33AM +0000, Christoph Hellwig wrote:
> On Mon, Jan 29, 2007 at 03:37:42PM -0500, Josef 'Jeff' Sipek wrote:
> > The only fields that we have to watch out for are the dentry and vfsmount.
> > Additionally, this makes Unionfs gentler on the stack as nameidata is rather
> > large.
> 
> That's onviously not true at all.  To handle any filesystems using intents
> (e.g. NFSv4) you need to do much more.  Then again doing things correctly
> doesn't seem to be interesting to the stackable filesystems crowd an this
> problem has been constantly ignored over the last year, including merging
> ecryptfs which has been broken in the same way.
> 
> Folks, if you want your stackable filesystem toys taken seriously you
> need to fix these kind of issues instead of talking them away.  And yes,
> this will involve some surgery to the VFS.

Indeed. I asked around (#linuxfs) and it seemed that restoring the
dentry/vfsmount was sufficient for the purpose of passing intents down. If
this is not the case, I'll revert the patch to do the full namei allocation.

Josef "Jeff" Sipek.

-- 
Computer Science is no more about computers than astronomy is about
telescopes.
		- Edsger Dijkstra
