Return-Path: <linux-kernel-owner+w=401wt.eu-S933857AbXGZOTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857AbXGZOTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759953AbXGZOTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:19:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:47542 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759938AbXGZOTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kKSGtbAEKZmV7T7Ohk6swijRIAgBUJ8Z7220TincKR+vraL2BUeaI6royKuM5DGeLaJ4f+W3zyETidEMgXgGQwJIABL0zVCg9ybYl0piu3dzFo3Z4/jk+JyPpLucUAQEgTnK2hG7Jwqd3mFMR1BOi5sdFJCldk8dFXW5sfqY420=
Message-ID: <b14e81f00707260719w63d8ab38jbf2a17a38bd07c1d@mail.gmail.com>
Date: Thu, 26 Jul 2007 10:19:06 -0400
From: "Michael Chang" <thenewme91@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Cc: "Ray Lee" <ray-lk@madrabbit.org>, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Eric St-Laurent" <ericstl34@sympatico.ca>,
       linux-kernel@vger.kernel.org, "ck list" <ck@vds.kolivas.org>,
       linux-mm@kvack.org, "Paul Jackson" <pj@sgi.com>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Rene Herman" <rene.herman@gmail.com>
In-Reply-To: <20070725215717.df1d2eea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	 <46A58B49.3050508@yahoo.com.au>
	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	 <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com>
	 <1185341449.7105.53.camel@perkele> <46A6E1A1.4010508@yahoo.com.au>
	 <2c0942db0707250909r435fef75sa5cbf8b1c766000b@mail.gmail.com>
	 <20070725215717.df1d2eea.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 25 Jul 2007 09:09:01 -0700
> "Ray Lee" <ray-lk@madrabbit.org> wrote:
>
> > No, there's a third case which I find the most annoying. I have
> > multiple working sets, the sum of which won't fit into RAM. When I
> > finish one, the kernel had time to preemptively swap back in the
> > other, and yet it didn't. So, I sit around, twiddling my thumbs,
> > waiting for my music player to come back to life, or thunderbird,
> > or...
>
> In fact I'd restate the problem as "system is in steady state A, then there
> is a workload shift causing transition to state B, then the system goes
> idle.  We now wish to reinstate state A in anticipation of a resumption of
> the original workload".
>
> swap-prefetch solves a part of that.
>
> A complete solution for anon and file-backed memory could be implemented
> (ta-da) in userspace using the kernel inspection tools in -mm's maps2-*
> patches.  We would need to add a means by which userspace can repopulate
> swapcache, but that doesn't sound too hard (especially when you haven't
> thought about it).
>
> And userspace can right now work out which pages from which files are in
> pagecache so this application can handle pagecache, swap and file-backed
> memory.  (file-backed memory might not even need special treatment, given
> that it's pagecache anyway).
>
> And userspace can do a much better implementation of this
> how-to-handle-large-load-shifts problem, because it is really quite
> complex.  The system needs to be monitored to determine what is the "usual"
> state (ie: the thing we wish to reestablish when the transient workload
> subsides).  The system then needs to be monitored to determine when the
> exceptional workload has started, and when it has subsided, and userspace
> then needs to decide when to start reestablishing the old working set, at
> what rate, when to abort doing that, etc.
>
> All this would end up needing runtime configurability and tweakability and
> customisability.  All standard fare for userspace stuff - much easier than
> patching the kernel.

Maybe I'm missing something here, but if the problem is resource
allocation when switching from state A to state B, and from B to C,
etc.; wouldn't it be a bad thing if state B happened to be (in the
future) this state-shifting userspace daemon of which you speak? (Or
is that likely to be impossible/unlikely for some other reason which
alludes me at the moment?)

-- 
Michael Chang

Please avoid sending me Word or PowerPoint attachments. Send me ODT,
RTF, or HTML instead.
See http://www.gnu.org/philosophy/no-word-attachments.html
Thank you.
