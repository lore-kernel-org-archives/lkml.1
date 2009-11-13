Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbZKMHgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbZKMHgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 02:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZKMHgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 02:36:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45989 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbZKMHgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 02:36:32 -0500
Date: Fri, 13 Nov 2009 08:36:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] x86: make sure wakeup code is below 1M -v2
Message-ID: <20091113073608.GB26127@elte.hu>
References: <4AF7D820.5040503@kernel.org>
 <4AFA210B.3020207@kernel.org>
 <20091112073616.GA11365@elf.ucw.cz>
 <200911122032.46872.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911122032.46872.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Thursday 12 November 2009, Pavel Machek wrote:
> > On Tue 2009-11-10 18:27:23, Yinghai Lu wrote:
> > > 
> > > try to find_e820_area/reserve_early, and call acpi_reserve_memory early
> > > 
> > > to get area is below 1M
> > 
> > Does it fix anything? I can't tell from the changelog...
> 
> Yes, it does.  If the area is above 1M, we can't run real mode code 
> from it.
> 
> This matters for NUMA machines supporting S3 (yes, there are a few 
> models out there).

It might also matter in more exotic kernels that might do some large 
allocations. (say 'nopentium' can cause +1MB/+2MB of kernel page table 
allocations per one GB of RAM)

Physical constraints to allocations (which this is) should be expressed 
early and with high priority, to make sure they can be met.

	Ingo
