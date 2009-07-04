Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbZGDJal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbZGDJal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 05:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZGDJab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 05:30:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36000 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbZGDJa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 05:30:29 -0400
Date: Sat, 4 Jul 2009 11:29:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>, Robert Hancock <hancockr@shaw.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Axel Birndt <towerlexa@gmx.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/3] pci: determine CLS more intelligently
Message-ID: <20090704092956.GA26456@elte.hu>
References: <4A4EE3E9.7090205@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4EE3E9.7090205@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Till now, CLS has been determined either by arch code or as 
> L1_CACHE_BYTES.  Only x86 and ia64 set CLS explicitly and x86 
> doesn't always get it right.  On most configurations, the chance 
> is that firmware configures the correct value during boot.
> 
> This patch makes pci_init() determine CLS by looking at what 
> firmware has configured.  It scans all devices and if all non-zero 
> values agree, the value is used.  If none is configured or there 
> is a disagreement, pci_dfl_cache_line_size is used.  arch can set 
> the dfl value (via PCI_CACHE_LINE_BYTES or 
> pci_dfl_cache_line_size) or override the actual one.
> 
> ia64, x86 and sparc64 updated to set the default cls instead of 
> the actual one.
> 
> While at it, declare pci_cache_line_size and 
> pci_dfl_cache_line_size in pci.h and drop private declarations 
> from arch code.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: David Miller <davem@davemloft.net>
> Acked-by: Greg KH <gregkh@suse.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tony Luck <tony.luck@intel.com>

The principle looks good to me. Regressions could be expected though 
- these details are fragile and affect the way how we talk to 
hardware.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
