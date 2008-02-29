Return-Path: <linux-kernel-owner+w=401wt.eu-S933517AbYB2Un7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbYB2Un7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758733AbYB2Unt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:43:49 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:40280 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137AbYB2Unr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:43:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qpcox5Wn5JCsULAJ+wSzDJFUwim2lUMxbr+gg0o33ZT9OtJAtkZK89/cuEuzhgVSCC/mFBHV+BKWAPRe4QRDdESpFxgFKvzJXkZguT0+NsVo+4KnzzcIzK2juQS+dGScyPRwoLRLdVAN9SM4ne2TZhAka4jZgd0cFUHk+oiY8/I=
Message-ID: <c49095e30802291243x6087399w4b98ae251f57319b@mail.gmail.com>
Date: Fri, 29 Feb 2008 21:43:45 +0100
From: "Michael Kerrisk" <michael.kerrisk@googlemail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, aaw <aaw@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, carlos@codesourcery.com,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com, "Geoff Clare" <gwc@opengroup.org>
In-Reply-To: <alpine.LFD.1.00.0802291200580.17889@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204119455.6242.403.camel@lappy>
	 <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>
	 <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>
	 <1204305244.6243.111.camel@lappy>
	 <alpine.LFD.1.00.0802290934130.17889@woody.linux-foundation.org>
	 <1204307756.6243.121.camel@lappy> <47C84C6C.2000201@gmail.com>
	 <alpine.LFD.1.00.0802291032370.17889@woody.linux-foundation.org>
	 <c49095e30802291149t7ad01f6bl59b9083bfb41c920@mail.gmail.com>
	 <alpine.LFD.1.00.0802291200580.17889@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 9:07 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
>  On Fri, 29 Feb 2008, Michael Kerrisk wrote:
>
>  > On Fri, Feb 29, 2008 at 7:39 PM, Linus Torvalds
>  > <torvalds@linux-foundation.org> wrote:
>  >
>
> > >  I agree. And clearly there _are_ relationships and always have been, but
>  > >  equally clearly they simply haven't been a big issue in practice, and
>  > >  nobody really cares.
>  >
>  > Do we know that for sure?
>
>  We *do* know for sure that the relationship has always been there. At
>  least in Linux, and I bet in 99% of all other Unixes too. The arguments
>  simply have traditionally been counted as part of the stack size.
>
>  Or did you mean the latter part?

I meant: do we know for sure that no one really cares?

>  The fact is, we *also* know for sure that anybody that depends on
>  _SC_ARG_MAX being exact has always - and will continue to be - broken.
>  Again, because of not only older kernels but also because even with the
>  patch in question, we don't count argument sizes exactly.
>
>
>  > In my initial reply, I pointed out one example where users *may* care:
>  > NPTL uses RLIMIT_STACK to determine the size of per-thread stacks.  It
>  > is conceivable that users might want to set RLIMIT_STACK < 512k, and
>  > that would have the effect of lowering the amount of space for
>  > argv+eviron below what the kernel has historically guaranteed.  That's
>  > an ABI change, though it's unclear whether it would impact anyone in
>  > practice.
>
>  I do agree that we should at least make the "MAX(stacksize/4, 128k)"
>  change for backwards compatibility.

Good -- because that's probably the most important point, IMO.

> That is actually a potential
>  regression, but it has nothing to do with a new _SC_ARG_SIZE, because
>  quite frankly, it's a regression *regardless* of whether we'd expose a new
>  rlimit or not!

Agreed.

The new rlimit is primarily for the (supposed) applications that care
about knowing (at least approximately) what _SC_ARG_MAX is.  I raised
the initial bug report against glibc because applications can no
longer (post 2.6.23) do this, but I haven't done the investigation
about how many applications actually care.

Cheers,

Michael
