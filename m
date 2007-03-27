Return-Path: <linux-kernel-owner+w=401wt.eu-S965233AbXC0HAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965233AbXC0HAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 03:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965268AbXC0HAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 03:00:55 -0400
Received: from sp604005mt.neufgp.fr ([84.96.92.11]:34215 "EHLO smtp.Neuf.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965233AbXC0HAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 03:00:54 -0400
Date: Tue, 27 Mar 2007 09:00:49 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 1/2] Ignore stolen time in the softlockup watchdog
In-reply-to: <20070327054106.664262413@goop.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Prarit Bhargava <prarit@redhat.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>
Message-id: <4608C121.4050309@cosmosbay.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <20070327053816.881735237@goop.org>
 <20070327054106.664262413@goop.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge a écrit :

> +static DEFINE_PER_CPU(unsigned long long, touch_timestamp);

...

>  void touch_softlockup_watchdog(void)
>  {
> -	__raw_get_cpu_var(touch_timestamp) = jiffies;
> +	__raw_get_cpu_var(touch_timestamp) = sched_clock();
>  }

Not very clear if this is safe on 32bit, since this is not anymore atomic.

Maybe a comment would help ?


