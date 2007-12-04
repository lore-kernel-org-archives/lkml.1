Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbXLDP5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbXLDP5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbXLDP5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:57:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52537 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408AbXLDP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:57:29 -0500
Date: Tue, 4 Dec 2007 07:56:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, herton@mandriva.com.br, dvgevers@xs4all.nl
Subject: Re: [local DoS] Re: Linux 2.6.24-rc4
In-Reply-To: <20071204120715.4ea204a8@mandriva.com.br>
Message-ID: <alpine.LFD.0.9999.0712040751170.2981@woody.linux-foundation.org>
References: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org> <20071204120715.4ea204a8@mandriva.com.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Dec 2007, Luiz Fernando N. Capitulino wrote:
>
> 	sched_rr_get_interval(1, NULL);

Looks like we have a zero "cfs_rq->load.weight".

Ingo? Both sched_slice() and __sched_slice() do a divide by the runqueue 
weight, and at least dequeue_task_fair() explicitly checks for that being 
zero, so clearly zero is a possible value. Hmm?

		Linus
