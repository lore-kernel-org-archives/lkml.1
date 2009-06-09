Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZFIOXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZFIOXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZFIOXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 10:23:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51835 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZFIOXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:23:01 -0400
Date: Tue, 9 Jun 2009 16:22:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: clear TS in irq_ts_save() when in an atomic
	section
Message-ID: <20090609142254.GC32703@elte.hu>
References: <20090609100512.7d191fd4@dhcp-100-2-144.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609100512.7d191fd4@dhcp-100-2-144.bos.redhat.com>
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


* Chuck Ebbert <cebbert@redhat.com> wrote:

> -	if (!in_interrupt())
> +	if (!in_atomic() && !in_interrupt())
>  		return 0;

since in_interrupt() implies in_atomic() (upstream), why not just 
do:

	if (!in_atomic())
 		return 0;

?

	Ingo
