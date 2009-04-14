Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbZDNQvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbZDNQvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZDNQvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:51:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46349 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZDNQvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:51:05 -0400
Date: Tue, 14 Apr 2009 18:50:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu_debug.c prepare report if files are
	inappropriate or CPU is not supported
Message-ID: <20090414165052.GA2089@elte.hu>
References: <1239725240.2966.4.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239725240.2966.4.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> +		if (!per_cpu(cpu_modelflag, cpu))

hm, on a second look - the whole cpu_model / cpu_modelflag 
business in arch/x86/kernel/cpu/cpu_debug.c looks 
over-complicated and broken. You encode it into a 
'modelflag':

                per_cpu(cpu_model, cpu) = ((cpui->x86_vendor << 16) |
                                           (cpui->x86 << 8) |
                                           (cpui->x86_model));

just to decode it later on:

        flag = per_cpu(cpu_model, cpu);

        switch (flag >> 16) {

That does not make much sense. Please use a proper 
boot_cpu_data.x86_vendor switch() statement, ok?

	Ingo
