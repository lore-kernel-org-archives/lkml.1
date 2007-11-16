Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbXKPHRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbXKPHRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 02:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbXKPHRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 02:17:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39614 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbXKPHRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 02:17:15 -0500
Date: Fri, 16 Nov 2007 08:17:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: disable preemption in delay_tsc()
Message-ID: <20071116071708.GA2103@elte.hu>
References: <200711150400.lAF40lIr020160@hera.kernel.org> <20071115194116.12c7a0f6@laptopd505.fenrus.org> <20071115195234.2dc8406d.akpm@linux-foundation.org> <20071116061332.GF16273@elte.hu> <20071115230859.d9ccea20.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115230859.d9ccea20.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> It sounds like it would work OK.  What is the setup cost for a usleep?  
> I'd have thought that code which does something like
> 
> 	while (i++ < 1000) {
> 		foo();
> 		udelay(1);
> 	}
> 
> would take qiute a bit longer with such a change?

full roundtrip cost ought to be below 10 usecs, depending on the system. 
There's no problem doing a non-preemptible udelay up to 10 usecs and we 
could use usleep above that.

	Ingo
