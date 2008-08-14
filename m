Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYHNX11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYHNX11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 19:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYHNX1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 19:27:17 -0400
Received: from ozlabs.org ([203.10.76.45]:45432 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbYHNX1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 19:27:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 3/6] ftrace: enable mcount recording for modules
Date: Fri, 15 Aug 2008 09:26:07 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, Bruce Duncan <bwduncan@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
References: <20080814194506.233473381@goodmis.org> <20080814194859.811269740@goodmis.org>
In-Reply-To: <20080814194859.811269740@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808150926.08200.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 August 2008 05:45:09 Steven Rostedt wrote:
> This patch enables the loading of the __mcount_section of modules and
> changing all the callers of mcount into nops.
...
> +	if (mcountindex) {
> +		void *mseg = (void *)sechdrs[mcountindex].sh_addr;
> +		ftrace_init_module(mseg, mseg + sechdrs[mcountindex].sh_size);

You don't actually need the if.  The size of section 0 is 0.

Rusty.
