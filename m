Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbZKQLT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbZKQLT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbZKQLT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:19:28 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:54752 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbZKQLT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:19:28 -0500
Date: Tue, 17 Nov 2009 20:19:25 +0900 (JST)
Message-Id: <20091117.201925.543479723824311889.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
       fweisbec@gmail.com, ling.ma@intel.com
Subject: Re: [PATCH 1/4] perf bench: Add new subsystem and new suite,
 bench/mem-memcpy.c
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091113094650.GA1364@elte.hu>
References: <1258086186-32317-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<1258086186-32317-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<20091113094650.GA1364@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/4] perf bench: Add new subsystem and new suite, bench/mem-memcpy.c
Date: Fri, 13 Nov 2009 10:46:50 +0100

I've fixed mem-memcpy.c according to your comment,
but I also have some comments.

> 
> > +};
> > +
> > +struct routine routines[] = {
> > +	{ "default",
> > +	  memcpy,
> > +	  "Default memcpy() provided by glibc" },
> > +	{ NULL,
> > +	  NULL,
> > +	  NULL }
> 
> { NULL, } would be equivalent i guess.

Initializing the termination with { NULL, } causes build error.
So I can't change this point.

> > +		break;
> > +	case BENCH_FORMAT_SIMPLE:
> > +		if (use_clockcycle)
> > +			printf("%lf\n",
> > +			       (double)clock_diff / (double)length);
> > +		else
> > +			printf("%lf\n", bps);
> > +		break;
> > +	default:
> > +		/* reaching here is something disaster */
> > +		fprintf(stderr, "Unknown format:%d\n", bench_format);
> 
> could use pr_err() here i guess.

It seems that pr_err() is a wrapper for printk(),
so I can't use pr_err() in perf.

I'll send the patch later. Thanks for your comments!
	Hitoshi
