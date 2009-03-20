Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbZCTHAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbZCTHAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 03:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbZCTHAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 03:00:25 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15951 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbZCTHAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 03:00:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=nU1WfcUs6i+J7GntneKk8EKXYh6PM254NZ40PUQt5ApgNrq7tHHu8lvPsE88WTEnG
	j4acfQLXSezKtJ9U++MDw==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0903191741280.3030@localhost.localdomain>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com>
	 <20090318151157.85109100.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0903181522570.3082@localhost.localdomain>
	 <604427e00903191734l42376eebsee018e8243b4d6f5@mail.gmail.com>
	 <alpine.LFD.2.00.0903191741280.3030@localhost.localdomain>
Date: Fri, 20 Mar 2009 00:00:17 -0700
Message-ID: <604427e00903200000n157a59a0od47b12975232d4cf@mail.gmail.com>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
From: Ying Han <yinghan@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 5:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 19 Mar 2009, Ying Han wrote:
>> >
>> > Ying Han - since you're all set up for testing this and have reproduced it
>> > on multiple kernels, can you try it on a few more kernel versions? It
>> > would be interesting to both go further back in time (say 2.6.15-ish),
>> > _and_ check something like 2.6.21 which had the exact dirty accounting
>> > fix. Maybe it's not really an old bug - maybe we re-introduced a bug that
>> > was fixed for a while.
>>
>> I tried 2.6.24 for couple of hours and the problem not happening yet. While
>> the same test on 2.6.25, the problem happen right away.
>
> Ok, so 2.6.25 is known bad. Can you test 2.6.24 a lot more, because we
> should not decide that it's bug-free without a _lot_ of testing.
>
> But if it's a bug that has gone away and then re-appeared, it at least
> explains how 2.6.21 (which got a fair amount of mmap testing) didn't have
> lots of reports of mmap corruption.
>
> That said, I can think of nothing obvious in between 2.6.24 and .25 that
> would have re-introduced it. But if some heavy testing really does confirm
> that 2.6.24 doesn't have the problem, that is a good first step to trying
> to narrow down where things started going wrong.
>
> That said, it could _easily_ be some timing-related pattern. One of the
> things in between 2.6.24 and .25 is
>
>  - 8bc3be2751b4f74ab90a446da1912fd8204d53f7: "writeback: speed up
>   writeback of big dirty files"
>
> which is that exact kind of "change the timing patterns, but don't change
> anything fundamental" thing.
>
> Which is why I'd like you to continue testing 2.6.24 just to be _really_
> sure that it really doesn't happen there.

Unfortunately, 2.6.24 is not immune. After running several hours, i triggered
the problem.
>
>                Linus
>
