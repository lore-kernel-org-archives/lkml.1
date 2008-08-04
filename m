Return-Path: <linux-kernel-owner+w=401wt.eu-S1761962AbYHDHGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962AbYHDHGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 03:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758185AbYHDHGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 03:06:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:43672 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030AbYHDHGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 03:06:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,303,1215414000"; 
   d="scan'208";a="367648794"
Subject: Re: [patch 0/2] reduce agpgart memory allocation time
From: Shaohua Li <shaohua.li@intel.com>
To: Dave Airlie <airlied@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <21d7e9970808032353m40fcea6dtbf1b7bc1c5cf06d9@mail.gmail.com>
References: <1217832677.21811.7.camel@sli10-desk.sh.intel.com>
	 <21d7e9970808032353m40fcea6dtbf1b7bc1c5cf06d9@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 15:14:39 +0800
Message-Id: <1217834079.9799.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 16:53 +1000, Dave Airlie wrote:
> On Mon, Aug 4, 2008 at 4:51 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> > agpgart memory allocation is quite expensive. For each page agpgart
> > allocated, it changes the page to uc and as result flush tlb/cache for
> > the page. In my test, Intel Xorg driver takes about 0.2s for a 32M 3D
> > fb, and the total time for memory allocation is about 0.33s when intel
> > xorg driver initializes. Below patches fix the gap. It can reduce the
> > time to 0.03s, so xserver can boot 0.3s faster.
> >
> 
> This approach is quite like what was there before, and I think was
> objected to on the grounds the caller might forget to
> call the flush and leave the system in an inconsistent state.
> Personally I've never bought that argument, its not like we have
> thousands of users for this API.
> 
> I proposed an alternative interface but I failed to get it merged and
> ran out of time
> http://www.ussg.iu.edu/hypermail/linux/kernel/0804.3/1112.html
> 
> I was trying to get the cpa interface to allow arrays of pages to be
> passed in, I was then going to change AGP like
> http://git.kernel.org/?p=linux/kernel/git/airlied/agp-2.6.git;a=shortlog;h=agp-pageattr2
This is good too.

> I really should fix those patches up at some point, feel free to base
> a system on those if someone objects to the method with the call site
> doing the flush.
Ok, if people object the method, I'll refresh your patches.

Thanks,
Shaohua

