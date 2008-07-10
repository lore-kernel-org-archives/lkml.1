Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbYGJHAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbYGJHAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYGJHA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:00:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60686 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbYGJHA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:00:27 -0400
Date: Thu, 10 Jul 2008 09:00:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: make e820_end return end_of_ram again for 64bit
Message-ID: <20080710070012.GC14377@elte.hu>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092015.03004.yhlu.kernel@gmail.com> <200807092016.36490.yhlu.kernel@gmail.com> <200807092017.51004.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807092017.51004.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> even for 64bit system with less 4G, we can use fixmap to handle acpi 
> sit near end of ram

ok - applied to tip/x86/core - lets see whether Suresh's system now 
works fine with this change.

> change e820_end to e820_end_of_ram again?
> or e820_ram_pfn?

i'd suggest e820_end_of_ram_pfn().

we now have symmetric behavior on 32-bit and 64-bit, e820_end() returns 
the true end of RAM. (64-bit used to return the last PFN mentioned in 
the e820 map - i.e. ACPI tables and other end of RAM items could have 
been included)

	Ingo
