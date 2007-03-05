Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbXCEIyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbXCEIyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 03:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbXCEIyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 03:54:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53300 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbXCEIyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 03:54:01 -0500
Date: Mon, 5 Mar 2007 09:44:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>
Subject: Re: [patch] KVM: T60 resume fix
Message-ID: <20070305084449.GA1706@elte.hu>
References: <20070301104117.GA22788@elte.hu> <20070301145204.GA25304@elte.hu> <Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org> <20070302072100.GB30634@elte.hu> <20070302080441.GA12785@elte.hu> <20070302102018.GA11549@elte.hu> <20070302102216.GA13575@elte.hu> <45E93012.4000100@qumranet.com> <20070305082251.GA23366@elte.hu> <45EBD9BC.4030801@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EBD9BC.4030801@qumranet.com>
User-Agent: Mutt/1.4.2.2i
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


* Avi Kivity <avi@qumranet.com> wrote:

> >> That is already CPU_ONLINE in my tree (and in the pull request sent 
> >> to Linus a couple of days ago).
> >
> > that solves the resume problem - but doesnt solve the CPU_DEAD issue 
> > of sending an IPI to an already offline CPU. Might be a better idea 
> > to do it in CPU_DOWN_PREPARE? (and then to also add a 
> > CPU_DOWN_FAILED branch?)
> 
> Mainline now has DOWN_PREPARE and UP_CANCELED calling 
> ->hardware_disable(), and ONLINE calling ->hardware_enabled().  What 
> tree are you looking at?

oh, i just hand-fixed it. I'll check current-git now.

> [but I do see the need for DOWN_FAILED now. Off to find a resumable 
> machine...]

yeah, both DOWN_FAILED and UP_FAILED might trigger when some other bug 
prevents a resume.

	Ingo
