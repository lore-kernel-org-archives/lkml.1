Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0CNP23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 11:28:29 -0400
Received: from cpe-74-67-89-75.stny.res.rr.com ([74.67.89.75]:48013 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751268Ab0CNP2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 11:28:25 -0400
Subject: Re: [PATCH 5/5] tracing: Do not record user stack trace from NMI
 context
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       stable@kernel.org
In-Reply-To: <20100314102747.GB5140@nowhere>
References: <20100313025655.104950166@goodmis.org>
	 <20100313025855.495916344@goodmis.org>  <20100314102747.GB5140@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 14 Mar 2010 11:28:03 -0400
Message-ID: <1268580483.3366.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-14 at 11:27 +0100, Frederic Weisbecker wrote:

> 
> Wow, that's a race :)
> 
> In perf this is dealt with a special copy_from_user_nmi()
> (see in arch/x86/kernel/cpu/perf_event.c)
> 
> May be save_stack_trace_user() should use that instead
> of a __copy_from_user_inatomic() based thing, just to
> cover such NMI corner race case.
> 

Yeah, we should move the __copy_from_user_nmi() out of the perf code and
into the normal uaccess code. Then we could do as you suggest, and have
the stack code do:

if (in_nmi())
	__copy_from_user_nmi();
else
	__copy_from_user_inatomic();

Or maybe it would be best to have the __copy_from_user_inatomic() handle
it.

-- Steve

