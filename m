Return-Path: <linux-kernel-owner+w=401wt.eu-S1765576AbXHATwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765576AbXHATwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 15:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761020AbXHATwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 15:52:25 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45757 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757599AbXHATwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 15:52:23 -0400
Subject: Re: [RFC 12/26] ext2 white-out support
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, hch@infradead.org
In-Reply-To: <20070801193330.GA20928@filer.fsl.cs.sunysb.edu>
References: <20070730161323.100048969@weierstrass.suse.de>
	 <20070730161324.261652101@weierstrass.suse.de>
	 <20070731163656.GC22350@filer.fsl.cs.sunysb.edu>
	 <20070731170012.GN5101@hasse.suse.de>
	 <20070731171159.GA27234@filer.fsl.cs.sunysb.edu>
	 <1185981810.18007.14.camel@kleikamp.austin.ibm.com>
	 <20070801184405.GA18405@filer.fsl.cs.sunysb.edu>
	 <1185995431.18007.24.camel@kleikamp.austin.ibm.com>
	 <20070801193330.GA20928@filer.fsl.cs.sunysb.edu>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 14:52:21 -0500
Message-Id: <1185997941.18007.30.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 15:33 -0400, Josef Sipek wrote:
> On Wed, Aug 01, 2007 at 02:10:31PM -0500, Dave Kleikamp wrote:
> > On Wed, 2007-08-01 at 14:44 -0400, Josef Sipek wrote:
> > > Now what? How do you rename? Do you rename in the same branch (assuming it
> > > is rw)?
> > 
> > Er, no.  According to Documentation/filesystems/union-mounts.txt, "only
> > the topmost layer of the mount stack can be altered".
> 
> This brings up an very interesting (but painful) question...which makes more
> sense? Allowing the modifications in only the top-most branch, or any branch
> (given the user allows it at mount-time)?

Your examples point out the complexity of trying to allow modifications
at lower levels.  It seems to me to be simpler (even if recursive copies
are needed) to leave it as proposed.

> This is really question to the community at large, not just you, Dave :)

I agree, but I have to add my $.02.

> > > 1) "cp -r" the entire subtree being renamed to highest-priority branch, and
> > > rename there (you might have to recreate a series of directories to have a
> > > place to "cp" to...so you got "cp -r" _AND_ "mkdir -p"-like code in the VFS!
> > > 1/2 a :) )
> > 
> > I think this is the only alternative, given the design.
> 
> Right. Doing something like this at the filesystem level (as we do in
> unionfs) seems less painful - filesystems are places full of all sorts of
> nefarious activities to begin with. Having it in the VFS seems...even
> uglier.

I haven't looked at either implementation close enough to offer an
opinion here that I would be able to defend.  I'm sure others have their
opinions.

> Josef 'Jeff' Sipek.
> 

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

