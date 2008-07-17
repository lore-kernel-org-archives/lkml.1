Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYGQWFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYGQWFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757604AbYGQWFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:05:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbYGQWFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:05:14 -0400
Message-ID: <487FC1B0.1090105@redhat.com>
Date: Thu, 17 Jul 2008 18:03:28 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
 (part1: use kprobe symbol_name/offset instead of address)
References: <487E78ED.30804@redhat.com> <1216249383.3358.69.camel@localhost.localdomain> <487E8CE4.70105@redhat.com> <1216259391.3358.85.camel@localhost.localdomain> <1216304290.5515.11.camel@localhost.localdomain> <1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain> <y0m7ibkjrcj.fsf@ton.toronto.redhat.com> <1216325546.5515.63.camel@localhost.localdomain> <20080717202634.GI18295@redhat.com> <1216328769.5515.78.camel@localhost.localdomain> <20080717213355.GJ18295@redhat.com>
In-Reply-To: <20080717213355.GJ18295@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Ch. Eigler wrote:
> Hi -
> 
> 
> On Thu, Jul 17, 2008 at 04:06:09PM -0500, James Bottomley wrote:
> 
>> [...]
>>> My point is that the proposed effort to identify a nearby function
>>> symbol to use as a base for each probe's symbol+offset calculation is
>>> wasted.
>> It's not exactly wasted ... the calculations have to be done anyway for
>> modules.
> 
> Not really - we just anchor off a different (per-module) reference
> symbol or address.  At the moment, we use the .text* section bases.
> 
> 
>>>> you've lost access to the symbols in the sections that start before _stext.  
>>> What's between _text and _stext appears to consist of kernel boot-time
>>> functions that are unmapped the time anything like systemtap could
>>> run.
>> Well, no, they're the head code.  It's actually used in CPU boot and
>> tear down, one of the things it's useful to probe, I think.
> 
> Fair enough - conceivably probing that stuff is useful, as is module
> initialization.  We don't try to do it yet (and indeed kprobes blocks
> it all).
> 
> In any case, the method of probe address calculation doesn't affect
> that issue.  We can calculate .init* addresses relative to any
> convenient reference in exactly the same way as non-.init addresses.
> 
> 
>>>> Assuming you meant _text (which is dangerous because it's a define
>>>> in the kernel linker script and could change).
>>> By "dangerous" do you only mean that it may require a one-liner
>>> catch-up patch in systemtap if the kernel linker scripts change?
>> Dangerous as in it's not necessarily part of the kernel linker scripts.
>> [...]
>> The point, really, is to remove some of the fragile dependencies between
>> systemtap and the kernel.
> 
> Yes, that is generally desirable - each case is usually a question of
> cost/benefit.  One significant requirement for us is to keep working
> with older kernels.

Hi Frank,

I know we'd better archive that requirement. However, if we lose support
from developers because we are too much focusing on that, we'll also
lose the future of systemtap itself. We have to see the cost/benefit
from the long-term of view.

Could we separate systemtap parser/elaborator and code generator
to support both of old and new kernels?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

