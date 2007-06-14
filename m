Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbXFNAD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbXFNAD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 20:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbXFNADT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 20:03:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbXFNADS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 20:03:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
	internal errnos
In-Reply-To: Benjamin Herrenschmidt's message of  Thursday, 14 June 2007 09:18:49 +1000 <1181776729.14818.350.camel@localhost.localdomain>
X-Zippy-Says: Yow!  Legally-imposed CULTURE-reduction is CABBAGE-BRAINED!
Message-Id: <20070614000243.1C5784D059F@magilla.localdomain>
Date: Wed, 13 Jun 2007 17:02:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> btw, another interesting grep is to see how tweak TIF_SIGPENDING by
> hand ... there's some scary bits in the tty code too...

All I see there are the calls just added recently by Oleg, which are
correct and necessary to fix a bug.  Wrapping it in something less magical
might be nice.  It is the right thing to do in any place that is
introducing an -ERESTART* error code without having just checked signal_pending.


Thanks,
Roland
