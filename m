Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbYG1Xf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbYG1Xf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYG1XfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:35:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60675 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYG1XfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:35:18 -0400
Date: Tue, 29 Jul 2008 01:34:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: Is there still value in having a special tlb flush IPI
	vector?
Message-ID: <20080728233455.GA2919@elte.hu>
References: <488E534F.2030204@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488E534F.2030204@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Now that normal smp_function_call is no longer an enormous bottleneck, 
> is there still value in having a specialised IPI vector for tlb 
> flushes?  It seems like quite a lot of duplicate code.
>
> The 64-bit tlb flush multiplexes the various cpus across 8 vectors to 
> increase scalability. If this is a big issue, then the smp function 
> call code can (and should) do the same thing.  (Though looking at it 
> more closely, the way the code uses the 8 vectors is actually a less 
> general way of doing what smp_call_function is doing anyway.)

yep, and we could eliminate the reschedule IPI as well.

	Ingo
