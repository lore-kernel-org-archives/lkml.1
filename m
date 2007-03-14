Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbXCNRIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbXCNRIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXCNRIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:08:20 -0400
Received: from gw.goop.org ([64.81.55.164]:60890 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbXCNRIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:08:18 -0400
Message-ID: <45F82C01.3000704@goop.org>
Date: Wed, 14 Mar 2007 10:08:17 -0700
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
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>  <45F70A71.9090205@goop.org>	 <1173821224.1416.24.camel@dwalker1>  <45F71EA5.2090203@goop.org>	 <1173837606.23595.32.camel@imap.mvista.com>  <45F79B9C.20609@goop.org>	 <1173888673.3101.12.camel@imap.mvista.com>  <45F824BE.1060708@goop.org> <1173891595.3101.17.camel@imap.mvista.com>
In-Reply-To: <1173891595.3101.17.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
>> I suppose you could, but that seems more complex.  I think you could
>> encode the same information in the measurement of how much work a cpu
>> actually got done while a process was scheduled on it.
>>     
>
> I know it's more complex, but that seems more like the "right" thing to
> do.

Why's that?

I'm proposing that rather than using "time spent scheduled" as an
approximation of how much progress a process made on a particular CPU
during its timeslice, we should measure it directly. It seems to me that
this usefully encapsulates both the problems of variable-speed cpus and
hypervisors stealing time from guests.

The actual length of the timeslices is an orthogonal issue.  It may be
that you want to give processes more cpu time by making their quanta
longer to compensate for lost cpu time, but that would affect their
real-time characteristics.  Or you could keep the quanta small, and give
those processes more of them.

But all this is getting deep into scheduler design, which is not what I
want to get into; I'm just proposing a better metric for a scheduler to
use in whatever way it wants.

    J
