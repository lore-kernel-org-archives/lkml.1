Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYG3WW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYG3WW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYG3WWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:22:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:22097 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYG3WWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=LbEO+6MJTEAww9/BpIbnJplTsupaptnZfqM5eb7s2MU8YONaM5Pqk+tYmjiMT6QDTB
         w6TkQx8kvyHvSBGcJdT4SkZw1a8z9xOCS+WDrXZ/whFrB/HZAicHIpFSB9+5cIioXoky
         h5Z0RGkntvpmDNIO2ZN5D8NFJxSrdGHWvQJQo=
Message-ID: <84144f020807301522r7fb97bfehe0fcdceef10477b9@mail.gmail.com>
Date: Thu, 31 Jul 2008 01:22:17 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
Cc: "Matt Mackall" <mpm@selenic.com>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Hugh Dickins" <hugh@veritas.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       vegard.nossum@gmail.com, hannes@saeurebad.de
In-Reply-To: <alpine.LFD.1.10.0807301457020.3277@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>
	 <1199906151.6245.57.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
	 <1199919548.6245.74.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>
	 <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0807310045020.22702@sbz-30.cs.Helsinki.FI>
	 <alpine.LFD.1.10.0807301457020.3277@nehalem.linux-foundation.org>
X-Google-Sender-Auth: 5bac12e3bbce91e7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Jul 31, 2008 at 1:00 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I'm happy to hear that the thing worked, but I'm not sure how happy I
> should be about yet _another_ allocator. Will it ever end?

Oh, I didn't suggest this for merging. Just thought you'd be
interested to know that best-fit doesn't really do that much better
than what we have in the tree now. (Well, I was kinda hoping you'd
tell me why my implementation is wrong and you were right all along.)

On Thu, Jul 31, 2008 at 1:00 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> But seriously, it looks simple and small enough, so in that sense there
> doesn't seem to be a problem. But I really don't look forward to another
> one of these, at least not without somebody deciding that yes, we can
> prune one of the old ones as never being better. Hmm?

I think the current situation is bit unfortunate. SLOB doesn't want
cater for everybody (and probably can't do that either), SLAB sucks
for NUMA and embedded, and SLUB is too much of a "memory pig"
(although much less so than SLAB) to replace SLOB and it has that TPC
regression we don't have a test case for.

So while SLAB is (slowly) on it's way out, we really don't have a
strategy for SLOB/SLUB. I'm trying to come up with something that's
memory efficient first and then try to tune that for SMP and NUMA.
Looking at how tuned the fast-paths of SLAB and SLUB are (due to the
design), it seems unlikely that we can come up with anything that
could compete with them. But that doesn't mean we can't have fun
trying ;-).

                             Pekka
