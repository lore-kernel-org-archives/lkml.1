Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbXDXUYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbXDXUYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbXDXUYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:24:07 -0400
Received: from gw.goop.org ([64.81.55.164]:54719 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbXDXUYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:24:04 -0400
Message-ID: <462E6778.7070305@goop.org>
Date: Tue, 24 Apr 2007 13:24:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Prarit Bhargava <prarit@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>, john stultz <johnstul@us.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, virtualization@lists.osdl.org,
       Chris Lalancette <clalance@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
References: <20070327214919.800272641@goop.org>	<20070327215827.871954359@goop.org>	<20070423234910.50149faf.akpm@linux-foundation.org>	<462E43A7.1050001@goop.org>	<20070424105738.e0ce36a9.akpm@linux-foundation.org>	<462E4969.6070802@goop.org>	<20070424113222.ed2e1314.akpm@linux-foundation.org> <462E61F1.7060403@goop.org>
In-Reply-To: <462E61F1.7060403@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Andrew Morton wrote:
>   
>> Well, it _is_ mysterious.
>>
>> Did you try to locate the code which failed?  I got lost in macros and
>> include files, and gave up very very easily.  Stop hiding, Ingo.
>>   
>>     
>
> OK, I've managed to reproduce it.  Removing the local_irq_save/restore
> from sched_clock() makes it go away, as I'd expect (otherwise it would
> really be magic).  But given that it never seems to touch the softlockup
> during testing, I have no idea what difference it makes...

And sched_clock's use of local_irq_save/restore appears to be absolutely
correct, so I think it must be triggering a bug in either the self-tests
or lockdep itself.

The only way I could actually extract the test code itself was to run
the whole thing through cpp+indent, but it doesn't shed much light.

It's also not clear to me if there are 6 independent failures, or if
they're a cascade.

    J
