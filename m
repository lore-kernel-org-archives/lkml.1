Return-Path: <linux-kernel-owner+w=401wt.eu-S1422670AbXCNVnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422670AbXCNVnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 17:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422673AbXCNVnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 17:43:01 -0400
Received: from gw.goop.org ([64.81.55.164]:56030 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422670AbXCNVnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 17:43:01 -0400
Message-ID: <45F86C60.7060903@goop.org>
Date: Wed, 14 Mar 2007 14:42:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>  <45F70A71.9090205@goop.org>	 <1173821224.1416.24.camel@dwalker1>  <45F71EA5.2090203@goop.org>	 <1173837606.23595.32.camel@imap.mvista.com>  <45F79B9C.20609@goop.org>	 <1173888673.3101.12.camel@imap.mvista.com>  <45F824BE.1060708@goop.org>	 <1173891595.3101.17.camel@imap.mvista.com>  <45F82C01.3000704@goop.org>	 <1173895607.3101.58.camel@imap.mvista.com>  <45F841EE.6060703@goop.org>	 <1173898800.3101.81.camel@imap.mvista.com>  <45F8508F.3070109@goop.org>	 <1173904438.3101.92.camel@imap.mvista.com>  <45F8663D.5050102@goop.org> <1173908065.3101.97.camel@imap.mvista.com>
In-Reply-To: <1173908065.3101.97.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> It's used for measuring execution time, but timers are triggered based
> on that time, so it needs to be actual execution time. I don't know to
> what extent this is already inaccurate on some system tho.
>   

Well, "actual execution time" is a bit ambiguous: should that be "time
actually spent executing", or "time we should have spent executing"?

It looks like cpu_clock_sample() will only return accurate results on
yourself; if you get the sched_ns on a thread on another cpu, it won't
include the time accumulated since the start of its timeslice.

    J

