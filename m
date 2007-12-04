Return-Path: <linux-kernel-owner+w=401wt.eu-S1752253AbXLDQlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbXLDQlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbXLDQlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:41:10 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:43300 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbXLDQlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:41:09 -0500
Date: Tue, 4 Dec 2007 14:40:59 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       herton@mandriva.com.br, dvgevers@xs4all.nl
Subject: Re: [git pull] scheduler fixes
Message-ID: <20071204144059.1e1f54ca@mandriva.com.br>
In-Reply-To: <20071204161827.GA491@elte.hu>
References: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org>
	<20071204120715.4ea204a8@mandriva.com.br>
	<alpine.LFD.0.9999.0712040751170.2981@woody.linux-foundation.org>
	<20071204160005.GA29783@elte.hu>
	<20071204161827.GA491@elte.hu>
Organization: Mandriva
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 4 Dec 2007 17:18:27 +0100
Ingo Molnar <mingo@elte.hu> escreveu:

| 
| * Ingo Molnar <mingo@elte.hu> wrote:
| 
| > The problem is on SMP: if sched_rr_get_interval() gets a task from an 
| > otherwise idle runqueue, then rq->load.weight is 0. Normally 
| > sched_slice() is only used on a busy runqueue. So the correct fixup 
| > site is not in sched_slice() but in sys_sched_rr_get_interval() - i'm 
| > working on the right fix, i hope to be able to send a pull request in 
| > a few minutes.
| 
| the problem is on UP too - if there are no SCHED_OTHER tasks. I've 
| tested the fix and it solves the problem for various combinations of 
| crash.c. I've updated sched.git, please pull it from:
| 
|    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
| 
| It has another commit besides this fix. Thanks,

 Yes, I tested the 'sched: fix crash in sys_sched_rr_get_interval()'
one and it really fixes the problem.

 Thanks a lot Ingo.

-- 
Luiz Fernando N. Capitulino
