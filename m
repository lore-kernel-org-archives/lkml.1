Return-Path: <linux-kernel-owner+w=401wt.eu-S932872AbZKXUTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872AbZKXUTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbZKXUTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:19:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34666
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932471AbZKXUTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:19:42 -0500
Date: Tue, 24 Nov 2009 12:19:59 -0800 (PST)
Message-Id: <20091124.121959.35689494.davem@davemloft.net>
To: npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [rfc] "fair" rw spinlocks
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091123145409.GA29627@wotan.suse.de>
References: <20091123145409.GA29627@wotan.suse.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Mon, 23 Nov 2009 15:54:09 +0100

> This was basically reproduced by several cores executing wait
> with WNOHANG.
> 
> Of course it would always be nice to improve locking so
> contention isn't an issue, but so long as we have rwlocks, we
> could possibly get into a situation where starvation is
> triggered *somehow*. So I'd really like to fix this.
> 
> This particular starvation on tasklist lock I guess is a local
> DoS vulnerability even if the workload is not particularly
> realistic.
> 
> Anyway, I don't have a patch yet. I'm sure it can be done
> without extra atomics in fastpaths. Comments?

I think nobody would notice if you changed tasklist_lock into
a spinlock_t, and this would solve the DoS because at least on
x86 you'd end up with the ticket spinlocks.

And this is a repeating theme every time the topic of rwlocks come up.
All uses should just simply be converted gradually to some other
locking mechanism over time, the cases causing problems taking
priority.
