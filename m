Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbXEJJXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbXEJJXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbXEJJX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:23:26 -0400
Received: from mx2.go2.pl ([193.17.41.42]:35009 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754238AbXEJJX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:23:26 -0400
Date: Thu, 10 May 2007 11:29:47 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH] timer: revert parenthesis fix in tbase_get_deferrable() etc.
Message-ID: <20070510092947.GA2741@ff.dom.local>
References: <653FFBB4508B9042B5D43DC9E18836F55DFC44@scsmsx415.amr.corp.intel.com> <20070510073904.GB2021@ff.dom.local> <20070510005738.cebd2a40.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510005738.cebd2a40.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 12:57:38AM -0700, Andrew Morton wrote:
> On Thu, 10 May 2007 09:39:04 +0200 Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > On 09-05-2007 21:10, Pallipadi, Venkatesh wrote:
> > ...
> > > On a 64 bit system, converting pointer to int causes unnecessary
> > > compiler
> > > warning, and intermediate long conversion was to avoid that. I will have
> > > to rephrase my comment to remove 32 bit value and use int, as that is
> > > what
> > > the function returns.
> > 
> > Sorry!!! So, it's perfectly right and logical.
> > 
> > It's a pity, you couldn't NACK this patch a little sooner.
> > I hope there is no problem to remove this patch now. 
> 
> Please send a new patch.  That way we get a nice explanation for the
> reversion, and we have well-oiled processes for applying patches, but
> crappy processes for reverting them.
> 

--->

[PATCH] timer: revert parenthesis fix in tbase_get_deferrable() etc.

> > On 09-05-2007 21:10, Pallipadi, Venkatesh wrote:
> > ...
> > > On a 64 bit system, converting pointer to int causes unnecessary
> > > compiler
> > > warning, and intermediate long conversion was to avoid that. I will have
> > > to rephrase my comment to remove 32 bit value and use int, as that is
> > > what
> > > the function returns.

So, this patch reverts all changes done by my previous patch.

I appologize for my wrong comment about "logical error" here.


Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp 2.6.21-git12-/kernel/timer.c 2.6.21-git12/kernel/timer.c
--- 2.6.21-git12-/kernel/timer.c	2007-05-10 10:55:34.000000000 +0200
+++ 2.6.21-git12/kernel/timer.c	2007-05-10 11:02:36.000000000 +0200
@@ -92,24 +92,24 @@ static DEFINE_PER_CPU(tvec_base_t *, tve
 /* Functions below help us manage 'deferrable' flag */
 static inline unsigned int tbase_get_deferrable(tvec_base_t *base)
 {
-	return (unsigned int)((unsigned long)base & TBASE_DEFERRABLE_FLAG);
+	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
 }
 
 static inline tvec_base_t *tbase_get_base(tvec_base_t *base)
 {
-	return (tvec_base_t *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG);
+	return ((tvec_base_t *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
 }
 
 static inline void timer_set_deferrable(struct timer_list *timer)
 {
-	timer->base = (tvec_base_t *)((unsigned long)timer->base |
-	                               TBASE_DEFERRABLE_FLAG);
+	timer->base = ((tvec_base_t *)((unsigned long)(timer->base) |
+	                               TBASE_DEFERRABLE_FLAG));
 }
 
 static inline void
 timer_set_base(struct timer_list *timer, tvec_base_t *new_base)
 {
-	timer->base = (tvec_base_t *)((unsigned long)new_base |
+	timer->base = (tvec_base_t *)((unsigned long)(new_base) |
 	                              tbase_get_deferrable(timer->base));
 }
 
