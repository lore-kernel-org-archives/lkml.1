Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYFCRlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYFCRlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYFCRlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:41:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57049 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbYFCRlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:41:31 -0400
Date: Tue, 3 Jun 2008 18:41:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080603174125.GE28946@ZenIV.linux.org.uk>
References: <20080603104035.GT28946@ZenIV.linux.org.uk> <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu> <20080603105258.GV28946@ZenIV.linux.org.uk> <1212499623.3025.46.camel@raven.themaw.net> <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org> <1212509263.3025.66.camel@raven.themaw.net> <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org> <20080603164102.GB28946@ZenIV.linux.org.uk> <20080603165042.GC28946@ZenIV.linux.org.uk> <1212514104.3025.110.camel@raven.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212514104.3025.110.camel@raven.themaw.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 01:28:23AM +0800, Ian Kent wrote:
> 
> On Tue, 2008-06-03 at 17:50 +0100, Al Viro wrote:
> > On Tue, Jun 03, 2008 at 05:41:03PM +0100, Al Viro wrote:
> > 
> > > >From my reading of that code looks like it's been rmdir'ed.  And no, I
> > > don't understand what the hell is that code trying to do.
> > > 
> > > Ian, could you describe the race you are talking about?
> > 
> > BTW, this stuff is definitely broken regardless of mount - if something
> > had the directory in question opened before that rmdir and we'd hit
> > your lookup_unhashed while another CPU had been in the middle of
> > getdents(2) on that opened descriptor, we'll get
> > 
> > vfs_readdir() grabs i_mutex
> > vfs_readdir() checks that it's dead
> > autofs4_lookup_unhashed() calls iput()
> 
> Can this really happen, since autofs4_lookup_unhashed() is only called
> with the i_mutex held.

i_mutex on a different inode (obviously - it frees the inode in question,
so if caller held i_mutex on it, you would be in trouble every time you
hit that codepath).
