Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZAEJNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZAEJNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZAEJNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:13:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48026 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbZAEJNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:13:19 -0500
Date: Mon, 5 Jan 2009 10:12:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, dhaval@linux.vnet.ibm.com,
       jens.axboe@oracle.com, snakebyte@gmx.de, andi@firstfloor.org,
       akpm@linux-foundation.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       rostedt@goodmis.org, tglx@linutronix.de, manfred@colorfullife.com
Subject: Re: [PATCH] Make treercu safe for suspend and resume
Message-ID: <20090105091249.GB5440@elte.hu>
References: <20090104194111.GA16398@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104194111.GA16398@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello!
> 
> Kudos to both Dhaval Giani and Jens Axboe for finding a bug in treercu
> that causes warnings after suspend-resume cycles in Dhaval's case and
> during stress tests in Jens's case.  It would also probably cause failures
> if heavily stressed.  The solution, ironically enough, is to revert to
> rcupreempt's code for initializing the dynticks state.  And the patch
> even results in smaller code -- so what was I thinking???
> 
> This is 2.6.29 material, given that people really do suspend and resume
> Linux these days.  ;-)
> 
> Located-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Located-by: Jens Axboe <jens.axboe@oracle.com>
> Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Tested-by: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  rcutree.c |   12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

applied to tip/core/urgent, thanks guys!

	Ingo
