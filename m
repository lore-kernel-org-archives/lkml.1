Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbYBKLtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbYBKLtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYBKLtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:49:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49731 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbYBKLtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:49:25 -0500
Date: Mon, 11 Feb 2008 12:49:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] [3/8] CPA: Test the correct mapping alias on x86-64
Message-ID: <20080211114911.GB2498@elte.hu>
References: <200802111034.764275766@suse.de> <20080211093431.D673D1B41CE@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211093431.D673D1B41CE@basil.firstfloor.org>
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


* Andi Kleen <ak@suse.de> wrote:

> static_protections previously would test against the x86-64 kernel 
> mapping twice. First against the unchanged symbol directly from the 
> linker (which always points into the kernel mapping) and then again it 
> would manually relocate the address into the kernel mapping and test 
> again.
> 
> This patch reverses the second test instead to test against the direct 
> mapping (low) aliases virtual addresses which was probably intended in 
> the first place.
> 
> Simply use __pa and __va for that.

thanks, applied.

( the practical implications of this are low because we do not utilize 
  the low direct aliases for execution. It needs to be fixed 
  nevertheless (will be needed for PAT later on anyway) and your cleanup 
  and #ifdef reduction is nice to have as well. )

	Ingo
