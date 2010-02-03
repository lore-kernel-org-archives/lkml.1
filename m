Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab0BCPBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:01:12 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:59549 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0BCPBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:01:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k4CnYIrIdsVTseWJGdp9xpR4lxVDYNQlLiNvvRI7APaDbVMmVtAfzJpVq/jpblpB/u
         UlAWwVf4IZmAif9zAYg3bYVU9ksvFL3s1p+LD2Hy5+0TychtG1Wv1GXynUfacVF2p/NQ
         nKmSIlXZr7G3ANSIFrp1GyzsnLNARuYWdyIi0=
Subject: Re: Improving OOM killer
From: Minchan Kim <minchan.kim@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: Lubos Lunak <l.lunak@suse.cz>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
In-Reply-To: <20100203122526.GG19641@balbir.in.ibm.com>
References: <201002012302.37380.l.lunak@suse.cz>
	 <20100203085711.GF19641@balbir.in.ibm.com>
	 <201002031310.28271.l.lunak@suse.cz>
	 <20100203122526.GG19641@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 00:00:54 +0900
Message-ID: <1265209254.1052.24.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 17:55 +0530, Balbir Singh wrote:
> * Lubos Lunak <l.lunak@suse.cz> [2010-02-03 13:10:27]:
> 
> > On Wednesday 03 of February 2010, Balbir Singh wrote:
> > > * Lubos Lunak <l.lunak@suse.cz> [2010-02-01 23:02:37]:
> > > >  In other words, use VmRSS for measuring memory usage instead of VmSize,
> > > > and remove child accumulating.
> > >
> > > I am not sure of the impact of changing to RSS, although I've
> > > personally believed that RSS based accounting is where we should go,
> > > but we need to consider the following
> > >
> > > 1. Total VM provides data about potentially swapped pages,
> > 
> >  Yes, I've already updated my proposal in another mail to switch from VmSize 
> > to VmRSS+InSwap. I don't know how to find out the second item in code, but at 
> > this point of discussion that's just details.
> > 

We have swap count with mm-count-swap-usage.patch by Kame in mmtom.

> I am yet to catch up with the rest of the thread. Thanks for heads up.
> 
> > > overcommit, 
> > 
> >  I don't understand how this matters. Overcommit is memory for which address 
> > space has been allocated but not actual memory, right? Then that's exactly 
> > what I'm claiming is wrong and am trying to reverse. Currently OOM killer 
> > takes this into account because it uses VmSize, but IMO it shouldn't - if a 
> > process does malloc(400M) but then it uses only a tiny fraction of that, in 
> > the case of memory shortage killing that process does not solve anything in 
> > practice.
> 
> We have a way of tracking commmitted address space, which is more
> sensible than just allocating memory and is used for tracking
> overcommit. I was suggesting that, that might be a better approach.

Yes. It does make sense. At least total_vm doesn't care about
MAP_NORESERVE case. But unfortunately, it's a per CPU not per Process.

> 
> > 
> > > etc.
> > > 2. RSS alone is not sufficient, RSS does not account for shared pages,
> > > so we ideally need something like PSS.
> > 
> >  Just to make sure I understand what you mean with "RSS does not account for 
> > shared pages" - you say that if a page is shared by 4 processes, then when 
> > calculating badness for them, only 1/4 of the page should be counted for 
> > each? Yes, I suppose so, that makes sense.
> 
> Yes, that is what I am speaking of

I agree. If we want to make RSS with base of badness, it's one of things
we have to solve.


-- 
Kind regards,
Minchan Kim


