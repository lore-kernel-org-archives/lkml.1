Return-Path: <linux-kernel-owner+w=401wt.eu-S932249AbXFFLxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbXFFLxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761673AbXFFLxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:53:06 -0400
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:62382 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751861AbXFFLxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:53:05 -0400
User-Agent: Microsoft-Entourage/11.3.3.061214
Date: Wed, 06 Jun 2007 12:52:59 +0100
Subject: Re: [Xen-devel] [patch 14/33] xen: xen time implementation
From: Keir Fraser <keir@xensource.com>
To: Jan Beulich <jbeulich@novell.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       <virtualization@lists.osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Message-ID: <C28C5EAB.1024D%keir@xensource.com>
Thread-Topic: [Xen-devel] [patch 14/33] xen: xen time implementation
Thread-Index: AceoMTpmeRN5yhQkEdyEZAAX8io7RQ==
In-Reply-To: <4666AFEF.76E4.0078.0@novell.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




On 6/6/07 12:00, "Jan Beulich" <jbeulich@novell.com> wrote:

>> If the error across CPUS is +/- just a few microseconds at worst then having
>> the clocksource clamp to no less than the last timestamp returned seems a
>> reasonable fix. Time won't 'stop' for longer than the cross-CPU error, and
>> that should always be a tiny value.
> 
> Are you sure this is also true when e.g. a CPU gets throttled due to thermal
> conditions? It is my understanding that both the duty cycle adjustment and
> the frequency reduction would yield a reduced rate TSC, which would be
> accounted for only the next time the local clock gets calibrated. Otherwise,
> immediate calibration (and vcpu update) would need to be forced out of the
> thermal interrupt.

Yes, this could be an issue. Is there any way to get an interrupt or MCE
when thermal throttling occurs?

 -- Keir

