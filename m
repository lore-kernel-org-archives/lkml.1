Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbZCCAav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbZCCAav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbZCCAam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:30:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57798 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbZCCAam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:30:42 -0500
Date: Tue, 3 Mar 2009 01:30:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mainline] menu: fix embedded menu snafu
Message-ID: <20090303003031.GC4147@elte.hu>
References: <20090302141406.13d5ef1f.randy.dunlap@oracle.com> <20090302161602.a4eea5d9.akpm@linux-foundation.org> <alpine.LFD.2.00.0903021619270.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0903021619270.3111@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 2 Mar 2009, Andrew Morton wrote:
> > 
> > This patch causes weird unintended breakage, methinks.
> 
> Damn, you're right. It looked obvious, so I already applied it, but I 
> clearly shouldn't have.
> 
> The whole "if EMBEDDED" thing is totally wrong, because those config 
> options  very much_do_ exist even when non-embedded, it's just that then 
> they always take their default valies.
> 
> Thanks for noticing.

probably also explains weird build breakages i've been getting 
since i updated to your latest:

  CC      kernel/futex.o
In file included from kernel/futex.c:61:
kernel/rtmutex_common.h: In function ‘task_has_pi_waiters’:
kernel/rtmutex_common.h:81: error: ‘struct task_struct’ has no 
member named ‘pi_waiters’
kernel/rtmutex_common.h: In function ‘task_top_pi_waiter’:
kernel/rtmutex_common.h:87: error: ‘struct task_struct’ has no 
member named ‘pi_waiters’
make[1]: *** [kernel/futex.o] Error 1

	Ingo
