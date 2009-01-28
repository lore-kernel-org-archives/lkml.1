Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbZA1VLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbZA1VLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZA1VKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:10:53 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:51606 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbZA1VKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:10:52 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Jan 2009 13:10:43 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Chris Snook <csnook@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: if (unlikely(...)) == unnecessary?
In-Reply-To: <4980C278.8030204@redhat.com>
Message-ID: <alpine.DEB.1.10.0901281255440.21401@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901272346480.20262@alien.or.mcafeemobile.com> <49809C2E.3000005@redhat.com> <alpine.DEB.1.10.0901281130020.21401@alien.or.mcafeemobile.com> <4980C278.8030204@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Chris Snook wrote:

> When you turn on optimizations, gcc will try to avoid branching just to
> execute a few instructions, since the cache miss and page fault penalties
> greatly exceed the cost of a branch mispredict.  The thresholds and heuristics
> vary, but in general, if you stick something like this:
> 
> if (condition) foo++;
> else if (complex condition) {do lots of stuff}
> 
> In the middle of a long function body and compile with optimizations enabled,
> gcc will try to put the foo++ right after the evaluation.  Some ISAs support
> conditional instructions to let the compiler help fill pipeline bubbles, and
> some superscalar processors will speculatively execute it in parallel with
> their evaluation of the second condition, and proceed with whichever execution
> path is chosen when they retire the instruction evaluating the first
> conditional.

OK, been finally able to trigger a different behavior. I thought that 
became a somehow rule, after quite a few trials yesterday all leading to 
the same results.


- Davide


