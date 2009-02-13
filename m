Return-Path: <linux-kernel-owner+w=401wt.eu-S1761411AbZBMQgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761411AbZBMQgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZBMQga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:36:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33720 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759398AbZBMQg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:36:29 -0500
Subject: Re: irq-disabled vs vmap vs text_poke
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Nick Piggin <npiggin@suse.de>, akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4995A0B7.1030705@redhat.com>
References: <1234529407.6519.28.camel@twins>
	 <20090213141839.GA31922@Krystal>  <4995A0B7.1030705@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Feb 2009 17:38:21 +0100
Message-Id: <1234543101.6519.147.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-13 at 11:32 -0500, Masami Hiramatsu wrote:

> >> Anybody got an idea on how to fix this?
> > 
> > There is probably something wrong with the caller, kprobes, which calls
> > text_poke with interrupts off.
> 
> Hmm, kprobe's smoke test caused this problem. Since (un)register_kprobe()
> may sleep for waiting a mutex, it should not be called with interrupts off.
> So, it's not text_poke()'s issue nor vmap().

Yeah, since noticed that, trying to figure out where the irq-disable
came from.. somewhat mysterious.
