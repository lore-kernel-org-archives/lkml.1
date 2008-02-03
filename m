Return-Path: <linux-kernel-owner+w=401wt.eu-S934413AbYBCF62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934413AbYBCF62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 00:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYBCF6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 00:58:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45431 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbYBCF6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 00:58:18 -0500
Date: Sun, 3 Feb 2008 06:58:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Chris Rankin <rankincj@yahoo.com>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.24 refuses to boot - ATA problem?
Message-ID: <20080203055807.GA25545@elte.hu>
References: <745427.71265.qm@web52907.mail.re2.yahoo.com> <200802022243.13710.gene.heskett@gmail.com> <20080203044428.GA10139@elte.hu> <200802030011.34086.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802030011.34086.gene.heskett@gmail.com>
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


* Gene Heskett <gene.heskett@gmail.com> wrote:

> I believe its the same, but lemme paste it for sure, yes:
> [   26.339926] ENABLING IO-APIC IRQs
> [   26.340119] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
> [   26.350129] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> [   26.350182] ...trying to set up timer (IRQ0) through the 8259A ...  failed.
> [   26.350185] ...trying to set up timer as Virtual Wire IRQ... failed.
> [   26.360186] ...trying to set up timer as ExtINT IRQ... works.
> 
> The third line is the only line that makes it to the screen during the 
> boot trace.
> 
> Now, what does this tell us?

the question would be:

 - if you remove the acpi_use_timer_override boot flag
 - and if you boot a kernel with this hack applied

=> do those weird PATA failures come back?

If the failues do _not_ come back then the problem is somehow 
affected/worked-around by the IO-APIC code that generates the above 4 
lines. If the failures are still the same then the above 4 lines are 
really just an uninteresting side-effect of the acpi_use_timer_override 
flag - and the real side-effects (that fixes PATA on your box) are to be 
found elsewhere.

Sadly, the latter variant is the expected answer.

	Ingo
