Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbZFZW3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbZFZW3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZFZW3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:29:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55347 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbZFZW3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:29:15 -0400
Date: Fri, 26 Jun 2009 21:14:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>
Subject: [PATCH 0/2] do_coredump: misc cleanups
Message-ID: <20090626191418.GA22603@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626180222.GD7337@hmsreliant.think-freely.org> <20090626165908.GB12063@redhat.com> <20090626202411.GH7337@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626202411.GH7337@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Neil Horman wrote:
>
> On Fri, Jun 26, 2009 at 06:59:08PM +0200, Oleg Nesterov wrote:
> >
> > Doesn't look good, if core_pattern starts with "|" any user can set
> > RLIMIT_CORE = 0 and then just do
> >
> > 	for (;;)
> > 		if (pid = fork())
> > 			kill(pid, SIGQUIT);
> >
> > to DOS printk/syslog, no?
> >
> I don't think SIGQUIT will trigger this, but SIGSEGV will.

SIGQUIT falls into SIG_KERNEL_COREDUMP_MASK too.

> Regardless, if you
> do that, I would think you have bigger problems on your system.

OK, agreed.


Neil, I think you are doing useful changes, but can't we cleanup
do_coredump() first?

I just can't look at unnecessary "if (ispipe)" checks...

Oleg.

