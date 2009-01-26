Return-Path: <linux-kernel-owner+w=401wt.eu-S1752418AbZAZN4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbZAZN4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZAZN4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:56:09 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:35778 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZAZN4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:56:08 -0500
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jan 2009 08:56:07 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WBpoeKk1/Nyx4e552YaFREPTVKsRm08ypMzpG9OQxdwbbGOgbdJsdwD2gCdDD15DZX
         DNg5OAhXLxiHe1oErcRg5zHdkH0ITT6976TQaEGOy/6WWdJfRd0tOPdDlT7DUEqh2v7v
         FcnNV/p1BVqcHtlkhV20kv1cNSEidZI6jXV5k=
MIME-Version: 1.0
In-Reply-To: <1232725219.4826.131.camel@laptop>
References: <2cd4df870901221334n7e242e79ka961f899c03c70cb@mail.gmail.com>
	 <1232725219.4826.131.camel@laptop>
Date: Mon, 26 Jan 2009 14:48:53 +0100
Message-ID: <2cd4df870901260548s2376a01anae0db9707dcfa14@mail.gmail.com>
Subject: Re: CPU scheduler question/problem
From: Pawel Dziekonski <dzieko@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/23 Peter Zijlstra <peterz@infradead.org>:

> The pipe workload you mentioned has would behave that way because pipes
> 'assume' a produces/consumer behaviour, and thus are more likely to
> place both tasks on the same cpu -- but will eventually pull them apart
> if they want to run concurrently.
>
> You might enable SCHED_DEBUG=y and try
>  echo NO_SYNC_WAKEUPS > /debug/sched_features

Hello,

that did the trick. Openssl now gets a whole core exclusively and gives full
performance.

Regarding quantum chemistry application -- it is also using pipes
for communication between worker processes. Now this app works OK.

Where I can read more on tuning sched_features for different workloads?

Also, is there a way get a list of available schedulers and how to switch
between them?

thanks, Pawel
