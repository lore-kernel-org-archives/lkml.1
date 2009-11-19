Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbZKSNFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbZKSNFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZKSNFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:05:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60757 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZKSNFa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:05:30 -0500
Subject: Re: yield() in i2c non-happy paths hits BUG under -rt patch
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jean Delvare <khali@linux-fr.org>, Thomas Gleixner <tglx@linutronix.de>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       linux-i2c@vger.kernel.org, rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091119125906.6ad00edd@lxorguk.ukuu.org.uk>
References: <c384c5ea0911071101u7415d37o2611c542e5fae309@mail.gmail.com>
	 <20091107210147.3e754278@hyperion.delvare>
	 <4AF7148C.9090706@thebigcorporation.com>
	 <20091112211255.09cd884a@hyperion.delvare>
	 <alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
	 <20091116155606.GC29479@sirena.org.uk>
	 <c384c5ea0911171650t1c441dc4v746d31e4154fcb30@mail.gmail.com>
	 <20091118010520.4cd397d4@lxorguk.ukuu.org.uk>
	 <c384c5ea0911180828x7c857189w3316c93bb78100ab@mail.gmail.com>
	 <20091118175202.490989d8@hyperion.delvare>
	 <alpine.LFD.2.00.0911182127040.24119@localhost.localdomain>
	 <20091119130526.23a69b85@hyperion.delvare>
	 <20091119125906.6ad00edd@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 Nov 2009 14:06:54 +0100
Message-ID: <1258636014.4372.328.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 12:59 +0000, Alan Cox wrote:
> > Well, I guess only people monitoring system latency would notice, as
> > this is the only thing yield() was supposed to help with in the first
> > place.
> 
> 	if (need_resched())
> 		schedule();

aka.

	cond_resched();

> will make non-rt tasks act politely at the right moments. RT tasks will
> likely immediately get to take the CPU again depending upon the
> scheduling parameters in use.

Right, FIFO will simply NOP it, since if it was the highest running
task, it will still be. RR could possibly run out of its slice and
schedule to another RR of the same prio.


