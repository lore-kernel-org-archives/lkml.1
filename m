Return-Path: <linux-kernel-owner+w=401wt.eu-S933928AbYEUA5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928AbYEUA5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932922AbYEUA5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:57:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305AbYEUA5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:57:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] signals: collect_signal: remove the unneeded sigismember() check
In-Reply-To: Oleg Nesterov's message of  Saturday, 17 May 2008 19:14:24 +0400 <20080517151424.GA9505@tv-sign.ru>
References: <20080517151424.GA9505@tv-sign.ru>
X-Shopping-List: (1) Impetuous congestion
   (2) Precarious interlocking vagrant losers
   (3) Surreptitious reinforcement commissions
   (4) Pink ambition hiders
   (5) Stoic vapor
Message-Id: <20080521005646.1BD5426FA1C@magilla.localdomain>
Date: Tue, 20 May 2008 17:56:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> collect_signal() checks sigismember(&list->signal, sig), this is not needed.
> This "sig" was just found by next_signal(), so it must be valid.

Acked-by: Roland McGrath <roland@redhat.com>

> We have a (completely broken) call to ->notifier in between, but it must not
> play with sigpending->signal bits or unlock ->siglock.

The only use of ->notifier/notifier_mask is for block_all_signals.
Its only user in the tree is drm_lock(), but it is exported too.

drm_lock is using block_all_signals to catch all the stop signals
for a purpose that is not immediately clear to me.  


Thanks,
Roland
