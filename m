Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbXFFJ4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbXFFJ4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757881AbXFFJ4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:56:37 -0400
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:61423 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757796AbXFFJ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:56:37 -0400
User-Agent: Microsoft-Entourage/11.3.3.061214
Date: Wed, 06 Jun 2007 10:56:34 +0100
Subject: Re: [Xen-devel] [patch 14/33] xen: xen time implementation
From: Keir Fraser <keir@xensource.com>
To: Jan Beulich <jbeulich@novell.com>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       <virtualization@lists.osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Message-ID: <C28C4362.1021C%keir@xensource.com>
Thread-Topic: [Xen-devel] [patch 14/33] xen: xen time implementation
Thread-Index: AceoIPcDNYnijBQUEdyEZAAX8io7RQ==
In-Reply-To: <46669AD4.76E4.0078.0@novell.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07 10:30, "Jan Beulich" <jbeulich@novell.com> wrote:

>> If you have an ACPI PM timer in your system (and if you have SMM then your
>> system is almost certainly modern enough to have one) then surely the
>> problem is fixed for all practical purposes? The problem was overflow of a
>> fixed-width platform counter. The PIT wraps every ~50ms, but the ACPI PM
>> timer will wrap only every ~4s. It would be quite unreasonable for SMM to
>> take the CPU away for multiple seconds, even as a one-time boot operation.
> 
> No, I don't think the problem's gone with the PM timer - it is just much less
> likely. Since you depend on the TSC (which must generally be assumed be
> unsyncronized across CPUs) and on the error correction factor (which shows
> non-zero values every few seconds), getting the interpolated times on two
> CPUs out of sync is still possible, and given the way the time keeping code
> works even being off by just a single nanosecond may be fatal.

If the error across CPUS is +/- just a few microseconds at worst then having
the clocksource clamp to no less than the last timestamp returned seems a
reasonable fix. Time won't 'stop' for longer than the cross-CPU error, and
that should always be a tiny value.

 -- Keir

