Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbYFCRo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbYFCRo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbYFCRos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:44:48 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58172 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753109AbYFCRos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:44:48 -0400
X-Sasl-enc: il1vM1luXVxZBtPVFT7b6sqkAKQzuYmkeup1KNPn4iOK 1212515086
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080603174125.GE28946@ZenIV.linux.org.uk>
References: <20080603104035.GT28946@ZenIV.linux.org.uk>
	 <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
	 <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212509263.3025.66.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
	 <20080603164102.GB28946@ZenIV.linux.org.uk>
	 <20080603165042.GC28946@ZenIV.linux.org.uk>
	 <1212514104.3025.110.camel@raven.themaw.net>
	 <20080603174125.GE28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 01:41:32 +0800
Message-Id: <1212514893.3025.123.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-03 at 18:41 +0100, Al Viro wrote:
> On Wed, Jun 04, 2008 at 01:28:23AM +0800, Ian Kent wrote:
> > 
> > On Tue, 2008-06-03 at 17:50 +0100, Al Viro wrote:
> > > On Tue, Jun 03, 2008 at 05:41:03PM +0100, Al Viro wrote:
> > > 
> > > > >From my reading of that code looks like it's been rmdir'ed.  And no, I
> > > > don't understand what the hell is that code trying to do.
> > > > 
> > > > Ian, could you describe the race you are talking about?
> > > 
> > > BTW, this stuff is definitely broken regardless of mount - if something
> > > had the directory in question opened before that rmdir and we'd hit
> > > your lookup_unhashed while another CPU had been in the middle of
> > > getdents(2) on that opened descriptor, we'll get
> > > 
> > > vfs_readdir() grabs i_mutex
> > > vfs_readdir() checks that it's dead
> > > autofs4_lookup_unhashed() calls iput()
> > 
> > Can this really happen, since autofs4_lookup_unhashed() is only called
> > with the i_mutex held.
> 
> i_mutex on a different inode (obviously - it frees the inode in question,
> so if caller held i_mutex on it, you would be in trouble every time you
> hit that codepath).

OK, I'll need to look at vfs_readdir().
I thought vfs_readdir() would take the containing directory mutex as
does ->lookup().


