Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbYIJEG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbYIJEG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 00:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbYIJEGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 00:06:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40464 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbYIJEGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 00:06:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Frank Mayhar <fmayhar@google.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.27-rc5] Fix itimer/many thread hang.
In-Reply-To: Oleg Nesterov's message of  Tuesday, 9 September 2008 20:01:52 +0400 <20080909160152.GA714@tv-sign.ru>
References: <1220906643.31846.21.camel@bobble.smo.corp.google.com>
	<20080909070329.GD2086@elte.hu>
	<20080909160152.GA714@tv-sign.ru>
X-Shopping-List: (1) Luminescent honey scenarios
   (2) Abrupt perspiration rectractors
   (3) Chimerical suspicion excitements
   (4) Muscular perilous capture detergents
Message-Id: <20080910040404.245301541FE@magilla.localdomain>
Date: Tue,  9 Sep 2008 21:04:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As for this particular function, it seems to me that ->signal == NULL
> is not possible, no?

The concern is to make sure that the timer tick path is always safe for a
tick that hits during release_task(current) in exit_notify().  A timer tick
there can come with current->signal == NULL.  We just need to make sure one
way or another that this is safe.


Thanks,
Roland
