Return-Path: <linux-kernel-owner+w=401wt.eu-S1762382AbXKNWmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762382AbXKNWmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbXKNWmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:42:33 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:25891 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754799AbXKNWmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:42:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=R/8xn/FddChHNm0txQSzZuKFojF5qCryvSLn/V8EL9GXg6munrFybKUcnOlMmUghD6eSyPt9DR0dexTfkasVftzArP62XbY/XVYsu6PhDfNCLYQSaW5JsnF24JADc9Xr+eswu8ZLxgGCMqch82MPx+4EUGHQKo0/DXKm3GQsphk=  ;
X-YMail-OSG: r0c2LCUVM1k2SFHHOob1FJnJkwICEIS4mrIbqm_YCQgzcw4sNm2TeRl9kptvIJrUiblI9coiiw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Date: Wed, 14 Nov 2007 21:17:55 +1100
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, hch@infradead.org,
       akpm@linux-foundation.org, gregkh@suse.de, mucci@cs.utk.edu,
       eranian@hpl.hp.com, wcohen@redhat.com, robert.richter@amd.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org
References: <20071114.031216.11725447.davem@davemloft.net> <200711141125.18568.nickpiggin@yahoo.com.au> <18235.26873.437786.651828@cargo.ozlabs.ibm.com>
In-Reply-To: <18235.26873.437786.651828@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711142117.56352.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 08:30, Paul Mackerras wrote:
> Nick Piggin writes:
> > What I really mean is a readv-like syscall, but one that also
> > vectorises the file offset. Maybe this is useful enough as a generic
> > syscall that also helps Paul's example...
>
> I've sometimes thought it would be useful to have a "transaction"
> system call that is like a write + read combined into one:
>
> 	int transaction(int fd, char *req, size_t req_nb,
> 			char *reply, size_t reply_nb);
>
> as a way to provide a general request/reply interface for special
> files.

Maybe not a bad idea, though I'm not the one to ask about taste ;)
In this case, it is enough for your requests to be a set of scalars
(eg. file offsets), so it _could_ be handled with vectorised offsets...

But in general, for special files, I guess the response is usually
some structured data (that is not visible at the syscall layer).
So I don't see a big problem to have a similarly arbitrarily
structured request.


> > Of course, I guess this all depends on whether the atomicity is an
> > important requirement. If not, you can obviously just do it with
> > multiple read syscalls...
>
> That would take N system calls instead of one, which could have a
> performance impact if you need to read the counters frequently (which
> I believe you do in some performance monitoring situations).

That's true too.
