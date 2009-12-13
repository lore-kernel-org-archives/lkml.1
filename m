Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbZLMRxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbZLMRxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 12:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbZLMRxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 12:53:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:58665 "HELO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753150AbZLMRx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 12:53:29 -0500
Date: Sun, 13 Dec 2009 09:55:34 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091213095534.58051536@infradead.org>
In-Reply-To: <20091213065844.GA20244@elte.hu>
References: <20091212084611.GA28266@elte.hu>
	<20091212013927.58d386d1.akpm@linux-foundation.org>
	<20091212101032.GB25286@elte.hu>
	<20091212023603.93768833.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
	<alpine.LFD.2.00.0912120920190.3526@localhost.localdomain>
	<20091212214235.31429790@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0912121418490.3526@localhost.localdomain>
	<alpine.LFD.2.00.0912122331200.3089@localhost.localdomain>
	<alpine.LFD.2.00.0912121513190.3535@localhost.localdomain>
	<20091213065844.GA20244@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Dec 2009 07:58:44 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > We've had quite a bit of BKL work this merge-window. Maybe we'll
> > even get rid of it one of these days. There are "only" about 600
> > instances of "lock_kernel()" in the tree right now ;)
> 
> I tend to use unlock_kernel() as the metric. (as it's more precisely
> greppable and it is also more indicative of the underlying complexity
> of locking, as it gets used more in more complex scenarios)

another metric is... how many times do we take the BKL for some
workload. (For example booting or compiling a kernel).
A counter like "BKLs-per-second" would be nice to expose
(and then we can track that number going up as a regression etc)

For me, a secondary metric would be "how many times do we depend on the
magic auto-drop/reget behavior".. also easy to build a counter for.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
