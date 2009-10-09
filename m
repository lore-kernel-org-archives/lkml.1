Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbZJIJMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbZJIJMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbZJIJME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:12:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:22578 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbZJIJME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:12:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,530,1249282800"; 
   d="scan'208";a="455930724"
Subject: Re: [PATCH 6/6] mce-inject: use injected mce only during faked
 handler call
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4ACEF4D9.9090600@jp.fujitsu.com>
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>
	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com>
	 <1255072482.5228.157.camel@yhuang-dev.sh.intel.com>
	 <4ACEE5E0.3050701@jp.fujitsu.com>
	 <1255074286.5228.163.camel@yhuang-dev.sh.intel.com>
	 <4ACEF4D9.9090600@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 17:11:24 +0800
Message-Id: <1255079484.5228.201.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 16:31 +0800, Hidetoshi Seto wrote: 
> Huang Ying wrote:
> > On Fri, 2009-10-09 at 15:27 +0800, Hidetoshi Seto wrote: 
> >> Huang Ying wrote:
> >>> This is another example for you to use my idea, implement it in a
> >>> similar way and send it out as your own.
> >> I used "Reported-by:" for this patch, having some intent to indicate
> >> that this patch uses an idea different from the original one, and that
> >> this patch aims at the problem certainly reported by you.
> > 
> > The point of the idea is to use two flags instead of one flag, not the
> > name of the flag or they are inside/outside of struct mce.
> 
> Humm, I could be wrong and could misread your comment...
> 
> The point of my idea is to use two separated flags, "inject_flags" for
> inject tool and "valid" for kernel, instead of one flag as you proposed,
> "inject_flags" shared by both. 
> And I think the flag for kernel should be outside of struct mce.
> 
> Once I complained about the name of flag ".finished", because you were
> trying to add "LOADED" flag.  I thought that "if .finished but !LOADED, it
> means the loading data to struct is finished but not loaded.. ???what???"

We have full control on these flags. In my original patch, I
set .finished = 0, before set MCJ_LOADED in .inject_flags. And I will
not set .finished = 1, before set MCJ_LOADED in inject_flags.

> So at first I tried to add 3rd state to ".finished", but soon I agreed
> that it is not good idea.
> 
> After that I started to think about having two separated flags, and the
> result is this [6/6] patch in -v2.
> 
> In short, I believe that my idea is "use two flags" and your idea is
> "share one flag" ... right?

No. There are many flags in .inject_flags (MCJ_EXCEPTION, MCJ_LOADED,
etc), .finished is just another flag.

The issue of original version is that .finished is used to indicate both
there is some data in injectm and injectm can be consumed. What I do is
to use two flags, .finished is used to indicate injectm can be consumed,
MCJ_LOADED is used to indicate there is some data in injectm. You just
change the name and the place of the two flags. In [6/6], you
use .finished to indicate there is some data in injectm and use
mce_fake_banks.valid to indicate injectm can be consumed.

It is OK to discuss the name and places of the two flags, but you should
not send out a similar patch and declare it is your idea. 

> The only thing what I want to do here is merge your "fix" into upstream.

You should provide comment, instead of sending out a similar patch and
declaring it is your idea.

Best Regards,
Huang Ying


