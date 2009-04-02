Return-Path: <linux-kernel-owner+w=401wt.eu-S1762077AbZDBT2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762077AbZDBT2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbZDBT2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:28:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51528 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbZDBT2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:28:12 -0400
Date: Thu, 2 Apr 2009 21:27:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: markus.t.metzger@intel.com
Cc: tglx@linutronix.de, hpa@zytor.com, markus.t.metzger@gmail.com,
       roland@redhat.com, eranian@googlemail.com, oleg@redhat.com,
       juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 13/18] x86, ds: add leakage warning
Message-ID: <20090402192755.GD2455@elte.hu>
References: <20090402145455.597376000@intel.com> <20090402145726.223198000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402145726.223198000@intel.com>
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


* markus.t.metzger@intel.com <markus.t.metzger@intel.com> wrote:

> +static inline void ds_warn_leak(struct task_struct *tsk)
> +{
> +	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
> +}

> +	ds_warn_leak(tsk);

since we normally expect X86_DS enabled i'd suggest this 
simplification: always have thread.ds_ctx around so the WARN_ON can 
go there unconditionally. (it wont trigger in the !DS case)

>  struct task_struct;
>  struct mm_struct;
> +struct ds_context;

why is this needed in processor.h?

ds.h should be split into ds_types.h and ds_api.h, with the pure 
data type definitions in ds_types.h. processor.h (which needs to 
know about the DS context type) then includes ds_types.h - which
is a lightweight header.

Actual DS using facilities also disable ds_api.h.

This keeps data types nicely separated from methods and inlines.

	Ingo
