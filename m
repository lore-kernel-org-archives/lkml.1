Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbZFVK4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbZFVK4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 06:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZFVK4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 06:56:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45715 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbZFVK4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 06:56:11 -0400
Date: Mon, 22 Jun 2009 12:56:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: gcov: enable GCOV_PROFILE_ALL for x86_64
Message-ID: <20090622105609.GA17456@elte.hu>
References: <200906182200.n5IM0jFq007278@hera.kernel.org> <20090620101424.GA21928@elte.hu> <4A3F6AD5.1030703@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3F6AD5.1030703@linux.vnet.ibm.com>
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


Another thing i was thinking about:

the GCOV code cannot be enabled in distros right now, due to the 
high compiler-generated overhead, and due to the fact that the gcov 
data structures used are single threaded. (which makes a gcov 
enabled kernel very slow on SMP, due to the global cacheline 
bounces)

IMO it would be _much_ better to implement hardware-assisted 
call-graph tracking:

 - Use the BTS (Branch Trace Store) facilities to hardware-sample 
   all branches+calls (optionally, dynamically enable-able)

 - Post-process the raw branch trace information (in the kernel
   BTS-overflow irq handler) to calculate call-coverage information.

Unlike the unconditional GCC based GCOV stuff that is currently 
upstream, BTS tracing is supported by a large range of hardware and 
it can be enabled _transparently_, so it could be built in and 
enabled by distros too, to test code coverage.

Would you be interested in looking at (and implementing) this?

Thanks,

	Ingo
