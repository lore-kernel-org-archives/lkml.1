Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657AbYHKGK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657AbYHKGK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 02:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbYHKGKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 02:10:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:44106 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYHKGKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 02:10:19 -0400
Subject: Re: [PATCH -v2 6/8] kexec jump: fix for lockdep
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <1218416396.30464.9.camel@caritas-dev.intel.com>
References: <1218178365.22039.79.camel@caritas-dev.intel.com>
	 <1218190426.8625.71.camel@twins>
	 <1218416396.30464.9.camel@caritas-dev.intel.com>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 08:09:54 +0200
Message-Id: <1218434994.10800.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-11 at 08:59 +0800, Huang Ying wrote:
> On Fri, 2008-08-08 at 12:13 +0200, Peter Zijlstra wrote:
> > On Fri, 2008-08-08 at 14:52 +0800, Huang Ying wrote:
> > > Replace local_irq_disable() with raw_local_irq_disable() to prevent
> > > lockdep complain.
> > Uhhm, please provide more information - just using raw_* to silence
> > lockdep is generally the wrong thing to do.
> 
> In traditional kexec, the new kernel will replace current one, so the
> irq is simply disabled. But now jumping back from kexeced kernel is
> supported, so the irq should be enabled again.
> 
> The code sequence of irq during kexec jump is as follow:
> 
> local_irq_disable(); /* in kernel_kexec() */
> local_irq_disable(); /* in machine_kexec() */
> local_irq_enable(); /* in kernel_kexec() */
> 
> The disable and enable is not match. Maybe another method is to use
> local_irq_save(), local_irq_restore() pair in machine_kexec(), so the
> disable and enable is matched.

And its the machine kernel's lockdep instance that goes complain?

whichever annotation gets used - and I think I can agree that raw_*
might be approriate there, this should be accompanied with a rather
elaborate changelog and preferably a comment in the code too. Without
such we'll be wondering in the years to come WTH happens here.


