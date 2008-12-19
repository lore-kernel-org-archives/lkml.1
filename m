Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYLSBro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYLSBro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 20:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYLSBrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 20:47:31 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40259 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918AbYLSBr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 20:47:29 -0500
X-Sasl-enc: Bbybn4ygRN9tqPHm81kCWkoHOnOatswb7d3paDljQcH/ 1229651248
Subject: Re: [rfc git patch] union directory
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, jblunck@suse.de, dlezcano@fr.ibm.com,
       linux-kernel@vger.kernel.org, bharata@linux.vnet.ibm.com,
       viro@ZenIV.linux.org.uk, Valerie Aurora Henson <vaurora@redhat.com>
In-Reply-To: <E1LDLzo-0007oD-Lg@pomaz-ex.szeredi.hu>
References: <E1L616K-0005v3-Uc@pomaz-ex.szeredi.hu>
	 <alpine.LFD.2.00.0812171350350.11591@zeus.themaw.net>
	 <E1LDLzo-0007oD-Lg@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 10:47:22 +0900
Message-Id: <1229651242.3026.39.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 17:45 +0100, Miklos Szeredi wrote:
> On Wed, 17 Dec 2008, Ian Kent wrote:
> > On Fri, 28 Nov 2008, Miklos Szeredi wrote:
> > 
> > > I've been doing some small fixing/cleanup work on the union directory
> > > patches by Jan, and just noticed there's a thread about the union
> > > mounts on LKML, so I thought publicizing won't hurt.
> > > 
> > > It's still a work in progress, notably the readdir code currently only
> > > works on a few specific filesystem types.
> > > 
> > > Git tree is here:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git union-dir
> > 
> > I'm confused?
> > 
> > This doesn't look like the complete set of Jan Blunks union mount
> > patches.  Am I mistaken?
> 
> You're not mistaken, this is not the original patch set, but a reduced
> one (also by Jan), further reduced and cleaned up by me.

OK, I'll have a closer look, sorry for side tracking the thread (even
though I'm going to continue to do so, hehe).

> 
> The original patch set implemented deep unioning of directory trees.
> This one implements only unioning of the mount's top level directory.
> 
> > But this also made me think about the issues surrounding whiteout support 
> > as having to add per-file system support for such things is bound to lead 
> > to a maintenance headache. So why not a well defined modular interface 
> > layer that includes these bits and is also responsible for context 
> > persistence, independent of file system?
> 
> I don't think such a layer is in the scope of this patch set.  It may
> be a nice thing, but it will almost certainly be implemented in a
> filesystem, not in the VFS.  Union mounts, as opposed to unionfs and
> its ilk, are supposed to be very lightweight.

Exactly, and that is partly my point.

Whether the VFS is implementing readdir for a mount's top level or also
for deeper levels it still has the issue described by Barata Rao in
http://marc.info/?l=linux-fsdevel&m=118914402631822&w=2. But my
suggestion doesn't only relate to the readdir issue it implies managing
such things as whiteout persistence also, but outside of individual file
systems. So, yes, I'm a bit off topic but the patch series here is going
to need something like this somewhere to ultimately be useful and all
I'm saying is that somewhere probably shouldn't be within individual
file systems and, yes, not in the VFS.

Valerie Henson is planning to start a project (when she is done with
current commitments) along the lines of a lightweight stacking layer
with union support included in the file system. These continuing
individual efforts are a little disjoint so such a project could be an
ideal way to define what's needed, what the issues are and how it will
be done in one place. Hopefully everyone that is keen to see progress in
this area will want to be involved too, ;)

Sorry for the off-topic rant, I just can't resist sometimes.

Ian

