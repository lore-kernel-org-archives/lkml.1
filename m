Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYKTMJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYKTMJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 07:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbYKTMJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 07:09:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54570 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbYKTMJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 07:09:10 -0500
Date: Thu, 20 Nov 2008 13:09:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28-rc5 07/11] kmemleak: Remove some of the kmemleak
	false positives
Message-ID: <20081120120904.GD20724@elte.hu>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com> <20081120113107.16607.76990.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120113107.16607.76990.stgit@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Catalin Marinas <catalin.marinas@arm.com> wrote:

>  	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
>  		vc_cons[currcons].d = vc = alloc_bootmem(sizeof(struct vc_data));
> +		/* kmemleak does not track the memory allocated via
> +		 * alloc_bootmem() but this block contains pointers to
> +		 * other blocks allocated via kmalloc */
> +		memleak_alloc(vc, sizeof(struct vc_data), 1);

Comment style - and that is true for other bits of your patchset too.

	Ingo
