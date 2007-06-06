Return-Path: <linux-kernel-owner+w=401wt.eu-S1759729AbXFFIzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729AbXFFIzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbXFFIy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 04:54:56 -0400
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:60926 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753138AbXFFIyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 04:54:55 -0400
User-Agent: Microsoft-Entourage/11.3.3.061214
Date: Wed, 06 Jun 2007 09:54:51 +0100
Subject: Re: [Xen-devel] [patch 14/33] xen: xen time implementation
From: Keir Fraser <keir@xensource.com>
To: Jan Beulich <jbeulich@novell.com>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       <virtualization@lists.osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Message-ID: <C28C34EB.101FE%keir@xensource.com>
Thread-Topic: [Xen-devel] [patch 14/33] xen: xen time implementation
Thread-Index: AceoGFfalk+8WBQLEdyEZAAX8io7RQ==
In-Reply-To: <46668EC6.76E4.0078.0@novell.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07 09:39, "Jan Beulich" <jbeulich@novell.com> wrote:

> The issue is
> that on that system, transition into ACPI mode takes over 600ms (SMM
> execution, and hence no interrupts delivered during that time), and with
> Xen using the PIT (PM timer support was added by Keir as a result of this,
> but that doesn't cure the problem here, it just reduces the likelihood it'll
> be encountered) platform time and local time got pretty much out of sync.

If you have an ACPI PM timer in your system (and if you have SMM then your
system is almost certainly modern enough to have one) then surely the
problem is fixed for all practical purposes? The problem was overflow of a
fixed-width platform counter. The PIT wraps every ~50ms, but the ACPI PM
timer will wrap only every ~4s. It would be quite unreasonable for SMM to
take the CPU away for multiple seconds, even as a one-time boot operation.

 -- Keir

