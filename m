Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbXJJIQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbXJJIQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 04:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbXJJIQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 04:16:23 -0400
Received: from mx01.qsc.de ([213.148.129.14]:59108 "EHLO mx01.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbXJJIQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 04:16:21 -0400
X-Greylist: delayed 1914 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2007 04:16:20 EDT
From: =?iso-8859-15?q?Ren=E9_Rebe?= <rene@exactcode.de>
Organization: ExactCODE
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.23
Date: Wed, 10 Oct 2007 09:44:16 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710100944.16378.rene@exactcode.de>
X-Spam-Score: -3.6 (---)
X-Spam-Report: Spam detection software, running on the system "exactcode.de", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Hi Linus et al., 2.6.23 does not build with my usual .config
	on x86_64 and gcc-4.2.1: In file included from fs/drop_caches.c:8: include/linux/mm.h:1210:
	warning: 'struct super_block' declared inside parameter list nclude/linux/mm.h:1210:
	warning: its scope is only this definition or declaration, which is probably
	not what you want fs/drop_caches.c:17: error: conflicting types for 'drop_pagecache_sb'
	include/linux/mm.h:1210: error: previous declaration of 'drop_pagecache_sb'
	was here fs/drop_caches.c:28: error: conflicting types for 'drop_pagecache_sb'
	include/linux/mm.h:1210: error: previous declaration of 'drop_pagecache_sb'
	was here [...] 
	Content analysis details:   (-3.6 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.5 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.5 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus et al.,

2.6.23 does not build with my usual .config on x86_64 and gcc-4.2.1:

In file included from fs/drop_caches.c:8:
include/linux/mm.h:1210: warning: 'struct super_block' declared inside parameter list
nclude/linux/mm.h:1210: warning: its scope is only this definition or declaration, which is probably not what you want
fs/drop_caches.c:17: error: conflicting types for 'drop_pagecache_sb'
include/linux/mm.h:1210: error: previous declaration of 'drop_pagecache_sb' was here
fs/drop_caches.c:28: error: conflicting types for 'drop_pagecache_sb'
include/linux/mm.h:1210: error: previous declaration of 'drop_pagecache_sb' was here

A little forward declaration fixes this:

--- linux-2.6.23/include/linux/mm.h.vanilla	2007-10-10 09:28:33.000000000 +0200
+++ linux-2.6.23/include/linux/mm.h	2007-10-10 09:30:23.000000000 +0200
@@ -1207,6 +1207,7 @@
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 			unsigned long lru_pages);
+struct super_block;
 extern void drop_pagecache_sb(struct super_block *);
 void drop_pagecache(void);
 void drop_slab(void);

You probably end up fixing it some other way, but as I do not know this
file inside out I just wanted to drop a note.

Yours,
  René Rebe

On Tuesday 09 October 2007 22:54:30 Linus Torvalds wrote:

> Finally.
> 
> Yeah, it got delayed, not because of any huge issues, but because of 
> various bugfixes trickling in and causing me to reset my "release clock" 
> all the time. But it's out there now, and hopefully better for the wait.
> 
> Not a whole lot of changes since -rc9, although there's a few updates to 
> mips, sparc64 and blackfin in there.  Ignoring those arch updates, there's 
> basically a number of mostly one-liners (mostly in drivers, but there's 
> some networking fixes and soem VFS/VM fixes there too).
> 
> Shortlog and diffstat appended (both relative to -rc9, of course - the 
> full log from 2.6.22 is on kernel.org as usual).
> 
> I want this to be what people look at for a few days, but expect the x86 
> merge to go ahead after that. So far, all indications are still that it's 
> going to be all smooth sailing, but hey, those indicators seem to always 
> say that, and only after the fact do people notice any problems ;)
> 
> 		Linus

-- 
  René Rebe - ExactCODE GmbH - Europe, Germany, Berlin
  http://exactcode.de | http://t2-project.org | http://rene.rebe.name
