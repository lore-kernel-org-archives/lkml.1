Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbYDHIYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbYDHIYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYDHIYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:24:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48040 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYDHIYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:24:14 -0400
Date: Tue, 8 Apr 2008 10:23:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader
	decompressor
Message-ID: <20080408082354.GA13940@elte.hu>
References: <20080405013014.478571000@polaris-admin.engr.sgi.com> <20080405013014.693571000@polaris-admin.engr.sgi.com> <20080405134626.GA15894@mailshack.com> <47FA6478.1070301@sgi.com> <20080407214434.GA5296@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407214434.GA5296@mailshack.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> I did see that the malloc space that the inflate code is using is 
> taken from _after_ the end of the bss. I don't see how this is 
> protected from being used/overwritten. Changing the stack size changes 
> the memory layout a bit... maybe you were so unlucky to create a 
> vmlinux image that was just barely smaller than some threshold and 
> increasing the stack size made the decompression/relocation area be 
> located somewhere else?
> 
> Test patch follows.

that's a really interesting theory.

FWIIW, i've been booting allyesconfig bzImages for a long time (with 
only minimal amount of drivers disabled - mostly old ISA ones that 
assume the presence of the real hardware), and they boot and work fine 
on both 32-bit and 64-bit typical whitebox PCs. That means huge bzImages 
that decompresses into a ~41 MB kernel image. I'd expect that to be a 
rather severe test of the decompressor.

	Ingo
