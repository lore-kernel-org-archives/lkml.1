Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbYDNIEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbYDNIEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbYDNIEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:04:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55516 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629AbYDNIEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:04:24 -0400
Date: Mon, 14 Apr 2008 10:03:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       joe@perches.com
Subject: Re: [PATCH 2/2] printk: Remember the message level for multi-line
	output
Message-ID: <20080414080351.GL16163@elte.hu>
References: <20080413115152.29086.37845.stgit@marcab.local.tull.net> <20080413122735.31769.17716.stgit@marcab.local.tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413122735.31769.17716.stgit@marcab.local.tull.net>
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


* Nick Andrew <nick@nick-andrew.net> wrote:

> printk: Remember the message level for multi-line output
> 
> printk(KERN_ALERT "Danger Will Robinson!\nAlien Approaching!\n");
> 
> At present this will result in one message at ALERT level and one at 
> the current default message loglevel (e.g. WARNING). This is 
> non-intuitive.
> 
> Modify vprintk() to remember the message loglevel each time it is 
> specified and use it for subsequent lines of output which do not 
> specify one, within the same call to printk.

i've applied this too for testing.

but multi-line strings are a bit unclean i think: each message line 
should have its separate printk.

will your patch leave the behavior of multiple calls to printk alone? 
I.e. if i do:

  printk(KERN_ALERT "Danger Will Robinson!\n");
  printk("Alien Approaching!\n");

then we'll still get a KERN_ALERT plus a default printk, right? In that 
case my earlier observation about this patch is moot and i guess it's 
fine to do this.

	Ingo
