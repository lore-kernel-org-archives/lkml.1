Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbZDNMdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbZDNMdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZDNMcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:32:35 -0400
Received: from mail001.aei.ca ([206.123.6.130]:37209 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbZDNMce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:32:34 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.30-rc1 - nmi_watchdog broken?
Date: Tue, 14 Apr 2009 08:29:21 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-crc; KDE/4.2.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
References: <200904140000.30155.edt@aei.ca> <20090414084232.GG27003@elte.hu>
In-Reply-To: <20090414084232.GG27003@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904140829.21493.edt@aei.ca>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 April 2009 04:42:32 Ingo Molnar wrote:
> 
> * Ed Tomlinson <edt@aei.ca> wrote:
> 
> > Hi,
> > 
> > I've been having fun finding bugs in 30-rc1.  One of them is a 
> > hard freeze.  I've not seen this type of problem on this hardware 
> > before 30-rc1 - so I doubt if its hardware.  The best way I know 
> > to debug a hard hang is with the nmi_watchdog.  I just cannot get 
> > it to work.
> 
> [ Btw., have you tried CONFIG_PROVE_LOCKING=y - does it produce
>   anything before or at the hard lockup point? ]
> 
> > The system is a 3 core amd cpu on a 790gx chipset.
> > 
> > If I boot the nmi_watchdog=1 it complains that lapci is not 
> > available and the boot stops.  Same problem if I change the 
> > clocksource to tsc, If I disable highres timers it panics.  If I 
> > use nmi_watchdog=2 it panics. Am I doing something wrong or have I 
> > hit a bug?
> > 
> > Logs of boots with and without highres timers inlined below.
> 
> hm, nmi_watchdog=1 acting funny is not unheard of. But 
> nmi_watchdog=2 should really work. How does it panic, do
> you have a capture of that?

I had not tried nmi_watchdog=2 highres=off.  This works.  Looks like there
is a conflict between highres timers and nmi_watchdog here.

Any ideas?

TIA
Ed

PS. I'll build with config_prove_locking tonight.

