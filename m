Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbXCRIRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbXCRIRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 04:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbXCRIRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 04:17:19 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59425 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbXCRIRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 04:17:18 -0400
Date: Sun, 18 Mar 2007 00:12:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@stusta.de>,
       Arjan van de Ven <arjan@infradead.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] i386: trust the PM-Timer calibration of the local APIC
 timer
Message-Id: <20070318001235.f388f551.akpm@linux-foundation.org>
In-Reply-To: <1174089896.13341.362.camel@localhost.localdomain>
References: <200703161230.03712.maximlevitsky@gmail.com>
	<1174088686.13341.347.camel@localhost.localdomain>
	<1174089896.13341.362.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Mar 2007 01:04:56 +0100 Thomas Gleixner <tglx@linutronix.de> wrote:

> When PM-Timer is available for local APIC timer calibration we can skip
> the verification of the calibrated time value. The resulting error is
> quite small on a bunch of evaluated platforms and is less harming than
> the observed false positives.
> 
> We need to keep the verification on systems, which have no PM-Timer to
> avoid bogus local APIC timer calibrations in the range of factor 2-10,
> which can be observed when swicthing off the PM-timer support in the
> kernel configuration.
> 
> The wrong calibration values are probably caused by SMM code trying to
> emulate a PS/2 keyboard from a (maybe connected or not) USB keyboard.
> This prohibits the accurate delivery of PIT interrupts, which are used
> to calibrate the local APIC timer. Unfortunately we have no way to
> disable this BIOS misfeature in the early boot process.
> 
> Add also the dropped cpu_relax() back to the wait loops.

Is this a for-2.6.21 thing?
