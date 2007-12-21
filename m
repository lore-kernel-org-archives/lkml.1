Return-Path: <linux-kernel-owner+w=401wt.eu-S1761224AbXLUNWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761224AbXLUNWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 08:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbXLUNWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 08:22:05 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:53814 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbXLUNWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:22:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAARNa0dMROHU/2dsb2JhbACBV6dz
Date: Fri, 21 Dec 2007 08:16:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 14/24] Immediate Values - x86 Optimization (updated)
Message-ID: <20071221131655.GA30372@Krystal>
References: <20071221015438.433195466@polymtl.ca> <20071221015726.909058404@polymtl.ca> <476B2B5E.5060204@zytor.com> <20071221031900.GA2414@Krystal> <476B335C.5080905@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <476B335C.5080905@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:00:15 up 47 days, 18:05,  3 users,  load average: 5.10, 1.96,
	1.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> Argh.. Rusty asked to have a simplified version first, and then to
>> implement the "more complex" one on top of it. However, in order to get
>> the reentrancy I need for the markers, I need the complex version of the
>> immediate values. Therefore, you find, in this patchset, the simple
>> version first, and then, the more complex one implemented on top.
>> About this patch header, the initial idea was to use the "Q" and "R"
>> constraints, but, as stated just below, the "q" and "r" constraints are
>> used instead to make sure the REX prefixed opcodes for 1, 2, and 4 bytes
>> immediate values are never used. So the complete header follows the
>> source code, it's just that this paragraph could be clearer.
>
> Then you have it backwards.  "Q" and "R" avoid REX prefixes, "q" and "r" DO 
> NOT.
>
> 	-hpa

Right.. I did that 1 month ago, which is already far away in my memory.
Looking back at this, here is what is the real situation. I attach the
patches that fixes the comments accordingly as reply to my original
posts.

- "Redux" immediate values : no need to put a breakpoint, therefore, no
  need to know where the instruction starts. It's therefore OK to have a
  REX prefix.
- More reentrant immediate value : uses a breakpoint. Needs to know the
  instruction's first byte. This is why we keep the "instruction size"
  variable, so we can support the REX prefixed instructions too.

Therefore, the "q" and "r" constraints are OK : they _allow_ REX
prefixes.

Mathieu




-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
