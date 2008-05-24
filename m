Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbYEXHA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbYEXHA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 03:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbYEXHAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 03:00:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48336 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbYEXHAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 03:00:11 -0400
To: zippel@linux-m68k.org
CC: miklos@szeredi.hu, hch@infradead.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.64.0805232347500.18302@localhost.localdomain>
	(message from Roman Zippel on Fri, 23 May 2008 23:52:20 +0200 (CEST))
Subject: Re: [patch 06/14] hfsplus: remove hfsplus_permission()
References: <20080521171458.077908538@szeredi.hu> <20080521171549.964767446@szeredi.hu>
 <Pine.LNX.4.64.0805212232500.18302@localhost.localdomain>
 <E1Jz5gq-0007F4-AQ@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221358080.18302@localhost.localdomain>
 <E1Jz9jk-0007rg-5W@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221427300.18302@localhost.localdomain>
 <E1JzA2r-0007uK-8L@pomaz-ex.szeredi.hu> <20080523092114.GD27119@infradead.org>
 <Pine.LNX.4.64.0805231712120.18302@localhost.localdomain>
 <E1JzZF5-0002Hz-5e@pomaz-ex.szeredi.hu> <E1JzZWC-0002M8-UP@pomaz-ex.szeredi.hu>
 <Pine.LNX.4.64.0805231824370.18302@localhost.localdomain>
 <E1Jzbai-0002d1-VC@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805232027220.18302@localhost.localdomain>
 <E1JzcZj-0002mJ-28@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805232347500.18302@localhost.localdomain>
Message-Id: <E1JznjI-0003fD-9i@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 24 May 2008 08:59:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Semi-concrete: link(2) locks the target's parent and the source.
> > Cross-directory rename(2) locks both parents.  If link's target is a
> > file which has children, this can result in an ABBA deadlock.  That's
> > _before_ the filesystem's ->link() or ->rename() function is called.
> 
> I'm afraid you have to be more concrete than this. 
> hfsplus_file_inode_operations doesn't have a link or rename operation, so 
> if one your source parents above involves a file, it shouldn't get this 
> far or you have to describe your scenario in more detail.

Heh, you just want me to do all the hard work :)

OK, I'll go along:

  /mnt/a/x is a regular file

  ln /mnt/a/x /mnt/b/x
  rename /mnt/a/x /mnt/b/x/p & ln /mnt/b/x /mnt/a/q

Neither ->rename nor ->link is required to be defined on x.  The
rename will first lock x, then a.  The link will first lock a then x,
AFAICS.

This is probably just one of several ways to make it deadlock.

Hmm?

Miklos
