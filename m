Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbYDDLF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbYDDLF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 07:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYDDLFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 07:05:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45546 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYDDLFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 07:05:17 -0400
To: ezk@cs.sunysb.edu
CC: viro@zeniv.linux.org.uk, ezk@cs.sunysb.edu, trond.myklebust@fys.uio.no,
       miklos@szeredi.hu, akpm@linux-foundation.org, dave@linux.vnet.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <200804032324.m33NOlqa030835@agora.fsl.cs.sunysb.edu> (message
	from Erez Zadok on Thu, 3 Apr 2008 19:24:47 -0400)
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
References: <200804032324.m33NOlqa030835@agora.fsl.cs.sunysb.edu>
Message-Id: <E1Jhjj3-0002i8-6W@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 04 Apr 2008 13:04:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In message <20080403023239.GY9785@ZenIV.linux.org.uk>, Al Viro writes:
> > On Wed, Apr 02, 2008 at 10:21:24PM -0400, Erez Zadok wrote:
> > > Yes, I do grab both vfsmount and superblock refs.  I found out that grabbing
> > > vfsmount refs wasn't enough to prevent "umount -l" from detaching the f/s on
> > > which I'm stacked on.  So now at mount time (or branch management time), I
> > > grab those super-refs, as I have them after a successful path_lookup.  And,
> > > since I keep a list of the branches I'm stacked on, I know precisely which
> > > superblocks' references I need to release when unionfs is unmounted.
> > 
> > How the devil would holding a superblock prevent umount -l?
> 
> It doesn't prevent umount -l; but it prevents the lower superblock from
> being kfree()d if there were no references left to it, so I don't try to
> accessed freed memory (and get 6b6b6b6b oopses :-)

Having a ref on the vfsmount should be enough, regardless of whether
the mount is attached or not.  There's nothing special about a
detached mount, that anything outside namespace.c should care about.

Miklos
