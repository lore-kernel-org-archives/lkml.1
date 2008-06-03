Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYFCNqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYFCNqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 09:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYFCNp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 09:45:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52395 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752235AbYFCNp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:45:57 -0400
X-Sasl-enc: SsrimojTk2tLGBnLv2KjAcPNuHs92ZGX9w1cVre16etz 1212499817
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, jesper@krogh.cc,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080603105258.GV28946@ZenIV.linux.org.uk>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	 <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>
	 <20080603095713.GR28946@ZenIV.linux.org.uk>
	 <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk>
	 <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
	 <20080603104035.GT28946@ZenIV.linux.org.uk>
	 <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
	 <20080603105258.GV28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 21:27:02 +0800
Message-Id: <1212499623.3025.46.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-03 at 11:52 +0100, Al Viro wrote:
> On Tue, Jun 03, 2008 at 12:45:33PM +0200, Miklos Szeredi wrote:
> 
> > I think it must be autofs4 doing something weird.  Like this in
> > autofs4_lookup_unhashed():
> > 
> > 			/*
> > 			 * Make the rehashed dentry negative so the VFS
> > 			 * behaves as it should.
> > 			 */
> > 			if (inode) {
> > 				dentry->d_inode = NULL;
> 
> Lovely.  If we ever step into that with somebody else (no matter who)
> holding a reference to that dentry, we are certainly well and truly
> buggered.  It's not just mount(2) - everything in the tree assumes that
> holding a reference to positive dentry guarantees that it remains
> positive.

The intent here is that, the dentry above is unhashed at this point, and
if hasn't been reclaimed by the VFS, it is made negative and replaces
the unhashed negative dentry passed to ->lookup(). The reference count
is incremented to account for the reference held by the path walk.

What am I doing wrong here?
 
Ian


