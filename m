Return-Path: <linux-kernel-owner+w=401wt.eu-S1764794AbXJPJKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764794AbXJPJKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757367AbXJPJKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:10:18 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:55638
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523AbXJPJKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:10:16 -0400
Date: Tue, 16 Oct 2007 02:14:17 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jarek Poplawski <jarkao2@o2.pl>
cc: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
In-Reply-To: <20071016090005.GC1000@ff.dom.local>
Message-ID: <Pine.LNX.4.64.0710160205100.1538@asgard.lang.hm>
References: <20071012082534.GB1962@ff.dom.local>
 <alpine.LFD.0.999.0710120802160.6887@woody.linux-foundation.org>
 <20071015074405.GA1875@ff.dom.local> <20071015080924.GA32562@wotan.suse.de>
 <20071015090959.GB1875@ff.dom.local> <20071016005033.GB5851@wotan.suse.de>
 <20071016090005.GC1000@ff.dom.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Jarek Poplawski wrote:

> On Tue, Oct 16, 2007 at 02:50:33AM +0200, Nick Piggin wrote:
>> On Mon, Oct 15, 2007 at 11:10:00AM +0200, Jarek Poplawski wrote:
> ...
>
>>> As a matter of fact it's not natural for me at all. I expected the
>>> other direction, and I still doubt programmers' intentions could be
>>> "automatically" predicted good enough, so IMHO, it's not for long.
>>
>> Really? Consider the consequences if, instead of releasing this latest
>> document tightening consistency, Intel found that out of order loads
>> were worth 5% more performance and implemented them in their next chip.
>> The chip could be completely backwards compatible, but all your old code
>> would break, because it was broken to begin with (because it was outside
>> the spec).
>
> I've different opinion on this: I expect any spec to describe current
> implementation. Before issuing new models any changes of
> implementation should be made public with proper margin of time. Then
> system could be optimally adjusted to a real hardware, instead of
> planned only, but possibly never realized (plus doing such not used
> things with old means is usually more costly: lock vs. lfence). There
> is still problem of specs' completness: there are probably often some
> things unspecified which could brake on a new model, so never 100%
> guarantee anyway.

what you don't realize is that Intel (and AMD) have built their business 
on makeing sure that their new CPU's run existing software with no 
modifications, (and almost always faster then the old versions). remember 
that for most of the world, getting the software modified would mean 
buying a new version, if the vendor bothered to make a different version 
for the new chip.

if they required everyone to buy new software to use a new chip it 
wouldn't work well. In fact Intel tried to do exactly withat with the 
itanium and it has been a spectacular failure (or t the very least, not a 
spectacular sucess)

>> IMO Intel did exactly the right thing from an engineering perspective,
>> and so did Linux to always follow the spec.
>
> But, if you follow the spec - you don't follow the spec! Why do you
> ignore so much this part of Intel's spec:
>
> "This document contains information which Intel may change at any
>  time without notice. Do not finalize a design with this information."
>
> Maybe it's a real Intel intention and not for lawyers only? (Btw, it
> seems we have an example.)

in theory they could change anything at any time, in practice if they 
break old software they won't sell the chips, so the modifications tend to 
be along the lines of this one, adding detail to the specifications so 
that programmers can get more performance.

David Lang
