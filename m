Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbXKDSwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbXKDSwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 13:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbXKDSwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 13:52:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151AbXKDSwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 13:52:42 -0500
To: Chris Snook <csnook@redhat.com>
Cc: Zurk Tech <zurktech@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Quad core CPU detected but shows as single core in 2.6.23.1
From: Andi Kleen <andi@firstfloor.org>
References: <2ed59cbb0711021231l55fe2df3l23f8da65bb7166f6@mail.gmail.com>
	<472D2119.8090102@redhat.com>
Date: Sun, 04 Nov 2007 19:52:40 +0100
In-Reply-To: <472D2119.8090102@redhat.com> (Chris Snook's message of "Sat\, 03 Nov 2007 21\:32\:09 -0400")
Message-ID: <p737ikx3ksn.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook <csnook@redhat.com> writes:

>> Marking TSC unstable due to TSCs unsynchronized
>
> This is probably wrong.  The TSC is on the northbridge on Barcelona
> chips, so every core on the die should be in sync.  Hypothetically you
> could have different speed northbridges in different sockets, but
> we've never tried very hard to support that case anyway.  We should
> probably be marking the TSC as stable on Barcelona chips.

It's a little more complicated. Stable clock is only guaranteed as long 
as the CPUs all run on the same clock crystal. That is true 
when they're all on the current motherboard. But at least for K8
there were several systems that consist of multiple motherboards
and HT cables inbetween them (like all the 8 socket systems).
On those the TSCs can drift too with Fam10h. I'm not aware
of any of those shipping yet, but since it's essentially 
the same platform as K8 they will appear sooner or later.

So far we lack a reliable way to detect this condition. If it could
be detected it would be possible to switch to TSC timing
for the single motherboard systems.

However after some bad experiences in the past I personally would only
do that after such a system demonstrates synchronized TSC for at least
a week under varying workloads.

>> xor: automatically using best checksumming function: generic_sse
>>    generic_sse:  7449.000 MB/sec
>> xor: using function: generic_sse (7449.000 MB/sec)
>
> We should probably also implement an SSE5 function to take advantage
> of the 128-bit SSE operations supported on newer processors.

SSE5 doesn't exist in Fam10h

In general the optimized x86 RAID functions are mostly quite suboptimal
on my testing and do not actually do what they promise (E.g. the cache
avoiding functions do not actually avoid the cache fully etc.) I had a
rewrite of them in C some time ago which was faster on most CPUs
except on Core2 for so far unknown reasons. Needs more work.

-Andi
