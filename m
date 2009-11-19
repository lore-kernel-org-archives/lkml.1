Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbZKSM5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbZKSM5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 07:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZKSM5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 07:57:44 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52035 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751369AbZKSM5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 07:57:43 -0500
Date: Thu, 19 Nov 2009 12:59:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       linux-i2c@vger.kernel.org, rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: yield() in i2c non-happy paths hits BUG under -rt patch
Message-ID: <20091119125906.6ad00edd@lxorguk.ukuu.org.uk>
In-Reply-To: <20091119130526.23a69b85@hyperion.delvare>
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
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, I guess only people monitoring system latency would notice, as
> this is the only thing yield() was supposed to help with in the first
> place.

	if (need_resched())
		schedule();

will make non-rt tasks act politely at the right moments. RT tasks will
likely immediately get to take the CPU again depending upon the
scheduling parameters in use.
