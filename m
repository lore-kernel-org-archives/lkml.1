Return-Path: <linux-kernel-owner+w=401wt.eu-S1761684AbYBUJGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761684AbYBUJGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYBUJGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:06:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52101 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYBUJGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:06:33 -0500
Date: Thu, 21 Feb 2008 10:05:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Ian Campbell <ijc@hellion.org.uk>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86 : relocate uninitialized variable in init DATA
	section into init BSS section
Message-ID: <20080221090557.GB20055@elte.hu>
References: <1203581723.4707.20.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203581723.4707.20.camel@caritas-dev.intel.com>
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


* Huang, Ying <ying.huang@intel.com> wrote:

> Uninitialized variable in init DATA sections are relocated into init 
> BSS sections to reduce kernel image size. Several KB can be reduced.

> -int __initdata early_ioremap_debug;
> +int __initbss early_ioremap_debug;

will we get some sort of build error if we accidentally do:

   int __initbss early_ioremap_debug = 1;

?

	Ingo
