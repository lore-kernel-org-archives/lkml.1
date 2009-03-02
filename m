Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbZCBXii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbZCBXii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZCBXia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:38:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39162 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbZCBXi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:38:29 -0500
Message-ID: <49AC6DEA.2050304@redhat.com>
Date: Mon, 02 Mar 2009 18:38:18 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC][PATCH] x86: make text_poke() atomic
References: <49A82851.5080707@redhat.com> <20090227180724.GA17947@Krystal> <49A83237.40604@redhat.com> <20090227185316.GA19811@Krystal> <49A853CD.3020607@redhat.com> <49AC10E9.1090102@redhat.com> <20090302171914.GB21735@Krystal> <49AC5A87.7000604@redhat.com> <20090302222254.GA31962@elte.hu> <49AC63FA.70801@redhat.com> <20090302230915.GA11626@elte.hu>
In-Reply-To: <20090302230915.GA11626@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>> So perhaps another approach to (re-)consider would be to go back 
>>> to atomic fixmaps here. It spends 3 slots but that's no big 
>>> deal.
>> Oh, it's a good idea! fixmaps must make it simpler.
>>
>>> In exchange it will be conceptually simpler, and will also scale 
>>> much better than a global spinlock. What do you think?
>> I think even if I use fixmaps, we have to use a spinlock to protect
>> the fixmap area from other threads...
> 
> that's why i suggested to use an atomic-kmap, not a fixmap.

Even if the mapping is atomic, text_poke() has to protect pte
from other text_poke()s while changing code.
AFAIK, atomic-kmap itself doesn't ensure that, does it?

Thank you,

> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

