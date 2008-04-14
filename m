Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbYDNORv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbYDNORv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759990AbYDNORd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:17:33 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3470 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759272AbYDNORc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:17:32 -0400
Subject: Re: Does process need to have a kernel-side stack all the time?
From: "Denis V. Lunev" <den@openvz.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <200804141547.57719.vda.linux@googlemail.com>
References: <200804141547.57719.vda.linux@googlemail.com>
Content-Type: text/plain
Organization: OpenVz kernel team
Date: Mon, 14 Apr 2008 18:17:29 +0400
Message-Id: <1208182649.7688.7.camel@iris.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-14 at 15:47 +0200, Denys Vlasenko wrote:
> Hi Ingo,
> 
> You are one of the experts in processes/threads and scheduling
> in Linux kernel, I hope you can answer this question.
> 
> A lot of effort went into minimizing of stack usage.
> If I understand it correctly, one of the reasons for this
> was to be efficient and not have lots of pages
> used for stacks when we have a lot of threads
> (tens of thousands).
> 
> A random thought occurred to me: in a system with so many
> threads most of them are not executing anyway, even on
> that gigantic Altix machines. Do they all need to have
> kernel stack, all the time? I mean: the process which
> is running in user space is not using kernel stack at all.
> Process which is not running on a CPU right now
> is not using it either. But they do still consume
> at least 4k (or 8k on 64bits) of RAM.
> 
> Process absolutely must have kernel stack only when
> it is actively running in kernel code (not sleeping),
> right?
> 
> Can we have per-CPU kernel stacks instead, so that process
> gets a kernel stack only every time it enters the kernel;
> and make it so that the process which is scheduled away
> from a CPU does not need to have kernel stack?
> 
> Currently, when process sleeps, we save some
> state in stack, and such a change may require
> some substantial surgery.
> 
> Can you tell me whether this is possible at all,
> and how difficult you estimate it to be?

I do not think that this can help. Usually, the process (thread) invokes
some syscall like sleep and goes to the waiting state _from the kernel_,
i.e. the kernel stack is used at that moment and will be required during
wake up.

Regards,
	Den

