Return-Path: <linux-kernel-owner+w=401wt.eu-S1762745AbYJJU5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762745AbYJJU5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759244AbYJJU5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:57:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38549 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757816AbYJJU5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:57:12 -0400
Date: Fri, 10 Oct 2008 22:56:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [bug] latest -git boot hang
Message-ID: <20081010205642.GA28840@elte.hu>
References: <20081010203043.GA11798@elte.hu> <20081010204015.GA15668@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010204015.GA15668@elte.hu>
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


> bisection ongoing. [...]

the result is:

 # bad:  [f6bccf69] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
 # good: [3fa8749e] Linux 2.6.27
 # good: [d403a648] Merge phase #1 of git://git.kernel.org/pub/scm/lin
 # bad:  [ad3316bf] block: Find bio sector offset given idx and offset
 # bad:  [10865dfa] sg: convert the non-data path to use the block lay
 # good: [88e34126] block: update add_partition() error handling
 # bad:  [4c46501d] block: move holder_dir from disk to part0
 # good: [f615b48c] sd/ide-disk: apply extended minors to sd and ide
 # bad:  [80795aef] block: move capacity from disk to part0
 # bad:  [ed9e1982] block: implement and use {disk|part}_to_dev()
 # bad:  [870d6656] block: implement CONFIG_DEBUG_BLOCK_EXT_DEVT

| 870d6656126add8e383645732b03df2b7ccd4f94 is first bad commit
| commit 870d6656126add8e383645732b03df2b7ccd4f94
| Author: Tejun Heo <tj@kernel.org>
| Date:   Mon Aug 25 19:47:25 2008 +0900
|
|     block: implement CONFIG_DEBUG_BLOCK_EXT_DEVT

and meanwhile 2 other test-systems failed to boot as well - both have 
CONFIG_DEBUG_BLOCK_EXT_DEVT=y.

So i guess this debug feature is working as expected.

I guess we should mark CONFIG_DEBUG_BLOCK_EXT_DEVT=y as really dangerous 
to enable because contemporary distributions (i tried Fedora 9) fail 
with it too?

	Ingo
