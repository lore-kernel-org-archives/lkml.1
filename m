Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbXCNSGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbXCNSGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbXCNSGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:06:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:45438 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbXCNSGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:06:54 -0400
Subject: Re: Stolen and degraded time and schedulers
From: Daniel Walker <dwalker@mvista.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk,
       Virtualization Mailing List <virtualization@lists.osdl.org>
In-Reply-To: <45F82C01.3000704@goop.org>
References: <45F6D1D0.6080905@goop.org>
	 <1173816769.22180.14.camel@localhost>  <45F70A71.9090205@goop.org>
	 <1173821224.1416.24.camel@dwalker1>  <45F71EA5.2090203@goop.org>
	 <1173837606.23595.32.camel@imap.mvista.com>  <45F79B9C.20609@goop.org>
	 <1173888673.3101.12.camel@imap.mvista.com>  <45F824BE.1060708@goop.org>
	 <1173891595.3101.17.camel@imap.mvista.com>  <45F82C01.3000704@goop.org>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 11:06:47 -0700
Message-Id: <1173895607.3101.58.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 10:08 -0700, Jeremy Fitzhardinge wrote:

> The actual length of the timeslices is an orthogonal issue.  It may be
> that you want to give processes more cpu time by making their quanta
> longer to compensate for lost cpu time, but that would affect their
> real-time characteristics.  Or you could keep the quanta small, and give
> those processes more of them.
> 
> But all this is getting deep into scheduler design, which is not what I
> want to get into; I'm just proposing a better metric for a scheduler to
> use in whatever way it wants.

>From prior emails I think your suggesting that 1ms (or 5 or 10) of time
should actually be a variable X that is changed inside sched_clock().
That's not the purpose of that API call, sched_clock() measure real time
period.

After reading your emails it sounds like what you really want is similar
to accurate state accounting which is used for scheduling purposes. Part
of that has already been implemented at least twice that I know of.
Accounting real time against specific states was done in two version of
microstate accounting. Those are fine starting points for the changes
you are wanting.

Daniel

