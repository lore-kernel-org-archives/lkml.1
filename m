Return-Path: <linux-kernel-owner+w=401wt.eu-S1161368AbXDXG55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161368AbXDXG55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 02:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161364AbXDXG55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 02:57:57 -0400
Received: from gw.goop.org ([64.81.55.164]:60163 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161368AbXDXG54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 02:57:56 -0400
Message-ID: <462DAA8C.10508@goop.org>
Date: Mon, 23 Apr 2007 23:58:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Prarit Bhargava <prarit@redhat.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
References: <20070327214919.800272641@goop.org>	<20070327215827.871954359@goop.org> <20070423234910.50149faf.akpm@linux-foundation.org>
In-Reply-To: <20070423234910.50149faf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 27 Mar 2007 14:49:20 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> The softlockup watchdog is currently a nuisance in a virtual machine,
>> since the whole system could have the CPU stolen from it for a long
>> period of time.  While it would be unlikely for a guest domain to be
>> denied timer interrupts for over 10s, it could happen and any softlockup
>> message would be completely spurious.
>>
>> Earlier I proposed that sched_clock() return time in unstolen
>> nanoseconds, which is how Xen and VMI currently implement it.  If the
>> softlockup watchdog uses sched_clock() to measure time, it would
>> automatically ignore stolen time, and therefore only report when the
>> guest itself locked up.  When running native, sched_clock() returns
>> real-time nanoseconds, so the behaviour would be unchanged.
>>
>> Note that sched_clock() used this way is inherently per-cpu, so this
>> patch makes sure that the per-processor watchdog thread initialized
>> its own timestamp.
>>     
>
> This patch
> (ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/ignore-stolen-time-in-the-softlockup-watchdog.patch)
> causes six failures in the locking self-tests, which I must say is rather
> clever of it.
>   

Interesting.  Which variation of sched_clock do you have in your tree at
the moment?

    J
