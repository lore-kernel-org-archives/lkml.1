Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZCBTOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZCBTOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 14:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZCBTOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 14:14:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbZCBTOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 14:14:35 -0500
Message-ID: <49AC2FDF.9070700@redhat.com>
Date: Mon, 02 Mar 2009 14:13:35 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC][PATCH] x86: make text_poke() atomic
References: <alpine.DEB.2.00.0902231125520.18221@gandalf.stny.rr.com>	<20090223173108.GB1441@Krystal>	<alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com>	<49A82851.5080707@redhat.com>	<20090227180724.GA17947@Krystal>	<49A83237.40604@redhat.com>	<20090227185316.GA19811@Krystal>	<49A853CD.3020607@redhat.com>	<49AC10E9.1090102@redhat.com>	<20090302102841.7e099670@infradead.org>	<20090302183617.GA25105@Krystal> <20090302105500.569e1270@infradead.org>
In-Reply-To: <20090302105500.569e1270@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 2 Mar 2009 13:36:17 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
>> * Arjan van de Ven (arjan@infradead.org) wrote:
>>>> Use map_vm_area() instead of vmap() in text_poke() for avoiding
>>>> page allocation and delayed unmapping, and call
>>>> vunmap_page_range() and local_flush_tlb() directly because this
>>>> mapping is temporary and local.
>>>>
>>>> At the result of above change, text_poke() becomes atomic and can
>>>> be called from stop_machine() etc.
>>> .... but text_poke() realistically needs to call stop_machine()
>>> since you can't poke live code.... so that makes me wonder how
>>> useful this is...
>> Hi Arjan,
>>
>> Stop machine is not required when inserting a breakpoint. 
> 
> that is your assumption; when I spoke with CPU architects they
> cringed ;(

Is that true even if modifying just one-byte (like int3 insertion)
and we don't care synchronous write(that means code modification
effects on other processors after a while)?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

