Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbXGaJVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbXGaJVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXGaJVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:21:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34263 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbXGaJVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:21:24 -0400
Date: Tue, 31 Jul 2007 11:21:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] RT: Preemptible Function-Call-IPI Support
Message-ID: <20070731092119.GA15968@elte.hu>
References: <20070730211350.5162.99143.stgit@novell1.haskins.net> <20070730211539.5162.87483.stgit@novell1.haskins.net> <20070731091903.GA15822@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731091903.GA15822@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ mail re-sent with lkml Cc:-ed. _Please_ Cc: all patches to lkml too! 
  Unless you want -rt to suffer the fate of -ck, keep upstream involved 
  all the time. The recent /proc/interrupts-all discussion with upstream 
  folks showed the clear benefits of that approach. ]

* Gregory Haskins <ghaskins@novell.com> wrote:
 
> This code allows FUNCTION_CALL IPIs to become preemptible by executing 
> them in kthread context instead of interrupt context.  They are 
> referred to as "Virtual Function Call IPIs" (VFCIPI) because we no 
> longer rely on the actual FCIPI facility.  Instead we schedule a 
> thread to run.  This essentially replaces the synchronous FCIPI with 
> an async RESCHEDULE IPI.

why do we need this? It's quite complex and brings little extra AFAICS. 
See the "schedule_on_each_cpu-enhance.patch" from Peter Ziljstra that 
lets a function to be executed on all CPUs. That should be extended 
(trivially) to execute a function on another CPU. That's all we need. 

	Ingo
