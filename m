Return-Path: <linux-kernel-owner+w=401wt.eu-S1763143AbXHQSgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763143AbXHQSgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 14:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbXHQSgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 14:36:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52525 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbXHQSgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 14:36:05 -0400
Subject: Re: kfree(0) - ok?
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Satyam Sharma <satyam@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070817112253.e6a7cb33.akpm@linux-foundation.org>
References: <46C233CB.9000602@am.sony.com>
	 <1187132149.2618.2.camel@laptopd505.fenrus.org>
	 <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
	 <20070817112253.e6a7cb33.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 17 Aug 2007 11:31:54 -0700
Message-Id: <1187375514.2615.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-08-17 at 11:22 -0700, Andrew Morton wrote:
> On Wed, 15 Aug 2007 05:12:41 +0530 (IST)
> Satyam Sharma <satyam@infradead.org> wrote:
> 
> > [PATCH] {slub, slob}: use unlikely() for kfree(ZERO_OR_NULL_PTR) check
> > 
> > Considering kfree(NULL) would normally occur only in error paths and
> > kfree(ZERO_SIZE_PTR) is uncommon as well, so let's use unlikely() for
> > the condition check in SLUB's and SLOB's kfree() to optimize for the
> > common case. SLAB has this already.
> 
> I went through my current versions of slab/slub/slub and came up with this:
> 
> diff -puN mm/slob.c~slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check mm/slob.c
> --- a/mm/slob.c~slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check
> +++ a/mm/slob.c
> @@ -360,7 +360,7 @@ static void slob_free(void *block, int s
>  	slobidx_t units;
>  	unsigned long flags;
>  
> -	if (ZERO_OR_NULL_PTR(block))
> +	if (unlikely(ZERO_OR_NULL_PTR(block)))



btw this makes NO sense at all; gcc already defaults to assuming
unlikely if you check a pointer for NULL....


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

