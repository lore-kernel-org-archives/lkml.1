Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbZBKJRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbZBKJRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 04:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbZBKJQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 04:16:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:41978 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbZBKJQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 04:16:42 -0500
Message-ID: <49929763.3080608@kernel.org>
Date: Wed, 11 Feb 2009 18:16:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: git pull request for tip/tracing/urgent
References: <alpine.DEB.1.10.0902101314440.23505@gandalf.stny.rr.com> <20090210183046.GA1342@nowhere> <alpine.DEB.1.10.0902101724190.23505@gandalf.stny.rr.com> <20090211012856.GA4921@nowhere> <20090211090229.GG21105@elte.hu>
In-Reply-To: <20090211090229.GG21105@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Feb 2009 09:16:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ingo Molnar wrote:
> This bit:
> 
>   	".section .fixup, \"ax\"\n"
>  	"4: movl $1, %[faulted]\n"
>  	"   jmp 3b\n"
>  	".previous\n"
> 
> Can be thought of as an 'embedded' or 'nested' section - the '.previous'
> directive jumps back to whatever section we were in before. This can be
> nested multiple times too:
> 
>    .section A
>    [...]
>      .section B
>      [...]
>         .section C
>         [...]
>         .previous
>      [...]
>      .previous
>    [...]
>    .previous

That will result in...

 A->B->C->B->C->B

.pushsection and .popsection should be used for nesting, right?

Thanks.

-- 
tejun
