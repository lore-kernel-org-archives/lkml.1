Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbXEMVZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbXEMVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbXEMVZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:25:51 -0400
Received: from mail.screens.ru ([213.234.233.54]:42527 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbXEMVZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:25:51 -0400
Date: Mon, 14 May 2007 01:25:48 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070513212548.GA3185@tv-sign.ru>
References: <20070503204226.GA212@tv-sign.ru> <464475EB.3000408@gmail.com> <20070511134714.GA191@tv-sign.ru> <46448965.7070500@gmail.com> <20070511145345.GA240@tv-sign.ru> <4645559D.4050602@gmail.com> <20070513192753.GA3014@tv-sign.ru> <46477239.9030007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46477239.9030007@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Sorry, I can't give a "complete" reply today (will do tomorrow),
just one note right now...

On 05/13, Tejun Heo wrote:
> 
> Oleg Nesterov wrote:
> >> * try_to_grab_pending() checks VALID && pointers equal after grabbing
> >> cwq->lock.
> > 
> > We don't even need to check the pointers. VALID bit is always changed
> > under cwq->lock. So, if we see VALID under cwq->lock, we have a right
> > pointer.
> 
> But there are multiple cwq->lock's.  VALID can be set with one of other
> cwq->lock's locked.

Oops. Thanks for correcting me. _This_ was a reson for a stupid barrier!

Oleg.

