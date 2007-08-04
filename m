Return-Path: <linux-kernel-owner+w=401wt.eu-S1764796AbXHDQQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764796AbXHDQQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759289AbXHDQQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:16:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758860AbXHDQQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:16:36 -0400
Date: Sat, 4 Aug 2007 09:15:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
In-Reply-To: <20070804070737.GA940@elte.hu>
Message-ID: <alpine.LFD.0.999.0708040912480.5037@woody.linux-foundation.org>
References: <20070803123712.987126000@chello.nl>
 <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
 <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 4 Aug 2007, Ingo Molnar wrote:
> 
> i forgot this entry:
> 
>  " We recently upgraded our office to gigabit Ethernet and got some big 
>    AMD64 / 3ware boxes for file and vmware servers... only to find them 
>    almost useless under any kind of real load. I've built some patched 
>    2.6.21.6 kernels (using the bdi throttling patch you mentioned) to 
>    see if our various Debian Etch boxes run better. So far my testing 
>    shows a *great* improvement over the stock Debian 2.6.18 kernel on 
>    our configurations. "

Well, quite frankly, there are other changes between 2.6.18 and 2.6.21 
that are more likely to be a big deal than Peter's patches. No offense to 
Peter, but we also cut the default dirty percentage by a factor of four in 
that timeframe, and that made a *huge* difference for some setups (and 
admittedly not so much on others ;)

> and bdi has been in -mm in the past i think, so we also know (to a 
> certain degree) that it does not hurt those workloads that are fine 
> either.

Hey, I'm not complaining. I think the code looks fine. I just want to make 
sure that it actually helps.

> [ my personal interest in this is the following regression: every time i
>   start a large kernel build with DEBUG_INFO on a quad-core 4GB RAM box,
>   i get up to 30 seconds complete pauses in Vim (and most other tasks),
>   during plain editing of the source code. (which happens when Vim tries
>   to write() to its swap/undo-file.) ]

So do the patches really end up helping your case? Or is this just why 
you're following it, and hoping they'll eventually do so?

		Linus
