Return-Path: <linux-kernel-owner+w=401wt.eu-S1763857AbXHATdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763857AbXHATdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 15:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760155AbXHATdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 15:33:40 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34290 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760112AbXHATdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 15:33:38 -0400
Date: Wed, 1 Aug 2007 15:33:30 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, hch@infradead.org
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070801193330.GA20928@filer.fsl.cs.sunysb.edu>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731163656.GC22350@filer.fsl.cs.sunysb.edu> <20070731170012.GN5101@hasse.suse.de> <20070731171159.GA27234@filer.fsl.cs.sunysb.edu> <1185981810.18007.14.camel@kleikamp.austin.ibm.com> <20070801184405.GA18405@filer.fsl.cs.sunysb.edu> <1185995431.18007.24.camel@kleikamp.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185995431.18007.24.camel@kleikamp.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 02:10:31PM -0500, Dave Kleikamp wrote:
> On Wed, 2007-08-01 at 14:44 -0400, Josef Sipek wrote:
> > Alright not the greatest of examples, there is something to be said about
> > symmetry, so...let me try again :)
> > 
> > /a/
> > /b/bar		(whiteout for bar)
> > /c/foo/qwerty
> > 
> > Now, let's mount a union of {a,b,c}, and we'll see:
> > 
> > $ find /u
> > /u
> > /u/foo
> > /u/foo/qwerty
> > $ mv /u/foo /u/bar
> > 
> > Now what? How do you rename? Do you rename in the same branch (assuming it
> > is rw)?
> 
> Er, no.  According to Documentation/filesystems/union-mounts.txt, "only
> the topmost layer of the mount stack can be altered".
 
This brings up an very interesting (but painful) question...which makes more
sense? Allowing the modifications in only the top-most branch, or any branch
(given the user allows it at mount-time)?

This is really question to the community at large, not just you, Dave :)

> > 1) "cp -r" the entire subtree being renamed to highest-priority branch, and
> > rename there (you might have to recreate a series of directories to have a
> > place to "cp" to...so you got "cp -r" _AND_ "mkdir -p"-like code in the VFS!
> > 1/2 a :) )
> 
> I think this is the only alternative, given the design.
 
Right. Doing something like this at the filesystem level (as we do in
unionfs) seems less painful - filesystems are places full of all sorts of
nefarious activities to begin with. Having it in the VFS seems...even
uglier.

Josef 'Jeff' Sipek.

-- 
*NOTE: This message is ROT-13 encrypted twice for extra protection*
