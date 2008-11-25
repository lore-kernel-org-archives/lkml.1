Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbYKYVWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbYKYVWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYKYVWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:22:34 -0500
Received: from www.tglx.de ([62.245.132.106]:51624 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbYKYVWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:22:33 -0500
Date: Tue, 25 Nov 2008 22:22:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       lethal@linux-sh.org, johnstul@us.ibm.com, mingo@redhat.com
Subject: Re: [RFC] Reentrant clock sources
In-Reply-To: <20081125132823.8698.83248.sendpatchset@rx1.opensource.se>
Message-ID: <alpine.LFD.2.00.0811252215270.3235@localhost.localdomain>
References: <20081125132823.8698.83248.sendpatchset@rx1.opensource.se>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008, Magnus Damm wrote:
> Hi everyone,
> 
> Is there any special reason behind the non-reentrant clock source
> code? I'm writing some timer help code and getting the struct
> clocksource as argument to the callbacks would make the code much
> cleaner and better.

Why do you want that ? And what has reentrancy to do with the
clocksource argument to read() ?

> Extending the callbacks to be able to start and stop clock sources
> for improved power management would be good too in my opinion.
> Any thoughts?

What have you in mind there ? Starting / stopping a clocksource when
what happens ? You can't stop them randomly except you want to screw
timekeeping.

> +	cycle_t (*vread)(struct clocksource *cs);

This is crap. vread can not access the clocksource.

Thanks,

	tglx
