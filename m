Return-Path: <linux-kernel-owner+w=401wt.eu-S934939AbXJRW5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934939AbXJRW5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759875AbXJRW5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:57:40 -0400
Received: from smtp-out.google.com ([216.239.45.13]:30227 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbXJRW5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:57:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ZIONJ/R1Ed1kbENJ2BmJQS0hau6TaFZneqY1EKHq47mdI4jiJsJVCXwFoX+ihz5o2
	ImhTIl/4XYAqCoF97D0Tw==
Message-ID: <b040c32a0710181557x4741b9ddxeb01edc788defb6@mail.gmail.com>
Date: Thu, 18 Oct 2007 15:57:35 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch] sched: schedstat needs a diet
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20071018221957.GA31609@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b040c32a0710161337l24d61d45h61be0ded72b54a9f@mail.gmail.com>
	 <20071017072323.GB18044@elte.hu> <1192613387.27435.114.camel@twins>
	 <20071018221957.GA31609@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> Good question indeed. How large is this memory footprint exactly ? If it
> is as small as you say, I suspect that the real issue could be that
> these variable are accessed by the scheduler critical paths and
> therefore trash the caches.

Maybe my wording was ambiguous, I meant to reduce cache line pollution
when accessing these schedstat fields.

With unsigned long, on x86_64, schedstat consumes 288 bytes for each
sched_domain and 128 bytes in struct rq.  On a extremely small system
that has a couple of CPU sockets with one level of numa node, there
will be 704 bytes per CPU for schedstat.  Given the sparseness of
them, we are probably talking about 11-12 cache line eviction on
several heavily used scheduler functions.  Reduce cache line pollution
is the primary goal, actual memory consumption isn't really a concern.

- Ken
