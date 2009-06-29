Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbZF2JMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbZF2JMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZF2JMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:12:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42505 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZF2JMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:12:31 -0400
To: Jiri Olsa <jolsa@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, davem@redhat.com, oleg@redhat.com,
       eric.dumazet@gmail.com
Subject: Re: [PATCH] net: fix race in the receive/select
From: Andi Kleen <andi@firstfloor.org>
References: <20090625122545.GA3625@jolsa.lab.eng.brq.redhat.com>
Date: Mon, 29 Jun 2009 11:12:33 +0200
In-Reply-To: <20090625122545.GA3625@jolsa.lab.eng.brq.redhat.com> (Jiri Olsa's message of "Thu, 25 Jun 2009 14:25:45 +0200")
Message-ID: <87eit3l7y6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> writes:

> Adding memory barrier to the __pollwait function paired with 
> receive callbacks.  The smp_mb__after_lock define is added, 
> since {read|write|spin}_lock() on x86 are full memory barriers.

I was wondering did you see that race actually happening in practice?
If yes on which system?

At least on x86 I can't see how it happens. mb() is only a compile
time barrier and the compiler doesn't optimize over indirect callbacks
like __pollwait() anyways.

It might be still needed on some weaker ordered architectures, but did you
actually see it there?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
