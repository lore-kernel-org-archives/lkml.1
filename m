Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbXELGPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbXELGPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 02:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXELGPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 02:15:45 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:18067 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbXELGPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 02:15:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sybDePqdBRSAev08rnUXZ+5o540I5AXLtAAVIhvq0pebv6VvWG9CYZKm/tAH5cqtjRZVN6N1EXNLy7q93HouC7NkJNM1emGDQa6brXz/iI1gRg1xsrnAvcpyV664o9KBDOGaICEs8RcC396UyCktDTMf3+7se7YqJD2WWajTDdw=
Message-ID: <a781481a0705112315u5843abaar292859428ec60603@mail.gmail.com>
Date: Sat, 12 May 2007 11:45:43 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] "volatile considered harmful", take 3
Cc: "Jonathan Corbet" <corbet@lwn.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Johannes Stezenbach" <js@linuxtv.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Heikki Orsila" <shdl@zakalwe.fi>,
       "jimmy bahuleyan" <knight.camelot@gmail.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <464551D5.2050709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12700.1178905000@lwn.net>
	 <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>
	 <464551D5.2050709@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/12/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Satyam Sharma wrote:
> >
> >> +  - Pointers to data structures in coherent memory which might be
> >> modified
> >> +    by I/O devices can, sometimes, legitimately be volatile.  A ring
> >> buffer
> >> +    used by a network adapter, where that adapter changes pointers to
> >> +    indicate which descriptors have been processed, is an example of
> >> this
> >> +    type of situation.
> >
> > is a legitimate use case for volatile is still not clear to me (I
> > agree with Alan's
> > comment in a previous thread that this seems to be a case where a memory
> > barrier would be applicable^Wbetter, actually). I could be wrong here, so
> > would be nice if Peter explains why volatile is legitimate here.
> >
> > Otherwise, it's fine with me.
> >
>
> I don't see why Alan's way is necessarily better;

Because volatile is ill-defined? Or actually, *undefined* (well,
implementation-defined is as good as that)? It's *so* _vague_,
one doesn't _feel_ like using it at all!

We already have a complete API containing optimization barriers,
load/store/full memory barriers. With well-defined and
well-understood semantics. Just ... _why_ use volatile?

> it should work but is

It will _always_ work. In fact you can't really say the same for
volatile. We already assume the compiler _actually_ took some
pains to stuff meaning into C's (lack of) definition of volatile and
implement it -- but in what sense, nobody knows (the C standard
doesn't, so what are we).

> more heavy-handed as it's disabling *all* optimization such as loop
> invariants across the barrier.

This is a legitimate criticism, I agree.

Thanks,
Satyam
