Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbZDNPmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbZDNPmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbZDNPlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:41:53 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:56024 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbZDNPlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:41:52 -0400
Date: Tue, 14 Apr 2009 10:41:39 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/30] cr: core stuff
Message-ID: <20090414154139.GA8085@us.ibm.com>
References: <20090410023539.GK27788@x200.localdomain> <20090413214701.GA24509@us.ibm.com> <20090414152752.GC27461@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414152752.GC27461@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> On Mon, Apr 13, 2009 at 04:47:01PM -0500, Serge E. Hallyn wrote:
> > Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > 
> > Hi Alexey,
> > 
> > as far as I can see, the main differences between this patch and the
> > equivalent in Oren's tree are:
> > 
> > 1. kernel auto-selects container init to freeze
> 
> Note, auto-select part was dropped, userspace is required to pass pid of
> container init exactly. This was done to keep semantic of checkpoint(2)
> small and extendable.

sys_checkpoint() in this patch still finds the child_reaper of the
passed-in pid, doesn't it?  Or are you saying that a later patch in
this set removes that?

> > 2. kernel freezes tasks
> > 3. no objhash taking references
> 
> That's because none needed.

Right while I have opinions on some things in this list, I didn't
mean to imply positions on these items.  My question was:  are
there are differences you want to call out?

> > 4. no hbuf
> 
> hbuf is an optimization to not allocate/free memory for every image.
> For a start it's unnecessary complication, I just kzalloc/dump/kfree.
> 
> > 5. always require CAP_SYS_ADMIN
> > 
> > Are there other differences which you would consider meaningful?  Which
> > do you consider the most important?
> > 
> > Also, since Dave introduced the fops->checkpoint(), we (or at least I)
> > have been struck by the ugly assymetry with checkpoint() being in fops,
> > and restart() not.  Do you have an idea for fixing that?
> 
> Module can legally support C/R for its files.
> In the end it most certainly will end up with module registering restart

Which module?  The module defining a filesystem?

In that case I'm just not clear on how the restart code will know which
fs's file_operations to use to pick a fops->restart() fn.

> hook for file type N.
> 
> Or module registering hook to restart object type N.
> 
> This is for discussion.

Ok, it's just something I've wondered (with both patchsets).

thanks,
-serge
