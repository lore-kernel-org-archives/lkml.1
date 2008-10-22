Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbYJVJU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbYJVJU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYJVJUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:20:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38712 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbYJVJUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:20:49 -0400
Date: Wed, 22 Oct 2008 11:20:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Oren Laadan <orenl@cs.columbia.edu>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, hpa@zytor.com,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [RFC v7][PATCH 0/9] Kernel based checkpoint/restart
Message-ID: <20081022092024.GC12453@elte.hu>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu> <20081021122135.4bce362c.akpm@linux-foundation.org> <1224621667.1848.228.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224621667.1848.228.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Tue, 2008-10-21 at 12:21 -0700, Andrew Morton wrote:
> > On Mon, 20 Oct 2008 01:40:28 -0400
> > Oren Laadan <orenl@cs.columbia.edu> wrote:
> > > These patches implement basic checkpoint-restart [CR]. This version
> > > (v7) supports basic tasks with simple private memory, and open files
> > > (regular files and directories only).
> > 
> > - how useful is this code as it stands in real-world usage?
> 
> Right now, an application must be specifically written to use these 
> mew system calls.  It must be a single process and not share any 
> resources with other processes.  The only file descriptors that may be 
> open are simple files and may not include sockets or pipes.
> 
> What this means in practice is that it is useful for a simple app 
> doing computational work.

say a chemistry application doing calculations. Or a raytracer with a 
large job. Both can take many hours (days!) even on very fast machine 
and the restrictions on rebootability can hurt in such cases.

You should reach a minimal level of initial practical utility: say some 
helper tool that allows testers to checkpoint and restore a real PovRay 
session - without any modification to a stock distro PovRay.

	Ingo
