Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbZAGD1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbZAGD1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 22:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZAGD1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 22:27:44 -0500
Received: from sh.osrg.net ([192.16.179.4]:58664 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbZAGD1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 22:27:44 -0500
Date: Wed, 07 Jan 2009 12:26:53 +0900 (JST)
Message-Id: <20090107.122653.111144635.ryusuke@osrg.net>
To: penberg@cs.helsinki.fi
Cc: konishi.ryusuke@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: 2.6.29 -mm merge plans
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <84144f020901060530w2b7fef67j8f1f2242860df3bd@mail.gmail.com>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<c4a7c9420901050140u23697729pc55966110d68452b@mail.gmail.com>
	<84144f020901060530w2b7fef67j8f1f2242860df3bd@mail.gmail.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Tue, 6 Jan 2009 15:30:59 +0200, "Pekka Enberg" wrote:
> Hi Ryusuke,
> 
> [snip nilfs patches]
> 
> On Mon, Jan 5, 2009 at 11:40 AM, Ryusuke Konishi
> <konishi.ryusuke@lab.ntt.co.jp> wrote:
> >>  Dunno.   Has this been reviewed enough?
> >>
> >
> > I'm now working to follow some comments from Chris, and
> > I think nilfs should be reviewed more widely.
> >
> > I'll aim for the next merge window or so.
> 
> It would be nice if BUG(), BUG_ON(), and panic() calls would be
> converted to proper error handling using WARN_ON() calls. The BUG()
> call in nilfs_cpfile_delete_checkpoints(), for example, looks to be
> triggerable from user-space via the ioctl() system call (albeit I
> didn't look too closely).

Thanks for looking at the code.

Well, there are too many BUG() and BUG_ON() calls.
I'll try to convert them as your advice.

The use of panic() call is a mimic of ext2/3, and this is called only
if an "errors=panic" mount option is specified.
Do you think it should be removed along with the mount option for
new filesystems ?

> Furthermore, the BUG() calls in error paths
> of fs/nilfs2/ioctl.c look really fishy.

I agree, but this seems to need some consideration.
I'll try to remove them separately if not easy.

> On a related note, there are quite a few new ioctls there. Are they
> described somewhere?

Not yet.  Where is the recommended place to put it in?

And, Chris Mason today gave me another comment on the ioctls; he
pointed out there is a structure using unfixed sized types (compat
ioctls are used to instead).

I agree with his comment.  I'd like to rewrite the ioctl declarations
and remove compat ioctls some time soon.

> Also, can they be converted to use
> ->unlocked_ioctl? It's bit sad that we're adding new users of BKL in
> shiny new code.

All right, I'll do some tests for it.

Regards,
Ryusuke Konishi
