Return-Path: <linux-kernel-owner+w=401wt.eu-S1760337AbXJLR6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337AbXJLR6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbXJLR6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:58:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43471 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656AbXJLR6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:58:38 -0400
Date: Fri, 12 Oct 2007 19:58:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rok Markovic <kernel@kanardia.eu>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.23-rt1 lockup after loading HAL deamon
Message-ID: <20071012175831.GA27420@elte.hu>
References: <470F27DA.9020307@kanardia.eu> <20071012083551.GA17937@elte.hu> <470FB4F4.60707@kanardia.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470FB4F4.60707@kanardia.eu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rok Markovic <kernel@kanardia.eu> wrote:

> I tried to recompile with those options enabled, kernel and linux 
> boots and loads fine, but after few minutes (if i try to recompile 
> kernel in console) the system locks completely (hard reset) without 
> any messages. Is there anything I can do, maybe console on serial 
> port? My new config is atached.

yes, serial console (or netconsole) output would be useful, if you can 
solve that. Another way would be to boot with nmi_watchdog=2, do the 
kernel recompile in a VGA text console, and wait for the lockup to 
occur. Either you get some crash message to the text console 
immediately, or you should get the NMI watchdog print something within a 
minute or so. If neither happens you just get a blank hard lockup then 
the wedge is very deep ...

(also make sure that the NMI counter in /proc/interrupts is increasing 
on all CPUs properly, with nmi_watchdog=2. If not all CPUs/cores are 
increasing their NMI counters once per second then the NMI watchdog wont 
be able to print out a stackdump.)

	Ingo
