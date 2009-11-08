Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbZKHI56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbZKHI56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 03:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZKHI56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 03:57:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44905 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbZKHI55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 03:57:57 -0500
Date: Sun, 8 Nov 2009 09:57:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Aristeu Rozanski <aris@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: introduce NMI_AUTO as nmi_watchdog option
Message-ID: <20091108085748.GA13716@elte.hu>
References: <20091103171054.GB25437@redhat.com>
 <20091104114630.GA16993@elte.hu>
 <20091104151929.GH18613@redhat.com>
 <20091104155641.GA11444@elte.hu>
 <19186.44983.543376.657628@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19186.44983.543376.657628@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> Ingo Molnar writes:
>  > > but that would work only for LAPIC. You're suggesting killing IOAPIC 
>  > > mode too?
>  > 
>  > Would it be a big loss, with all modern systems expected to have a 
>  > working lapic based NMI source?
> 
> The IOAPIC NMI uses a HW resource that is free and reliable, the LAPIC 
> NMI uses a HW resource that is neither free nor reliable (for that 
> application), and for which better applications exist. So I prefer the 
> IOAPIC NMI.

The IO-APIC based NMI watchdog is neither free nor reliable.

Firstly, when we use it we cripple dynticks/NOHZ.

Secondly, there's been cases where activating the IO-APIC NMI watchdog 
causes rare lockups. One of my testsystems is such - once every few 
dozen bootups it would hang hard with the IO-APIC NMI watchdog 
activated.

No other OS uses the IO-APIC in this fashion, so it's a cute legacy 
hack, but we are phasing it out. It's not default.

> (I admit part of that preference is because using the IOAPIC NMI 
> helped stabilize a Dell PE2650 here years ago. Without the IOAPIC NMI 
> the machine would lock up hard within days or a few weeks at the 
> most.)

That looks quite myserious, did you get to the bottom of it? Does it 
reproduce with latest kernels too? It might be one of the dynticks hangs 
we fixed, and such hangs got in essence worked around by the nmi 
watchdog deactivating nohz. The nohz=off boot option would do something 
similar.

	Ingo
