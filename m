Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbYCJWUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbYCJWUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYCJWTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:19:52 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34092 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYCJWTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:19:50 -0400
Subject: Re: [PATCH 1/3] enhanced lookup ESTALE error handling (v3)
From: Dave Hansen <haveblue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, staubach@redhat.com,
       linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@lst.de
In-Reply-To: <E1JYq5I-0000D9-8a@pomaz-ex.szeredi.hu>
References: <4790C761.1010603@redhat.com> <47A387CF.70201@redhat.com>
	 <47D598C5.7080609@redhat.com>
	 <20080310143832.08ad52a9.akpm@linux-foundation.org>
	 <E1JYq5I-0000D9-8a@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Mon, 10 Mar 2008 15:19:44 -0700
Message-Id: <1205187584.8385.6.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-10 at 23:03 +0100, Miklos Szeredi wrote:
> > > This is a patch to enhance ESTALE error handling during the
> > > lookup process.  The error, ESTALE, can occur when out of data
> > > dentries, stored in the dcache, is used to translate a pathname
> > > component to a dentry.  When this occurs, the dentry which
> > > contains the pointer to the inode which refers to the non-existent
> > > file is dropped from the dcache and then the lookup process
> > > started again.  Care is taken to ensure that forward process is
> > > always being made.  If forward process is not detected, then the
> > > lookup process is terminated and the error, ENOENT, is returned
> > > to the caller.
> > 
> > This collides in non-trivial ways with the always-coming-never-arrives
> > r-o-bind-mounts patches.
> > 
> > I have an old version of those patches in -mm and I believe that Al
> > is/was/has set up some git tree with these patches and perhaps other stuff.

Al's tree is here:

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/viro/vfs-2.6.git;a=summary

It's probably best to try and base your patches on top of there.  

-- Dave

