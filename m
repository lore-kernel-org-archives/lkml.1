Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbXFUQkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbXFUQkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbXFUQjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:39:53 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38517 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbXFUQjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:39:52 -0400
Date: Thu, 21 Jun 2007 12:39:38 -0400
Message-Id: <200706211639.l5LGdc1I019274@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Bharata B Rao <bharata.rao@gmail.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       Jan Blunck <jblunck@suse.de>, linux-kernel@vger.kernel.org,
       bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 1/4] Union mount documentation. 
In-reply-to: Your message of "Thu, 21 Jun 2007 12:29:00 EDT."
             <20070621162900.GA9457@filer.fsl.cs.sunysb.edu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20070621162900.GA9457@filer.fsl.cs.sunysb.edu>, Josef Sipek writes:
> On Thu, Jun 21, 2007 at 10:55:45AM +0530, Bharata B Rao wrote:
> ... 
> > Talking about copyup and whiteout at VFS layer, we have already
> > demonstrated what complexity it takes to have these within VFS. Please
> > take a look at the copyup and whiteout patches in our previous
> > releases at:
> > 
> > http://lkml.org/lkml/2007/4/17/150
> > http://lkml.org/lkml/2007/5/14/69
> > 
> > Or may be wait till I clean all those up to work with the new union
> > new stack infrastructure which I have posted here.
> 
> Really, the problem for both, union mounts and unionfs, is that the concept
> of unioning spans the two layers. You have the unification part - which is
> very VFS-level concept, but at the same time, you got whiteouts, copyup,
> (semi-?)persistent inode numbers, and a bunch of other details that just
> don't belong in the VFS at all.
> 
> Josef "Jeff" Sipek.

Yup, which is why I feel that the eventual solution may involve a hybrid
solution: a file system "driver" plus ample VFS support.  The question will
always be how much should go into the VFS and how much should go into the
f/s driver?  Our approach w/ unionfs had been to keep as much of it into the
f/s driver, and slowly offer VFS-level support, so as not to perturb the VFS
too much all at once.  That way we can offer users something that works now,
and internally change the implementation with minimal user-visible changes.

Erez.
