Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbYEKNpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbYEKNpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 09:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYEKNpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 09:45:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55321 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbYEKNpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 09:45:46 -0400
Date: Sun, 11 May 2008 15:45:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511134524.GA1045@elte.hu>
References: <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org> <20080511130127.GA30685@elte.hu> <20080511130621.GS19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511130621.GS19219@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> IOW, what I think you're checking for is:
> 
> task A			task B
> 			if sem->count >0
> 				break;
> sem->count++
> wake_up_process(B)
> 			if (state == TASK_INTERRUPTIBLE && signal_pending(task))
> 				break;
> 
> which can't happen because of sem->lock.

ok, agreed, that race cannot happen.

	Ingo
