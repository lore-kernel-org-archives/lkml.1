Return-Path: <linux-kernel-owner+w=401wt.eu-S1761363AbXGLHZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761363AbXGLHZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 03:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbXGLHY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 03:24:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38187 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbXGLHY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 03:24:57 -0400
Subject: Re: [RFT][PATCH] mm: drop behind
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Pepper <lnxninja@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <eada2a070707111537p20ab429anebd8b1840f5e5b5f@mail.gmail.com>
References: <1184007008.1913.45.camel@twins>
	 <eada2a070707111537p20ab429anebd8b1840f5e5b5f@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 09:24:46 +0200
Message-Id: <1184225086.20032.45.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On Wed, 2007-07-11 at 15:37 -0700, Tim Pepper wrote:
> On 7/9/07, Peter Zijlstra <peterz@infradead.org> wrote:
> > Use the read-ahead code to provide hints to page reclaim.
> >
> > This patch has the potential to solve the streaming-IO trashes my
> > desktop problem.
> >
> > It tries to aggressively reclaim pages that were loaded in a strong
> > sequential pattern and have been consumed. Thereby limiting the damage
> > to the current resident set.
> 
> Interesting...
> 
> Would it make sense to tie this into (finally) making
> POSIX_FADV_NOREUSE something more than a noop?

We talked about that, but the thing is, if we make the functionality
conditional, nobody will ever use it :-/

So, yes, in a perfect world that would indeed make sense. However since
nobody ever uses these [fm]advise calls,..

So the big question is, does this functionally hurt any workload? If it
turns out it does (which I still doubt) then we might hide it behind
knobs, otherwise I'd like to keep it always on.

Peter



