Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbZLBILK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbZLBILK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZLBILK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:11:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54453 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbZLBILJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:11:09 -0500
Date: Wed, 2 Dec 2009 09:11:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Haicheng Li <haicheng.li@intel.com>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/24] HWPOISON: limit hwpoison injector to known page
 types
Message-ID: <20091202081102.GA16218@elte.hu>
References: <20091202031231.735876003@intel.com>
 <20091202043045.711553780@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202043045.711553780@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wu Fengguang <fengguang.wu@intel.com> wrote:

> --- linux-mm.orig/mm/hwpoison-inject.c	2009-11-30 20:44:41.000000000 +0800
> +++ linux-mm/mm/hwpoison-inject.c	2009-11-30 20:58:20.000000000 +0800
> @@ -3,16 +3,41 @@
>  #include <linux/debugfs.h>
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
> +#include <linux/swap.h>
>  #include "internal.h"
>  
>  static struct dentry *hwpoison_dir;
>  
>  static int hwpoison_inject(void *data, u64 val)
>  {

i'd like to raise a continuing conceptual objection against the ad-hoc 
and specialistic nature of the event injection in the 
mm/memory-failure*.c code. It should probably be using a standardized 
interface by integrating with perf events - as i outlined it before.

Where needed perf events should be extended - we can help with that. 
There's no point in having scattered pieces of incompatible (and 
user-ABI affecting) infrastructure all around the kernel.

Thanks,

	Ingo

