Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbXLDQEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbXLDQEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbXLDQEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:04:37 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:55203 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbXLDQEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:04:36 -0500
Date: Tue, 4 Dec 2007 14:04:25 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       herton@mandriva.com.br, dvgevers@xs4all.nl
Subject: Re: [local DoS] Re: Linux 2.6.24-rc4
Message-ID: <20071204140425.05b0b458@mandriva.com.br>
In-Reply-To: <20071204160005.GA29783@elte.hu>
References: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org>
	<20071204120715.4ea204a8@mandriva.com.br>
	<alpine.LFD.0.9999.0712040751170.2981@woody.linux-foundation.org>
	<20071204160005.GA29783@elte.hu>
Organization: Mandriva
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 4 Dec 2007 17:00:05 +0100
Ingo Molnar <mingo@elte.hu> escreveu:

| 
| * Linus Torvalds <torvalds@linux-foundation.org> wrote:
| 
| > 
| > 
| > On Tue, 4 Dec 2007, Luiz Fernando N. Capitulino wrote:
| > >
| > > 	sched_rr_get_interval(1, NULL);
| > 
| > Looks like we have a zero "cfs_rq->load.weight".
| > 
| > Ingo? Both sched_slice() and __sched_slice() do a divide by the 
| > runqueue weight, and at least dequeue_task_fair() explicitly checks 
| > for that being zero, so clearly zero is a possible value. Hmm?
| 
| yeah, i can reproduce this crash too.
| 
| The problem is on SMP: if sched_rr_get_interval() gets a task from an 
| otherwise idle runqueue, then rq->load.weight is 0. Normally 
| sched_slice() is only used on a busy runqueue. So the correct fixup site 
| is not in sched_slice() but in sys_sched_rr_get_interval() - i'm working 
| on the right fix, i hope to be able to send a pull request in a few 
| minutes.

 Ingo, I can reproduce this w/o SMP support as well.

 (Also, the backtrace I sent was reproduced on a UP machine with a
SMP kernel).

-- 
Luiz Fernando N. Capitulino
