Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbZD1PnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbZD1PnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbZD1PnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:43:08 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53564 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbZD1PnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:43:07 -0400
To: tj@kernel.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net
In-reply-to: <49F043A4.2060700@kernel.org> (message from Tejun Heo on Thu, 23
	Apr 2009 19:32:04 +0900)
Subject: Re: [PATCHSET] CUSE: implement CUSE, take #3
References: <1239674094-30894-1-git-send-email-tj@kernel.org> <E1Lwanr-00041r-RP@pomaz-ex.szeredi.hu> <49EFB1A9.3060503@kernel.org> <E1LwvrC-00068P-5r@pomaz-ex.szeredi.hu> <49F043A4.2060700@kernel.org>
Message-Id: <E1LypSa-0004fR-J1@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 28 Apr 2009 17:43:04 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Thu, 23 Apr 2009, Tejun Heo wrote:
> Miklos Szeredi wrote:
> > VFS inode should never be needed by the CUSE codepaths.  Well, maybe
> > for setting access/modification times, but in any case those need not
> > be shared with fuse code.
> 
> One more usage: locking.

You mean inode->i_mutex locking?  It doesn't look to me as if cuse
would need to do any of that.

> > I don't see any problems with doing the device initialization in the
> > context of the replying process (which will usually be the same as
> > the one opening the device anyway).
> 
> I don't know.  If it's simple, sure why not.  If it makes things even
> marginally more complex (state saving and so on), why go that way?

OK, I folded FUSE_INIT into CUSE_INIT, and moved the CUSE_INIT reply
processing into the ->end() callback.  This also allows us to remove
the CUSE_INIT_DONE message, since now the write(2) on the cuse device
will only return when the device initialization is complete.

Overall it results in some 100 lines less code (well, some of that is
because I folded <linux/cuse.h> into <linux/fuse.h>).  But the simpler
initialization sequence is, I think, definitely worth it.

The patches are pushed out to the 'cuse' and 'for-next' branches of

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git

I'll post the updated libfuse patch as well.  Please let me know if
you find anything wrong with the current patches.

Thanks,
Miklos
