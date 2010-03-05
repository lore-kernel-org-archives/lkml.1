Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab0CEWZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 17:25:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:54073 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab0CEWZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 17:25:46 -0500
Subject: Re: [PATCH 3/5] perf, x86: Disable PEBS on clowertown chips
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <bd4cb8901003051357o357ac7adt7cb56b5deb4089dd@mail.gmail.com>
References: <20100305153926.639506880@chello.nl>
	 <20100305154128.890278662@chello.nl>
	 <bd4cb8901003051058k5c3d88bewa787f88f03d2da80@mail.gmail.com>
	 <1267816553.4942.6.camel@laptop> <1267823134.4997.5.camel@laptop>
	 <bd4cb8901003051322l1722fcaaqacf0c913853d384f@mail.gmail.com>
	 <1267824933.4997.9.camel@laptop>
	 <bd4cb8901003051338p1c12ceacv994bad73e81093a2@mail.gmail.com>
	 <1267825433.4997.14.camel@laptop>
	 <bd4cb8901003051357o357ac7adt7cb56b5deb4089dd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 23:25:43 +0100
Message-ID: <1267827943.4997.56.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 13:57 -0800, Stephane Eranian wrote:

> When I read AJ68, my understanding is that it's not that you do not
> get the interrupt. It will be delayed by one event. The buffer will become
> full. You won't overrun the buffer, you will get the interrupt at the next
> event. On interrupt, you have to reset the PEBS position pointer anyway.
> There is already a disconnect between the sampling period and the actual
> instruction sampled. That's not making the situation that much worse, unless
> I am missing something.

The current code doesn't use the buffering at all, it uses single-shot
PEBS by keeping pebs_event_reset 0 and setting a threshold of a single
entry, so if due to AJ68 we miss a PMI it will never come.

I guess we can fudge something, but at what point does the whole thing
stop being useful?

It would end up being something with fuzzy period and fuzzy location,
which is a loss-loss situation if you ask me.



