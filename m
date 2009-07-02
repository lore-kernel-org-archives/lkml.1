Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbZGBGOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbZGBGOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZGBGOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:14:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36129 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbZGBGOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:14:00 -0400
Date: Thu, 2 Jul 2009 08:12:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix printk calling in print_local_apic
Message-ID: <20090702061254.GA23277@elte.hu>
References: <4A4C3410.8080704@kernel.org> <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain> <alpine.LFD.2.01.0907012126371.3380@localhost.localdomain> <4A4C43BC.90506@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4C43BC.90506@kernel.org>
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


> -	printk(KERN_DEBUG "0123456789abcdef0123456789abcdef\n" KERN_DEBUG);
> +	printk(KERN_DEBUG "0123456789abcdef0123456789abcdef\n");
>  	for (i = 0; i < 8; i++) {
> +		char bin[33];
>  		v = apic_read(base + i*0x10);
> +
> +		/* Do we really want to print out LSB first? */

We definitely want MSB first - i'll flip around the order.

	Ingo
