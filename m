Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbZFDTrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbZFDTrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZFDTrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:47:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38454 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbZFDTrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:47:32 -0400
Date: Thu, 4 Jun 2009 21:47:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perfcounter: sleep before refresh using poll in perf
	top
Message-ID: <20090604194725.GB24606@elte.hu>
References: <1244141284-7507-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244141284-7507-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> perf top is refreshed every delay_secs the thread runs in such
> loop:
> 
> while (sleep(delay_secs)) {
> 	print_sym_table();
> }
> 
> At the end of print_sym_table(), poll is used without sleep delay
> to check if we have something from stdin.
> 
> It means that this check is done only every delay_secs, which can
> be higher that 2 secs if the user defined a custom refresh rate.
> 
> We can drop sleep() here and directly use poll to wait between
> refresh periods, so that the reaction after the user stops perf top
> after typing "Enter" is immediate and doesn't suffer from the
> delay_secs latency.
> 
> Nb: poll doesn't add any overhead that can parasite perf top measures
> since it sleeps the entire timeout here.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  Documentation/perf_counter/builtin-top.c |   18 ++++++++----------
>  1 files changed, 8 insertions(+), 10 deletions(-)

Applied, thanks a lot Frederic!

	Ingo
