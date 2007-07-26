Return-Path: <linux-kernel-owner+w=401wt.eu-S936452AbXGZSmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936452AbXGZSmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964927AbXGZSlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:41:55 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34017 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964921AbXGZSly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:41:54 -0400
Subject: Re: [PATCH] make schedule_on_each_cpu() look like on_each_cpu()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070726182727.GA173@tv-sign.ru>
References: <1185448139.8197.78.camel@twins>
	 <20070726182727.GA173@tv-sign.ru>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 20:41:32 +0200
Message-Id: <1185475292.15205.17.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 22:27 +0400, Oleg Nesterov wrote:
> On 07/26, Peter Zijlstra wrote:
> >
> > -int schedule_on_each_cpu(work_func_t func)
> > +int schedule_on_each_cpu(void (*func)(void *info), void *info, int retry, int wait)

> Another off-topic question: shouldn't we kill the unused "retry"
> parameter of on_each_cpu() instead of mirroring it here?

I'm fine with doing so, but that will be a somewhat larger patch. If you
(and perhaps Andrew?) think that is preferable I'll prepare such a
patch.

> > +out:
> > +	for_each_possible_cpu(cpu) {
> > +		if (works[cpu])
> > +			kfree(works[cpu]);
> > +	}
> 
> Small nit, kfree(NULL) is OK.

Habbits die hard :-/


