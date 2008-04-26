Return-Path: <linux-kernel-owner+w=401wt.eu-S1760445AbYDZVHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445AbYDZVHX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 17:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762431AbYDZVHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 17:07:03 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:44045 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762401AbYDZVG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 17:06:57 -0400
Date: Sun, 27 Apr 2008 00:06:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai.lu@sun.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, jbarnes@virtuousgeek.org
Subject: Re: [git pull] "big box" x86 changes, boot protocol
Message-ID: <20080426210632.GW2252@cs181133002.pp.htv.fi>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426195407.GA13729@elte.hu> <20080426133928.a6f40caa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080426133928.a6f40caa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 01:39:28PM -0700, Andrew Morton wrote:
> On Sat, 26 Apr 2008 21:54:07 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>...
> >
> > +void __init free_early(unsigned long start, unsigned long end)
> > +{
> > +	struct early_res *r;
> > +	int i, j;
> > +
> > +	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
> > +		r = &early_res[i];
> > +		if (start == r->start && end == r->end)
> > +			break;
> > +	}
> > +	if (i >= MAX_EARLY_RES || !early_res[i].end)
> > +		panic("free_early on not reserved area: %lx-%lx!", start, end);
> > +
> > +	for (j = i + 1; j < MAX_EARLY_RES && early_res[j].end; j++)
> > +		;
> > +
> > +	memcpy(&early_res[i], &early_res[i + 1],
> > +	       (j - 1 - i) * sizeof(struct early_res));
> 
> nit: memcpy() shouldn't be used for overlapping copies.  It happens to be
> OK (for dst<src) in the kernel implementations.  We hope.
>...

We always use the gcc builtin for memcpy() here.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

