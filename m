Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbYBILQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbYBILQc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 06:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYBILQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 06:16:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40527 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbYBILQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 06:16:24 -0500
Date: Sat, 9 Feb 2008 12:16:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [1/2] Use standard global TLB flushes in MTRR code v2
Message-ID: <20080209111612.GA5273@elte.hu>
References: <20080208122.996401758@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208122.996401758@suse.de>
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

> This is more idiomatic and it does not really make sense for this code 
> to implement a own TLB flushing variant.
> 
> The control registers will be read/written a few times more, but that 
> should not really matter for this code.

what you do not point out in the changelog, and what i've mentioned to 
you in past replies but you still ignore it: that the patch changes what 
the code does - we now keep PGE enabled in cr4 during the MTRR changing.

the MTRR code is historically fragile, rarely triggered code, laced with 
CPU errata. The change brings us absolutely nothing (it in fact 
increases the code size a bit) and it is just not worth the risk at this 
stage.

	Ingo
