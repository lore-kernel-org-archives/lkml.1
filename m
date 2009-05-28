Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbZE1LKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbZE1LKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZE1LKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:10:06 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:48985 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbZE1LKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:10:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18974.28935.538648.438570@cargo.ozlabs.ibm.com>
Date: Thu, 28 May 2009 21:09:59 +1000
From: Paul Mackerras <paulus@samba.org>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf stat: handle Ctrl-C
In-Reply-To: <tip-58d7e993b16b62d30f8ef27757614056fe4def11@git.kernel.org>
References: <new-submission>
	<tip-58d7e993b16b62d30f8ef27757614056fe4def11@git.kernel.org>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Ingo Molnar writes:

> perf stat: handle Ctrl-C
> 
> Before this change, if a long-running perf stat workload was Ctrl-C-ed,
> the utility exited without displaying statistics.
> 
> After the change, the Ctrl-C gets propagated into the workload (and
> causes its early exit there), but perf stat itself will still continue
> to run and will display counter results.
> 
> This is useful to run open-ended workloads, let them run for
> a while, then Ctrl-C them to get the stats.

Unfortunately it means that if you do e.g.

$ while true; do perf stat something; done

it's impossible to kill the loop with ctrl-C.  To fix this we need to
make perf stat kill itself with the signal after printing the results,
so bash sees the died-due-to-signal exit status and stops the loop.

Paul.
