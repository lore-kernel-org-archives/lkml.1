Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbYKYQgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbYKYQgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbYKYQgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:36:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41397 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbYKYQgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:36:40 -0500
Date: Tue, 25 Nov 2008 17:36:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: Re: [patch 5/9] x86, bts: base in-kernel ds interface on handles
Message-ID: <20081125163624.GD22504@elte.hu>
References: <20081125090125.A31137@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125090125.A31137@sedona.ch.intel.com>
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


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> +static void ds_release(struct ds_tracer *tracer, enum ds_qualifier qual)
> +{
> +	if (tracer->context) {
> +		BUG_ON(tracer->context->owner[qual] != tracer);

please use WARN_ON_ONCE() instead of crashing the box. (this is true 
in a number of other places as well in ds.c)

	Ingo
