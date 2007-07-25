Return-Path: <linux-kernel-owner+w=401wt.eu-S1762698AbXGYGSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762698AbXGYGSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXGYGSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:18:34 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:42998 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750860AbXGYGSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:18:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=zyuYL5lp8Yi99Vm3nTjiNSG2pMLk63dUjpiNLuzXKYgM5LNCHZ2RqCIGUWLccBe0CYLM9HI01uWIsNlC+VXT/o/bj4gbv8anjiyUhvOqmDFPXnbXPuxWfFelx4+PPUtYcYHr7QzPllWWYChkfINcxonDYImbzFnVFUTwptvILCE=  ;
X-YMail-OSG: .npQFHgVM1mMxwkq1OmtGeLDP4.27aOqsdyWAYUpTnDr54vn9kwOwuutkASnCDLE7z2vqhA9DA--
Message-ID: <46A6EB32.70402@yahoo.com.au>
Date: Wed, 25 Jul 2007 16:18:26 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matthew Hawkins <darthmdh@gmail.com>
CC: Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       linux-kernel@vger.kernel.org, ck list <ck@vds.kolivas.org>,
       linux-mm@kvack.org, Paul Jackson <pj@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	 <200707102015.44004.kernel@kolivas.org>	 <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	 <46A57068.3070701@yahoo.com.au>	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>	 <46A58B49.3050508@yahoo.com.au>	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>	 <46A6CC56.6040307@yahoo.com.au> <b21f8390707242309r4a925737p777e507e473df1ab@mail.gmail.com>
In-Reply-To: <b21f8390707242309r4a925737p777e507e473df1ab@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Hawkins wrote:
> On 7/25/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> I'm not saying that we can't try to tackle that problem, but first of
>> all you have a really nice narrow problem where updatedb seems to be
>> causing the kernel to completely do the wrong thing. So we start on
>> that.
> 
> 
> updatedb isn't the only problem, its just an obvious one.  I like the
> idea of looking into the vfs for this and other one-shot applications
> (rather than looking at updatedb itself specifically)

That's the point, it is an obvious one. So it should be easy to work
out why it is going wrong, and fix it. (And hopefully that fixes some
of the less obvious problems too.)


> Many modern applications have a lot of open file handles.  For
> example, I just fired up my usual audio player and sys/fs/file-nr
> showed another 600 open files (funnily enough, I have roughly that
> many audio files :)  I'm not exactly sure what happens when this one
> gets swapped out for whatever reason (firefox/java/vmware/etc chews
> ram, updatedb, whatever) but I'm fairly confident what happens between
> kswapd and the vfs and whatever else we're caching is not optimal come
> time for this process to context-switch back in.  We're not running a
> highly-optimised number-crunching scientific app on desktops, we're
> running a full herd of poorly-coded hogs simultaneously through
> smaller pens.

And yet nobody wants to take the time to properly analyse why these
things are going wrong and reporting their findings? Or if they have,
where is that documented?

-- 
SUSE Labs, Novell Inc.
