Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbXEOP0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbXEOP0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 11:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbXEOP0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 11:26:10 -0400
Received: from lazybastard.de ([212.112.238.170]:60896 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbXEOP0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 11:26:09 -0400
Date: Tue, 15 May 2007 17:21:49 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Cc: akpm@osdl.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Review status (Re: [PATCH] LogFS take three)
Message-ID: <20070515152149.GB32059@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070515151919.GA32510@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Most of my homework is done.  There are six items left plus another five
I believe should not get changed.


Changed:
o Kconfig description updated
o Spaces converted to tabs in Makefile
o Sorted/seperated #includes
o structures are __packed instead of packed, #define removed
o removed TRACE()
o 32bit magic is u instead of ull now
o #defines aligned
o Removed obsolete #defines, documented rest
o LOGFS_SUPER and LOGFS_INODE are inline functions now
o removed alloc_disk_sum and free_disk_sum
o moved dir_callback up
o removed pointless cast from max() parameter
o moved LOGFS_LINK_MAX to header
o license headers
o removed logfs_writepage()
o introduced and documented LOGFS_SEGMENT_RESERVE
o documented completion dance in mtderase()
o removed isbad() check from mtderase()
o removed logfs_device_getpage() and logfs_cached_read()
o resurrected code to pick correct device
o removed beXX typedefs
o removed safe_read()
o removed wrapper in logfs_cleanup_gc()
o device_read() returns error
o renamed logfs_alloc_blocks() to match current implementation
o kerneldoc comments for structures
o removed logfs_compress_none and logfs_uncompress_none
o Split header
o move fsck behind debug option


Changed many times (and I sincerely hope not to have missed any):
o removed // comments, usually dead code
o added newline between variable declarations and code
o moved tail comments
o minor code cleanups
o changed comment style
o added loglevels to printk


Unchanged:
o enum for OBJ_TOP_JOURNAL and friends
  Afaics all the potential enums end up being converted through cpu_to_64XX,
  I'll have to see if that causes more problems than the enums can hope to
  solve.
o generic function for logfs_type()
o generic helper for logfs_prepare_write()
o removed EOF
o error handling
o move rootdir generation back to mkfs


Won't happen (unless I get convinced to do otherwise):
o lowercase LOGFS_SUPER and LOGFS_INODE
  These simply match the common pattern used is many Linux filesystems.
o remove "extern"
  For structures, this keyword actually serves a purpose and makes sense.
  On the other hand, it is completely bogus for functions and I won't be
  bullied into adding bogus crud either.
o Move fs/logfs/Locking to Documentation/
  At least JFFS2 has such documentation in its own directory as well.
  I can see good arguments for either side and no strong consensus.  While
  I ultimately just don't case, doing nothing is a good option in cases
  of great uncertainty.
o change (void*) to "proper" cast
  Neither variant is much better than the other.  I'm open for suggestions
  to completely remove the casts, though.
o Change LOGFS_BUG() and LOGFS_BUG_ON() to inline functions
  These are macros for very much the same reasons BUG() and BUG_ON() are.


Jörn

-- 
To my face you have the audacity to advise me to become a thief - the worst
kind of thief that is conceivable, a thief of spiritual things, a thief of
ideas! It is insufferable, intolerable!
-- M. Binet in Scarabouche
