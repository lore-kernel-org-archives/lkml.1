Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbYHMSpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbYHMSpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYHMSpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:45:35 -0400
Received: from il.qumranet.com ([212.179.150.194]:38722 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbYHMSpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:45:34 -0400
Message-ID: <48A32BCF.40300@qumranet.com>
Date: Wed, 13 Aug 2008 21:45:35 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: Efficient x86 and x86_64 NOP microbenchmarks
References: <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com> <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> <87tzdv2g05.fsf@basil.nowhere.org> <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <489CE90D.1040902@goop.org> <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org> <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com> <20080813175213.GA8679@Krystal> <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org>
In-Reply-To: <20080813184142.GM1366@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> So for me the best strategy would be to get rid of the frame pointer
> and ignore the nops. This unfortunately would require going away
> from -pg and instead post process gcc output to insert "call mcount"
> manually. But the nice advantage of that is that you could actually 
> set up a custom table of callers built in a ELF section and with
> that you don't actually need the runtime patching (which is only
> done currently because there's no global table of mcount calls),
> but could do everything in stop_machine(). Without
> runtime patching you also don't need single part nops. 
>
> I think that would be the best option. I especially like it because
> it would prevent forcing frame pointer which seems to be costlier
> than any kinds of nosp.
>
>   

How would you deal with inlines?  Using debug information?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

