Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbXDBH1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbXDBH1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbXDBH1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:27:09 -0400
Received: from www.osadl.org ([213.239.205.134]:39954 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753334AbXDBH1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:27:08 -0400
Subject: Re: [RFC PATCH 0/5] x86_64: enable clockevents and dynticks
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andi Kleen <ak@suse.de>
Cc: Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200704012253.20834.ak@suse.de>
References: <20070331083149.997762000@sous-sol.org>
	 <1175419332.28263.67.camel@localhost.localdomain>
	 <200704012253.20834.ak@suse.de>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 09:27:15 +0200
Message-Id: <1175498835.28263.93.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-01 at 22:53 +0200, Andi Kleen wrote:
> > Have you checked, if we could share the code between i386 and x86_64 at
> > least for PIT and HPET. I'm not sure about the local APIC, but I think
> > it might be doable as well.
> 
> Not for PIT. I don't want all the broken ancient hardware workarounds on x86-64.

Err, what are you talking about ?

The clock events code in arch/i386/kernel/i8253.c does not have any
quirks. It's straight forward. The only quirk is in pit_read() and we
can simply make it depend on !64bit.

> HPET might be doable, but would need quite some work.

Right, but this is better spent than having two implementations of the
same thing around.

	tglx



