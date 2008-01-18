Return-Path: <linux-kernel-owner+w=401wt.eu-S1761004AbYAROBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbYAROBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYAROBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:01:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40419 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbYAROBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:01:33 -0500
Date: Fri, 18 Jan 2008 15:01:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 4 of 4] x86: mask NX from pte_pfn
Message-ID: <20080118140113.GD12702@elte.hu>
References: <b27ec2092a01dc15e139.1200435429@localhost> <Pine.LNX.4.64.0801181350090.27929@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801181350090.27929@blonde.site>
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


* Hugh Dickins <hugh@veritas.com> wrote:

> > -	return pte_val(pte) >> PAGE_SHIFT;
> > +	return (pte_val(pte) >> PAGE_SHIFT) & ~_PAGE_NX;

> Shouldn't that be
> 
> 	return (pte_val(pte) & ~_PAGE_NX) >> PAGE_SHIFT;

ouch! Sharp eyes! Fixed it.

	Ingo
