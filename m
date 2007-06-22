Return-Path: <linux-kernel-owner+w=401wt.eu-S1759144AbXFVQ4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144AbXFVQ4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbXFVQ4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:56:15 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:53136 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbXFVQ4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:56:12 -0400
Subject: Re: [RFC PATCH 4/6] Make DRM use the tasklet is-sched API
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Daniel Walker <dwalker@mvista.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
In-Reply-To: <200706221810.56298.arnd@arndb.de>
References: <20070622040014.234651401@goodmis.org>
	 <1182494169.3228.11.camel@dhcp193.mvista.com>
	 <1182494960.20203.34.camel@chaos>  <200706221810.56298.arnd@arndb.de>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 12:56:06 -0400
Message-Id: <1182531366.5493.83.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 18:10 +0200, Arnd Bergmann wrote:

> Wouldn't the easy solution be to get rid of drm_locked_tasklet
> entirely and convert i915_vblank_tasklet(), the only user, to use
> a work queue right away?

You recommend making the i915 use a workqueue to do this instead, and
remove the drm_lock_tasklet code from the drm_irq.c completely?

Unfortunately, I don't have any boxes with a i915, so I would not feel
comfortable with doing this myself.

> 
> The drm_locked_tasklet() function seems to have multiple bugs anyway,
> so getting rid of it can only help, and it avoids exporting a new
> tasklet_is_scheduled() interface.

To be able to at least continue my work, I'll just keep these as
separate patches.

Thanks,

-- Steve


