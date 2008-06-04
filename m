Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbYFDKpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbYFDKpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYFDKo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:44:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32933 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbYFDKoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:44:55 -0400
Date: Wed, 4 Jun 2008 12:44:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@suse.cz>,
       linux-kernel@vger.kernel.org, davej@codemonkey.org.uk,
       andi@firstfloor.org
Subject: Re: aperture_64.c: corner case wrong
Message-ID: <20080604104438.GA5522@elte.hu>
References: <20080526191730.GA18425@elf.ucw.cz> <20080602153033.2d1672f0.akpm@linux-foundation.org> <alpine.LFD.1.10.0806031551330.3235@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806031551330.3235@apollo.tec.linutronix.de>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> > So what happened with this?  Thomas has merged an "x86: 
> > aperture_64.c: cleanups" from yourself but it appears that half of 
> > this bugfix got applied somewhere and the below part did not?
> 
> Err, no. I seem to have dropped the patch completely. I'm picking it 
> up again.

no, it was not dropped (we dont drop patches :), here are all the 
arch/x86/kernel/aperture_64.c patches in -tip:

 earth4:~/tip> tip-log arch/x86/kernel/aperture_64.c | grep ^#
 # x86/gart: 1edc1ab: x86: agp_gart size checking for buggy device
 # x86/gart: 8c9fd91: x86: checking aperture size order
 # x86/gart: 7677b2e: x86_64: allocate gart aperture from 512M
 # x86/gart: 55c0d72: x86: clean up aperture_64.c
 # x86/gart: 0abbc78: x86, aperture_64: use symbolic constants
 # x86/gart: dd564d0: x86: aperture_64.c: cleanups

so it's commit dd564d0 - but that second chunk Andrew noticed indeed 
went missing in action.

	Ingo
