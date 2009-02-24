Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbZBXUvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbZBXUvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 15:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZBXUv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 15:51:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53566 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbZBXUv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 15:51:29 -0500
Date: Tue, 24 Feb 2009 21:51:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk
	allocation
Message-ID: <20090224205105.GA19460@elte.hu>
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224201718.GE28772@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224201718.GE28772@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> >   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git 
> >   tj-percpu
> 
> ok, i pulled it into tip:core/percpu (one conflict resolution 
> done - please double check it), and exposed it to -tip testing 
> briefly.
> 
> Six x86 test-systems failed ;-) One of them had this panic:
> 
> Scan SMP from ffff880000000000 for 1024 bytes.
> Scan SMP from ffff88000009fc00 for 1024 bytes.
> Scan SMP from ffff8800000f0000 for 65536 bytes.
> found SMP MP-table at [ffff8800000fe680] fe680
> PANIC: early exception 0  rip   :                 error   cr2       
> PANIC: early exception 0  rip   :                 error   cr2   

Ah, spoke too soon. Bisection gave this commit from Yinghai:

dc07da5: x86: check range in reserve_early()

	Ingo
