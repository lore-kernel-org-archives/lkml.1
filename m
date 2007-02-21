Return-Path: <linux-kernel-owner+w=401wt.eu-S1423217AbXBUWqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423217AbXBUWqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423220AbXBUWqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:46:34 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:37251 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423217AbXBUWqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:46:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QCH9BExxCNEjCBLYyKbuAGWuyoJrJHXEd+1y7Miemkeu+3q0KI9sDkDvJ2Cog+H6EPBFW3nXHqlPuEf2u1JPj5XEQUxl7Kbjcrj7OuuOF1ff0XmagMlVyVDlU1FX5XE2QdesYRh5svR9j7tW/Ywf3HPLhDVgzrdm5/GJLgzyhI4=
Message-ID: <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
Date: Wed, 21 Feb 2007 14:46:32 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070221211355.GA7302@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Ingo Molnar <mingo@elte.hu> wrote:
> I believe this threadlet concept is what user-space will want to use for
> programmable parallelism.

This is brilliant.  Now it needs just four more things:

1) Documentation of what you can and can't do safely from a threadlet,
given that it runs in an unknown thread context;

2) Facilities for manipulating pools of threadlets, so you can
throttle their concurrency, reprioritize them, and cancel them in
bulk, disposing safely of any dynamically allocated memory,
synchronization primitives, and so forth that they may be holding;

3) Reworked threadlet scheduling to allow tens of thousands of blocked
threadlets to be dispatched efficiently in a controlled, throttled,
non-cache-and-MMU-thrashing manner, immediately following the softirq
that unblocks the I/O they're waiting on; and

4) AIO vsyscalls whose semantics resemble those of IEEE 754 floating
point operations, with a clear distinction between a) pipeline state
vs. operands, b) results vs. side effects, and c) coding errors vs.
not-a-number results vs. exceptions that cost you a pipeline flush and
nonlocal branch.

When these four problems are solved (and possibly one or two more that
I'm not thinking of), you will have caught up with the state of the
art in massively parallel event-driven cooperative multitasking
frameworks.  This would be a really, really good thing for Linux and
its users.

Cheers,
- Michael
