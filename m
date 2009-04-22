Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZDVCx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZDVCx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 22:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZDVCxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 22:53:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44569 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZDVCxq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 22:53:46 -0400
Date: Wed, 22 Apr 2009 05:45:16 +0300
From: Izik Eidus <ieidus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-04-21-15-00 uploaded
Message-ID: <20090422054516.122ac635@woof.tlv.redhat.com>
In-Reply-To: <20090421185313.06bec1cc.akpm@linux-foundation.org>
References: <200904212219.n3LMJ2O7007301@imap1.linux-foundation.org>
	<49EE7351.6080802@oracle.com>
	<20090421185313.06bec1cc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009 18:53:13 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 21 Apr 2009 18:30:57 -0700 Randy Dunlap
> <randy.dunlap@oracle.com> wrote:
> 
> > akpm@linux-foundation.org wrote:
> > > The mm-of-the-moment snapshot 2009-04-21-15-00 has been uploaded
> > > to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > and will soon be available at
> > > 
> > >    git://git.zen-sources.org/zen/mmotm.git
> > > 
> > > It contains the following patches against 2.6.30-rc2:
> > 
> > 
> > 2 of 10 i386 builds ended like:
> > 
> > 
> >   CC      arch/x86/kernel/asm-offsets.s
> > In file included from include/linux/suspend.h:8,
> >                  from arch/x86/kernel/asm-offsets_32.c:11,
> >                  from arch/x86/kernel/asm-offsets.c:2:
> > include/linux/mm.h: In function 'get_pte':
> > include/linux/mm.h:907: error: implicit declaration of function
> > 'kmap_atomic_pte' make[2]: *** [arch/x86/kernel/asm-offsets.s]
> > Error 1 make[1]: *** [prepare0] Error 2
> > make: *** [sub-make] Error 2
> > 
> > 
> > 
> > config attached.
> 
> Caused by ksm-add-get_pte-helper-function-fetching-pte-for-va.patch.
> 
> hm, this will end badly.  Let's uninline it.
> 

Yes, anyway let include this patch that remove the usage of
asm\types.h, we sure dont need this header.
(it doesnt look risky as linux\types.h by itself will include it, but
i have bad feeling about it)

Thanks.

>From fc71a2c22019b1f0389b249e5987b0b2a208764f Mon Sep 17 00:00:00 2001
From: Izik Eidus <ieidus@redhat.com>
Date: Wed, 22 Apr 2009 05:24:03 +0300
Subject: [PATCH] ksm: ksm.h remove the asm\types.h header usage

We surely dont need it, as we include linux\types.h above, that will
include that anyway.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
---
 include/linux/ksm.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index 2c11e9a..c0849c7 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -8,8 +8,6 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 
-#include <asm/types.h>
-
 #define KSM_API_VERSION 1
 
 #define ksm_control_flags_run 1
-- 
1.5.6.5

