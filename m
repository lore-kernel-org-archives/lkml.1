Return-Path: <linux-kernel-owner+w=401wt.eu-S1765429AbXJPFn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765429AbXJPFn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 01:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbXJPFnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 01:43:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54621 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971AbXJPFnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 01:43:17 -0400
Date: Tue, 16 Oct 2007 07:42:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, shemminger@linux-foundation.org
Subject: Re: [patch] forcedeth: fix the NAPI poll function
Message-ID: <20071016054236.GA27906@elte.hu>
References: <20071015112430.GA30006@elte.hu> <20071015.125731.79447899.davem@davemloft.net> <20071015220357.GA7174@elte.hu> <20071015220720.GA16101@elte.hu> <20071015223009.GA27425@elte.hu> <4713EC59.4010106@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4713EC59.4010106@pobox.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1653]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jgarzik@pobox.com> wrote:

> Two comments:
> 
> 1) we have a vague definition of "RX work processed."  Due to error 
> conditions and goto's in that function, rx_processed_cnt may or may 
> not equal the number of packets actually processed.
> 
> 2) man I dislike these inline C statement combinations (ranting at 
> original code style, not you).  I would much rather waste a few extra 
> lines of source code and make the conditions obvious:
> 
> 	while (... && (rx_processed_cnt < limit)) {
> 		rx_processed_cnt++;
> 
> 		...
> 	}
> 
> or even
> 
> 	while (1) {
> 		...
> 		if (rx_processed_cnt == limit)
> 			break;
> 		rx_processed_cnt++;
> 	}
> 
> The compiler certainly doesn't care, and IMO it prevents bugs.

agreed. Do you have an uptodate patch/git-URI for the forcedeth rewrite 
you did? I can throw it into the testbed.

	Ingo
