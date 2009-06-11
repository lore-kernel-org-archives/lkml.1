Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbZFKHY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbZFKHY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 03:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbZFKHYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 03:24:21 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40511 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbZFKHYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 03:24:21 -0400
Subject: Re: [PATCH 2/2] sched: use slab in cpupri_init()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       yinghai@kernel.org
In-Reply-To: <4A309FDD.4030804@cn.fujitsu.com>
References: <Pine.LNX.4.64.0906110846330.2617@melkki.cs.Helsinki.FI>
	 <4A309FDD.4030804@cn.fujitsu.com>
Date: Thu, 11 Jun 2009 10:24:22 +0300
Message-Id: <1244705062.17483.9.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li!

On Thu, 2009-06-11 at 14:10 +0800, Li Zefan wrote:
> > @@ -163,9 +167,7 @@ int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)
> 
> so the __init_refok tag can be removed, no?

I am not sure how this is related to my patch but as long as
init_rootdomain() has it, cpupri_init() should too AFAICT.

			Pekka

> >  
> >  		spin_lock_init(&vec->lock);
> >  		vec->count = 0;
> > -		if (bootmem)
> > -			alloc_bootmem_cpumask_var(&vec->mask);
> > -		else if (!zalloc_cpumask_var(&vec->mask, GFP_KERNEL))
> > +		if (!zalloc_cpumask_var(&vec->mask, gfp))
> >  			goto cleanup;
> >  	}
> >  

