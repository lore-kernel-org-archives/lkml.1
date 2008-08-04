Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbYHDC5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbYHDC5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYHDC5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:57:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbYHDC5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:57:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mark McLoughlin <markmc@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] posix-timers: don't switch to ->group_leader if ->it_process dies
In-Reply-To: Oleg Nesterov's message of  Sunday, 3 August 2008 21:49:10 +0400 <20080803174910.GA4913@tv-sign.ru>
References: <20080803174910.GA4913@tv-sign.ru>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080804025633.A4620154217@magilla.localdomain>
Date: Sun,  3 Aug 2008 19:56:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The key thing that the old code does it to drop the ref to the old task as
soon as it notices.  It may be worthwhile to do that in the case where
send_sigqueue fails.  I realize it's already not perfect, since it will
keep the old ref around for a long time if the timer does not fire soon.


Thanks,
Roland
