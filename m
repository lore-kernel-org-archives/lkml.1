Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbXI1PQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbXI1PQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 11:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbXI1PQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 11:16:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbXI1PQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:16:29 -0400
Date: Fri, 28 Sep 2007 11:15:46 -0400
From: Rik van Riel <riel@redhat.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Daniel =?UTF-8?B?U3DDpW5n?= <daniel.spang@gmail.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: Out of memory management in embedded systems
Message-ID: <20070928111546.0c290e57@bree.surriel.com>
In-Reply-To: <20070928163634.d7fc8909.dada1@cosmosbay.com>
References: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com>
	<Pine.LNX.4.61.0709280857520.8940@chaos.analogic.com>
	<cfd9edbf0709280630x7396e49fi523e1d58aab9458a@mail.gmail.com>
	<Pine.LNX.4.61.0709281000300.9062@chaos.analogic.com>
	<20070928101711.504eb198@bree.surriel.com>
	<20070928163634.d7fc8909.dada1@cosmosbay.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 16:36:34 +0200
Eric Dumazet <dada1@cosmosbay.com> wrote:

> On Fri, 28 Sep 2007 10:17:11 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
> > On Fri, 28 Sep 2007 10:04:23 -0400
> > "linux-os \(Dick Johnson\)" <linux-os@analogic.com> wrote:
> > > On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:
> > > 
> > > > On 9/28/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> > > >>
> > > >> On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:
> > 
> > > >>> Some kind of notification to the application that the available memory
> > > >>> is scarce and let the application free up some memory (e.g., by
> > > >>> flushing caches), could be used to improve the situation 
> > 
> > > Any networked appliance can (will) throw data away if there are
> > > no resources available.
> > 
> > That is exactly what Daniel proposed in his first email.
> > 
> > I think his idea makes sense.
> 
> IBM AIX uses SIGDANGER, that kernel can raise in OOM conditions to warn
> processes that are willing to handle this signal (default action for the
>  SIGDANGER signal is to ignore the signal)

I suspect that SIGDANGER is not the right approach, because glibc
memory arenas cannot be manipulated from inside a signal handler.

Also, "nearly OOM" is not the only such signal we would want to
send to userspace programs. It would also be useful to inform
userspace programs when we are about to start swapping something
out, so userspace can discard cached data instead of having to
wait for disk IO in the future.

A unix signal cannot encapsulate two different messages, while
something like a "/dev/lowmem" device can simply be added into
the program's main poll() loop and give many different messages.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
