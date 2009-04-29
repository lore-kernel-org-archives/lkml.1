Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbZD2UQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbZD2UQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZD2UQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:16:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59150 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbZD2UQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:16:10 -0400
Date: Wed, 29 Apr 2009 22:15:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/5] ring-buffer: fix printk output
Message-ID: <20090429201555.GG17021@elte.hu>
References: <20090429044814.138790038@goodmis.org> <20090429045908.394874083@goodmis.org> <20090428222024.8db50539.akpm@linux-foundation.org> <20090429054359.GA6148@elte.hu> <20090428225541.9ca61a12.akpm@linux-foundation.org> <20090429060955.GD6148@elte.hu> <20090428232000.6c3d4ce1.akpm@linux-foundation.org> <25555.1241021943@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25555.1241021943@turing-police.cc.vt.edu>
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


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Tue, 28 Apr 2009 23:20:00 PDT, Andrew Morton said:
> > printk_once() is racy on smp and preempt btw ;)
> 
> Looks like at worst, it's prone to the usual printk racing, plus a 
> possible misfire causing it to print twice before shutting up?  Or 
> is there something I'm missing here?

Yeah, that's the worst-case scenario.

Still worth improving if we can do it without bloating the code or 
data.

[ If not, we can just assume the kernel is perfect and ignore all
  the printk_once() and WARN_ONCE() / WARN_ON_ONCE() callsites as
  obviously dead code ;-) ]

	Ingo
