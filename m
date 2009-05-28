Return-Path: <linux-kernel-owner+w=401wt.eu-S1762208AbZE1MTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762208AbZE1MTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760153AbZE1MTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:19:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:38927 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760994AbZE1MTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:19:16 -0400
Subject: Re: [tip:perfcounters/core] perf stat: handle Ctrl-C
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <18974.28935.538648.438570@cargo.ozlabs.ibm.com>
References: <new-submission>
	 <tip-58d7e993b16b62d30f8ef27757614056fe4def11@git.kernel.org>
	 <18974.28935.538648.438570@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 28 May 2009 14:19:03 +0200
Message-Id: <1243513143.6600.47.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 21:09 +1000, Paul Mackerras wrote:
> tip-bot for Ingo Molnar writes:
> 
> > perf stat: handle Ctrl-C
> > 
> > Before this change, if a long-running perf stat workload was Ctrl-C-ed,
> > the utility exited without displaying statistics.
> > 
> > After the change, the Ctrl-C gets propagated into the workload (and
> > causes its early exit there), but perf stat itself will still continue
> > to run and will display counter results.
> > 
> > This is useful to run open-ended workloads, let them run for
> > a while, then Ctrl-C them to get the stats.
> 
> Unfortunately it means that if you do e.g.
> 
> $ while true; do perf stat something; done
> 
> it's impossible to kill the loop with ctrl-C.  To fix this we need to
> make perf stat kill itself with the signal after printing the results,
> so bash sees the died-due-to-signal exit status and stops the loop.

Yep, just ran into the same..

^Z kill $! worked though, but that's not ideal.

