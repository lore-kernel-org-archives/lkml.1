Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbXKAJPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbXKAJPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 05:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbXKAJOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 05:14:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32968
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753376AbXKAJOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 05:14:52 -0400
Date: Thu, 01 Nov 2007 02:14:51 -0700 (PDT)
Message-Id: <20071101.021451.217578606.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071101.000118.208338243.davem@davemloft.net>
References: <20071031.181335.207429553.davem@davemloft.net>
	<Pine.LNX.4.64.0710312115520.26072@schroedinger.engr.sgi.com>
	<20071101.000118.208338243.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 01 Nov 2007 00:01:18 -0700 (PDT)

> From: Christoph Lameter <clameter@sgi.com>
> Date: Wed, 31 Oct 2007 21:16:59 -0700 (PDT)
> 
> > Index: linux-2.6/mm/allocpercpu.c
> > ===================================================================
> > --- linux-2.6.orig/mm/allocpercpu.c	2007-10-31 20:53:16.565486654 -0700
> > +++ linux-2.6/mm/allocpercpu.c	2007-10-31 21:00:27.553486484 -0700
>  ...
> > @@ -37,7 +42,7 @@ enum unit_type { FREE, END, USED };
> >  
> >  static u8 cpu_alloc_map[UNITS_PER_CPU] = { 1, };
> >  static DEFINE_SPINLOCK(cpu_alloc_map_lock);
> > -static DEFINE_PER_CPU(int, cpu_area)[UNITS_PER_CPU];
> > +static DEFINE_PER_CPU(unsigned long long, cpu_area)[UNITS_PER_CPU];
> >  
> >  #define CPU_DATA_OFFSET ((unsigned long)&per_cpu__cpu_area)
> >  
> 
> This hunk helped the sparc64 looping OOPS I was getting, but cpus hang
> in some other fashion soon afterwards.

And if I bump PER_CPU_ALLOC_SIZE up to 128K it seems to mostly work.

You'll definitely need to make this work dynamically somehow.
