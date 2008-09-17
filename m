Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYIQTKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYIQTKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYIQTJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:09:57 -0400
Received: from sh.osrg.net ([192.16.179.4]:51688 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbYIQTJ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:09:57 -0400
Date: Thu, 18 Sep 2008 04:09:45 +0900 (JST)
Message-Id: <20080918.040945.32654226.ryusuke@osrg.net>
To: joern@logfs.org
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, kihara.seiji@lab.ntt.co.jp,
       amagai.yoshiji@lab.ntt.co.jp
Subject: Re: [PATCH 25/27] nilfs2: block cache for garbage collection
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20080917144146.GD8750@logfs.org>
References: <1221419304-18572-25-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1221419304-18572-26-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20080917144146.GD8750@logfs.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 16:41:47 +0200, Jörn Engel wrote:
> On Mon, 15 September 2008 04:08:22 +0900, Ryusuke Konishi wrote:
> > 
> > This adds the cache of on-disk blocks to be moved in garbage
> > collection.  The disk blocks are held with dummy inodes (called
> > gcinodes), and this file provides lookup function of the dummy inodes,
> > and their buffer read function.
> 
> Nice explanation.  Can you add it to the comment header at the top of
> the file?  Unlike the GPL preample, it actually helps non-lawyers. ;)

Well, I see. ;)

> Using dummy inodes is... unusual.  Why can you not use the actual inodes
> those blocks belong to?

Because we have to treat blocks that belong to a same file but have
different checkpoint numbers.  (NILFS2 keeps up multiple
checkpoints/snapshots across GC)

Of course, if the standard inode hash is applicable, I prefer it.
ilookup5 or its variant may be applicable for this.

If so, the remaining problem would be the lock dependencies as you
mentioned before.

> Or alternatively a single inode that simply
> covers the complete physical device?
> 
> Jörn

NILFS2 writes GC blocks per file like other files, so the per file
caches (even separate inodes) are convienient for this end.

Ryusuke
