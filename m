Return-Path: <linux-kernel-owner+w=401wt.eu-S1763324AbYF0Uww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763324AbYF0Uww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762425AbYF0Uuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:50:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762341AbYF0Uuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:50:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [patch] make siginfo_t si_utime + si_sstime report times in USER_HZ, not HZ
In-Reply-To: Oleg Nesterov's message of  Wednesday, 25 June 2008 19:38:06 +0400 <20080625153806.GA499@tv-sign.ru>
References: <cfd18e0f0806250749od875635r9e533d9f834bd8c4@mail.gmail.com>
	<20080625153806.GA499@tv-sign.ru>
X-Shopping-List: (1) Ceramic rain surprises
   (2) Automated balls
   (3) Cancerous dice longitudes
   (4) Dark reverent citation contraptions
Message-Id: <20080627204954.3D2061540B0@magilla.localdomain>
Date: Wed, 25 Jun 2008 13:26:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That looks fine.  The si_utime and si_stime fields have never been
standardized and I don't really know of anything that's ever actually used
them.  I'm sure whatever it has meant for ages is fine for it to mean now,
and certainly today's clock_t is what matches what this code meant when it
was written.  It seems unlikely that cutime rather than utime was ever
desired here.  If anything, it should probably be the group-wide utime sum
rather than the thread's, but that is not so trivial to sample and there is
no reason to worry about changing it now.


Thanks,
Roland
