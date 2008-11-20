Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbYKTVs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbYKTVs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 16:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbYKTVsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 16:48:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58846 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbYKTVsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 16:48:17 -0500
Date: Thu, 20 Nov 2008 22:48:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: Markus Metzger <markus.t.metzger@googlemail.com>,
       lkml <linux-kernel@vger.kernel.org>, work <markus.t.metzger@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86, bts: fix unlock problem in ds.c
Message-ID: <20081120214805.GA8475@elte.hu>
References: <1226743217.6162.4.camel@raistlin> <7c86c4470811201314q564b64c0i99f3d9865d9cc8f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470811201314q564b64c0i99f3d9865d9cc8f0@mail.gmail.com>
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


* stephane eranian <eranian@googlemail.com> wrote:

> Markus,
> 
> I think this patch is not quite right. You don't want to go out via 
> out_unlock because you're going to call ds_put_context)() when you 
> did not invoke the matching ds_get_context() (hidden in 
> ds_alloc_context). It happens later in the ds_request() function.

i noticed that, and fixed it via:

 10db4ef: x86, PEBS/DS: fix code flow in ds_request()

can you still see problems with it?

	Ingo
