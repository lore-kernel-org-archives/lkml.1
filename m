Return-Path: <linux-kernel-owner+w=401wt.eu-S1763686AbXESPZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763686AbXESPZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 11:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759073AbXESPZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 11:25:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758825AbXESPZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 11:25:08 -0400
Date: Sat, 19 May 2007 08:19:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Pratt <slpratt@austin.ibm.com>, Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 1/9] readahead: introduce PG_readahead
Message-Id: <20070519081944.3caf4776.akpm@linux-foundation.org>
In-Reply-To: <20070519113501.GB25563@one.firstfloor.org>
References: <20070516224752.500812933@mail.ustc.edu.cn>
	<379355695.83536@ustc.edu.cn>
	<20070518232824.9917d794.akpm@linux-foundation.org>
	<20070519113501.GB25563@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007 13:35:01 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> > We have the advantage that if the kernel very occasionally gets the wrong
> > result for PageReadahead(page), nothing particularly bad will happen, so we
> > can do racy things.
>  
> On 64bit there is no particular shortage of page flags.

I think pretty much all of the upper 32 bits got used for ia64 fields,
but it's never been very clear how many were actually used or needed.

> If you ever do racy things please do them 32bit only.

hrm.  It *really* won't matter if we make one suboptimal readahead decision
every second day.  And there's value in having the same behaviour on all
architectures.

