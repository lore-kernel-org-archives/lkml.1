Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbXFUUYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbXFUUYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbXFUUX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:23:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48638 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbXFUUX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:23:57 -0400
Date: Thu, 21 Jun 2007 22:23:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070621202314.GA32051@elte.hu>
References: <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org> <20070621195659.GA22303@elte.hu> <alpine.LFD.0.98.0706211304480.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706211304480.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 21 Jun 2007, Ingo Molnar wrote:
> > 
> > I can understand why no data is saved by this change: gcc is 
> > aligning the next field to a natural boundary anyway and we dont 
> > really have arrays of spinlocks (fortunately).
> 
> Actually, some data structures could well shrink.
> 
> Look at "struct task_struct", for example. Right now it has two 
> spinlocks right next to each other (alloc_lock and pi_lock).

yeah. We've got init_task's task-struct embedded in the vmlinux, but 
it's aligned to 32 bytes, which probably hides this effect. We'd only 
see it if the size change just happened to bring a key data structure 
(which is also embedded in the vmlinux) just below a modulo 32 bytes 
boundary. The chance for that is around 6:32 per 'merge' event. That 
means that there cannot be all that many such cases ;-)

anyway, the shorter init sequence is worth it already.

	Ingo
