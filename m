Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbZFVLdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbZFVLdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZFVLdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:33:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58620 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbZFVLdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:33:17 -0400
Date: Mon, 22 Jun 2009 13:32:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 -tip] perf_counter: parse-events.c introduce alias
	member in event_symbol
Message-ID: <20090622113256.GA22479@elte.hu>
References: <1245669194.17153.6.camel@localhost.localdomain> <1245669268.17153.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245669268.17153.8.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> 
> By introducing alias member in event_symbol :
> 
> 1. duplicate lines are removed, like:
>    cpu-cycles and cycles
>    branch-instructions and branches
>    context-switches and cs
>    cpu-migrations and migrations
> 
> 2. We can also add alias for another events.
> 
> Now ./perf list looks like :
> 
> List of pre-defined events (to be used in -e):
> 
>   cpu-cycles OR cycles                     [Hardware event]
>   instructions                             [Hardware event]
>   cache-references                         [Hardware event]
>   cache-misses                             [Hardware event]
>   branch-instructions OR branches          [Hardware event]
>   branch-misses                            [Hardware event]
>   bus-cycles                               [Hardware event]
> 
>   cpu-clock                                [Software event]
>   task-clock                               [Software event]
>   page-faults                              [Software event]
>   faults                                   [Software event]
>   minor-faults                             [Software event]
>   major-faults                             [Software event]
>   context-switches OR cs                   [Software event]
>   cpu-migrations OR migrations             [Software event]
> 
>   rNNN                                     [raw hardware event descriptor]
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  tools/perf/util/parse-events.c |   63 ++++++++++++++++++++++++----------------
>  1 files changed, 38 insertions(+), 25 deletions(-)

That looks useful - applied, thanks!

Another nice thing would be for 'perf list' to actually start each 
counter and stop it - and see whether it ticks. Perhaps that could 
be a new sub-command: 'perf test' ?

New 'perf' subcommands are added easily:

create a new tools/perf/builtin-foo.c file, add it to 
command-list.txt and to the Makefile - add it to perf.c's array of 
built-in commands and add a Documentation/perf-foo.txt file to 
generate manpages and usage strings for it.

	Ingo
