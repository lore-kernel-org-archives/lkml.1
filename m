Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYFCKxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYFCKxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYFCKxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:53:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59376 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbYFCKxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:53:00 -0400
Date: Tue, 3 Jun 2008 11:52:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jesper@krogh.cc, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080603105258.GV28946@ZenIV.linux.org.uk>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk> <20080603095713.GR28946@ZenIV.linux.org.uk> <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk> <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu> <20080603104035.GT28946@ZenIV.linux.org.uk> <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 12:45:33PM +0200, Miklos Szeredi wrote:

> I think it must be autofs4 doing something weird.  Like this in
> autofs4_lookup_unhashed():
> 
> 			/*
> 			 * Make the rehashed dentry negative so the VFS
> 			 * behaves as it should.
> 			 */
> 			if (inode) {
> 				dentry->d_inode = NULL;

Lovely.  If we ever step into that with somebody else (no matter who)
holding a reference to that dentry, we are certainly well and truly
buggered.  It's not just mount(2) - everything in the tree assumes that
holding a reference to positive dentry guarantees that it remains
positive.

Ian?
