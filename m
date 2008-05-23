Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbYEWTFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbYEWTFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYEWTFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:05:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50901 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYEWTFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:05:23 -0400
To: zippel@linux-m68k.org
CC: miklos@szeredi.hu, hch@infradead.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.64.0805232027220.18302@localhost.localdomain>
	(message from Roman Zippel on Fri, 23 May 2008 20:33:30 +0200 (CEST))
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
Message-Id: <E1JzcZj-0002mJ-28@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 23 May 2008 21:05:11 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  a) it's nontrivial to fix (even understanding the problem is
> >  nontrivial, see Documentation/filesystems/directory-locking)
> 
> Please provide a concrete example, as long as I only get handwaving I can 
> only wave back.

Semi-concrete: link(2) locks the target's parent and the source.
Cross-directory rename(2) locks both parents.  If link's target is a
file which has children, this can result in an ABBA deadlock.  That's
_before_ the filesystem's ->link() or ->rename() function is called.

> >  b) the feature is obviously unused, so the easiest fix is simply to
> >  remove it for the time being.
> 
> You have a weird definition of "obviously unused", not every user may even 
> have noticed it's gone, e.g. there are some rsync versions, which support 
> this and these won't complain if they can't open the resource fork.

Dunno.  What's the difference between "it wasn't used" and "it didn't
work and nobody noticed"?  I think not much :)

Miklos
