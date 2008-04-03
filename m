Return-Path: <linux-kernel-owner+w=401wt.eu-S1760798AbYDCTcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760798AbYDCTcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759398AbYDCTbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:31:42 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46738 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758566AbYDCTbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:31:41 -0400
Date: Thu, 3 Apr 2008 15:31:27 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, hch@infradead.org
Subject: Re: fs_stack/eCryptfs: remove 3rd arg of copy_attr_all, add
	locking to copy_inode_size
Message-ID: <20080403193127.GA640@josefsipek.net>
References: <200804031907.m33J70fQ025437@agora.fsl.cs.sunysb.edu> <Pine.LNX.4.64.0804032014350.4616@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804032014350.4616@blonde.site>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 08:26:54PM +0100, Hugh Dickins wrote:
> On Thu, 3 Apr 2008, Erez Zadok wrote:
> > In message <20080403182001.GB30189@josefsipek.net>, "Josef 'Jeff' Sipek" writes:
> > > I think you need to check CONFIG_PREEMPT as well.
> > 
> > I'm not sure if it's needed in case of CONFIG_PREEMPT.  Anyone?  The code
> > for i_size_write (below), and the comment at the top of the function,
> > suggest that the spinlock is needed only to prevent the lots seqcount.
> 
> Correct.
 
True...

> > BTW, some time ago I reviewed all callers of i_size_write.  I did so again
> > just now, and the results were the same:
> > 
> > - a LOT of callers of i_size_write don't take any lock
> 
> They mostly know that i_mutex is already held (as i_size_write comment
> mentions); but I believe that's up to the individual filesystem.

Is this function (fsstack_copy_inode_size) used only in unlocked paths? If
there's little chance that it'll ever need to be used in locked paths, then
sure, why not have the lock right in the function.

Josef 'Jeff' Sipek.

-- 
My public GPG key can be found at
http://www.josefsipek.net/gpg/public-0xC7958FFE.txt
