Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbZGAIZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbZGAIZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZGAIZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:25:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41769 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956AbZGAIZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:25:15 -0400
Date: Wed, 1 Jul 2009 10:24:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf_counter: tools: Rework event parsing
Message-ID: <20090701082457.GB25593@elte.hu>
References: <19018.53826.843815.189847@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19018.53826.843815.189847@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> This reworks the parser for event descriptors to make it more
> consistent in what it accepts.  It is now structured as a recursive
> descent parser for the following grammar:
> 
> events		::= event ( ("," | space) space* event )*
> event		::= ( raw_event | numeric_event | symbolic_event |
> 		      generic_hw_event ) [ event_modifier ]
> raw_event	::= "r" hex_number
> numeric_event	::= number ":" number
> number		::= decimal_number | "0x" hex_number | "0" octal_number
> symbolic_event	::= string_from_event_symbols_array
> generic_hw_event::= cache_type ( "-" ( cache_op | cache_result ) )*
> event_modifier	::= ":" ( "u" | "k" | "h" )+

Very nice changes, thanks Paul!

	Ingo
