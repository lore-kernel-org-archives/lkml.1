Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZFZDGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZFZDGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 23:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZFZDGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 23:06:00 -0400
Received: from cmpxchg.org ([85.214.51.133]:58141 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbZFZDGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 23:06:00 -0400
Date: Fri, 26 Jun 2009 05:02:28 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-06-25-15-49 uploaded
Message-ID: <20090626030228.GA9279@cmpxchg.org>
References: <200906252249.n5PMnaPt016847@imap1.linux-foundation.org> <4A440D59.50400@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A440D59.50400@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 04:50:49PM -0700, Randy Dunlap wrote:
> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-06-25-15-49 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> 
> 
> shrink_slab-handle-bad-shrinkers.patch:
> 
> mm/vmscan.c: In function 'do_try_to_free_pages':
> mm/vmscan.c:1697: error: too few arguments to function 'disable_swap_token'
> mm/vmscan.c: In function 'balance_pgdat':
> mm/vmscan.c:1869: error: too few arguments to function 'disable_swap_token'
> mm/vmscan.c: In function '__zone_reclaim':
> mm/vmscan.c:2425: error: too few arguments to function 'disable_swap_token'

Sorry, my fault - `make CONFIG_SWAP=n` didn't work as I assumed.  The
patch Randy pointed out seems unrelated to this, though...?

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: make swap token dummies static inlines fix

disable_swap_token() doesn't take an argument.  This fixes the
!CONFIG_SWAP dummy.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 9b02f33..6c990e6 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -432,7 +432,7 @@ static inline int has_swap_token(struct mm_struct *mm)
 	return 0;
 }
 
-static inline void disable_swap_token(struct mm_struct *mm)
+static inline void disable_swap_token(void)
 {
 }
 
