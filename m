Return-Path: <linux-kernel-owner+w=401wt.eu-S1760895AbXFFJ3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbXFFJ3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbXFFJ3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:29:46 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:32953 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752140AbXFFJ3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:29:46 -0400
Message-Id: <46669AD4.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 06 Jun 2007 11:30:28 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Keir Fraser" <keir@xensource.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <virtualization@lists.osdl.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Chris Wright" <chrisw@sous-sol.org>, "Andi Kleen" <ak@suse.de>,
       "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [patch 14/33] xen: xen time implementation
References: <46668EC6.76E4.0078.0@novell.com>
 <C28C34EB.101FE%keir@xensource.com>
In-Reply-To: <C28C34EB.101FE%keir@xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Keir Fraser <keir@xensource.com> 06.06.07 10:54 >>>
>On 6/6/07 09:39, "Jan Beulich" <jbeulich@novell.com> wrote:
>
>> The issue is
>> that on that system, transition into ACPI mode takes over 600ms (SMM
>> execution, and hence no interrupts delivered during that time), and with
>> Xen using the PIT (PM timer support was added by Keir as a result of this,
>> but that doesn't cure the problem here, it just reduces the likelihood it'll
>> be encountered) platform time and local time got pretty much out of sync.
>
>If you have an ACPI PM timer in your system (and if you have SMM then your
>system is almost certainly modern enough to have one) then surely the
>problem is fixed for all practical purposes? The problem was overflow of a
>fixed-width platform counter. The PIT wraps every ~50ms, but the ACPI PM
>timer will wrap only every ~4s. It would be quite unreasonable for SMM to
>take the CPU away for multiple seconds, even as a one-time boot operation.

No, I don't think the problem's gone with the PM timer - it is just much less
likely. Since you depend on the TSC (which must generally be assumed be
unsyncronized across CPUs) and on the error correction factor (which shows
non-zero values every few seconds), getting the interpolated times on two
CPUs out of sync is still possible, and given the way the time keeping code
works even being off by just a single nanosecond may be fatal.

Jan

