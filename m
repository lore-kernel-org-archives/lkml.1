Return-Path: <linux-kernel-owner+w=401wt.eu-S935734AbYEBVrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935734AbYEBVrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932125AbYEBVr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:47:26 -0400
Received: from lazybastard.de ([212.112.238.170]:32819 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbYEBVrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:47:25 -0400
Date: Fri, 2 May 2008 23:47:04 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
Message-ID: <20080502214704.GF24080@logfs.org>
References: <20080502133234.GA24080@logfs.org> <200805021852.22768.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805021852.22768.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 18:52:21 +0200, Arnd Bergmann wrote:
> 
> There are still a few i's and t's left to dot and cross:
> 
> * the changeset comments needs a Signed-off-by: line

Doh!  When sending patches that happens automatically.  I should teach
git the same trick.

> * The MAINTAINERS file should list your name and logfs mailing list

Definitely.

> * you have a few instances of '#if LINUX_VERSION_CODE > 
>   KERNEL_VERSION(2, 6, 23)', that should go away for the merge

Yes.  I would like to keep the merge version roughly in sync with the
external patch, at least for a while.  Not sure how to deal with one
needing the multi-version hackery and the other not wanting it.

> * The copyright notice says 2005-2007, it should probably be 2005-2008

On most files, yes.

> * You may want to add a Documentation/filesystems/logfs.txt file explaining
>   the supported mount options.

Sure.  I don't have any logfs-specific ones yet, but even that fact
should be made explicit.

> * CONFIG_LOGFS should be tristate, not bool. Unfortunately, you are still
>   using three symbols that are not exported: swapper_space (through
>   BUG_ON(!page_mapping(page)->a_ops->set_page_dirty)), add_to_page_cache_lru
>  and inode_lock. Not sure what to do about this.

inode_lock will get fixed.  The BUG_ON could get removed.  Not sure
about add_to_page_cache_lru yet.

> * You should really make sure the version you check in compiles, 
>   fs/logfs/logfs.h is missing an #endif. ;-)

Making a merge dash whilst moving is not always the wisest choice. ;)

> Otherwise, I don't see any reasons why logfs shouldn't go in. The code is
> clean, feature-complete, and there is demand for it. The main question
> I can still see is the timing with the merge window. It's almost closed,
> so if logfs doesn't go in really soon, it should probably wait for the
> 2.6.27 window.

2.6.27 appears to make more sense, yes.

> This patch fixes some of the problems mentined above.

Excellent!  Thanks a bunch!

> +L:	logfs@logfs.org

I believe it is currently subscribers-only with the usual bounces
everyone holds so dear.  I should change that and add a spam filter to
make it bearable.

Jörn

-- 
The only real mistake is the one from which we learn nothing.
-- John Powell
