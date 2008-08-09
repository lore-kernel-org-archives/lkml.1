Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbYHIRSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbYHIRSb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 13:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYHIRSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 13:18:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60782 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbYHIRST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 13:18:19 -0400
Date: Sat, 9 Aug 2008 13:18:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ian Kent <raven@themaw.net>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/4] autofs4 - add miscelaneous device for ioctls
Message-ID: <20080809171816.GA2039@infradead.org>
References: <20080807114002.4142.30417.stgit@web.messagingengine.com> <20080807114030.4142.76568.stgit@web.messagingengine.com> <20080809125953.GB16308@infradead.org> <1218295750.2994.61.camel@raven.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218295750.2994.61.camel@raven.themaw.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 11:29:09PM +0800, Ian Kent wrote:
> 
> On Sat, 2008-08-09 at 08:59 -0400, Christoph Hellwig wrote:
> > On Thu, Aug 07, 2008 at 07:40:31PM +0800, Ian Kent wrote:
> > > The actual problem with autofs is that it can't reconnect to existing
> > > mounts. Immediately one things of just adding the ability to remount
> > > autofs file systems would solve it, but alas, that can't work. This is
> > > because autofs direct mounts and the implementation of "on demand mount
> > > and expire" of nested mount trees have the file system mounted on top of
> > > the mount trigger dentry.
> > 
> > So what you really need instead of all the ioctl cruft is to get access
> > to the sb of the hidden autofs4 mount.  One way to do that that I can
> > think of right now is to change from using get_sb_nodev as ->get_sb
> > to a variant that can find an existing superblock using some mount
> > options.
> 
> I wished I'd spoken to you about this a long time ago since you seem to
> know how I can do this using a remount option but this isn't enough of
> an explanation of how it can be done.
> 
> AFAICT, mount(8) will never be able to get a "struct path" or "struct
> nameidata" to a mount point that is covered using the path lookup in
> fs/namespace.c:do_*_mount() so we'll never be called back via any VFS
> methods. So tell me more about how this could work please!

Your introduction tells what you want to do is a remount, for which
finding the superblock is enough.  If that's not the actual requirement
please explain the requirement.  And don't point me to the gazillion
ioctls you added, that seems to mostly not have much to do with that..
