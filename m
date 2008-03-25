Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYCYQIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYCYQIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbYCYQII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:08:08 -0400
Received: from lazybastard.de ([212.112.238.170]:33154 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbYCYQIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:08:07 -0400
Date: Tue, 25 Mar 2008 17:07:35 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, jirislaby@gmail.com,
       viro@ZenIV.linux.org.uk, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups - formatting only
Message-ID: <20080325160734.GA14583@logfs.org>
References: <20080323085210.GE10722@ZenIV.linux.org.uk> <20080323.032013.79276201.davem@davemloft.net> <47E647AC.1060906@gmail.com> <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080325134556.GA10424@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 March 2008 14:45:56 +0100, Ingo Molnar wrote:
> 
> and let me give an example with the your very own code that you wrote 
> and maintain, drivers/mtd/devices/block2mtd.c:
> 
>                                     errors   lines of code   errors/KLOC
> drivers/mtd/devices/block2mtd.c         10             490          20.4
> 
> that's pretty OK code, but not perfect, the 10 errors are:
> 
>  ERROR: do not use C99 // comments
>  ERROR: need spaces around that '=' (ctx:VxV)
>  ERROR: need spaces around that '<' (ctx:VxV)
>  ERROR: do not use C99 // comments
>  ERROR: do not use C99 // comments
>  ERROR: do not use C99 // comments
>  ERROR: do not use C99 // comments
>  ERROR: do not use C99 // comments
>  ERROR: do not use C99 // comments
>  ERROR: do not initialise statics to 0 or NULL

The last should and will be fixed.  The // I don't really care about.
Send a patch if you do.

Going over my logfs patch, I found several things that are either false
positives or rather questionable in my book.  <adds Andy to Cc:>


(foo*) should be (foo *)
	What does that extra space gain us?


ERROR: no space before that close parenthesis ')'
#2565: FILE: fs/logfs/gc.c:294:
+                       seg_ofs + sizeof(oh) < super->s_segsize; ) {

Actual code is this:
	for (seg_ofs = LOGFS_SEGMENT_HEADERSIZE;
			seg_ofs + sizeof(oh) < super->s_segsize; ) {
The for() loop is missing one of its three terms.  I assume this is one
of the effects of not having a perfect C parser.


ERROR: trailing statements should be on next line
#5000: FILE: fs/logfs/readwrite.c:203:
+       } else while (unlikely(TestSetPageLocked(page))) {

We have an explicit exception for "else if".  "else while" makes imo
just as much (or as little) sense.


ERROR: need space after that ',' (ctx:VxV)
#5801: FILE: fs/logfs/readwrite.c:1004:
+               ret = logfs_segment_read(inode, ipage, this_wc->ofs, bix,level);
                                      
One of those examples where a missing space is the lesser of two or
three evils.


ERROR: need consistent spacing around '|' (ctx:WxV)
#8293: FILE: fs/logfs/dev_mtd.c:376:
+                       |SLAB_MEM_SPREAD|SLAB_PANIC),

I have no idea what this is about.  Original code:
	mtd_cache = kmem_cache_create("mtd_cache", sizeof(struct mtd_inode), 0,
			(SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT
			 |SLAB_MEM_SPREAD|SLAB_PANIC),

Jörn

-- 
Victory in war is not repetitious.
-- Sun Tzu
