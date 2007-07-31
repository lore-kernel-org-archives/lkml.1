Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbXGaWs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbXGaWs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbXGaWsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:48:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:36467 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbXGaWsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:48:15 -0400
In-Reply-To: <46A798D8.7020906@freescale.com>
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <20070725165326.5331.19920.stgit@localhost.localdomain> <46A78322.3080607@ru.mvista.com> <46A78E3F.1030904@ru.mvista.com> <20070725180145.GA29689@ld0162-tx32.am.freescale.net> <46A7941F.2050300@ru.mvista.com> <46A798D8.7020906@freescale.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <14924a51c8a1664a21a85f450d503e82@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 2/2] [POWERPC] MPC8349E-mITX: use platform IDE driver for CF	interface
Date: Wed, 1 Aug 2007 00:47:57 +0200
To: Scott Wood <scottwood@freescale.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>    I never suggested that -- what I did suggest was make of_serial.c
>> recognize certain chip types and register them with 8250 driver.
>
> What would be the advantage of maintaining a list of chips whose only
> difference is register spacing, rather than just using reg-shift and
> being done with it?

reg-shift alone isn't enough to know how to access the device
registers.  In the case of UARTs, they typically are internal
to some SoC, so the device driver can just look up what SoC it
is and will then know what to do.  For IDE though, as far as I
understand it typically is board-specific, done by some glue
logic off of some GPIOs or on an FPGA; I think detection is best
handled by platform code in this case, an "mmio-ide" shim driver
would be helpful of course.


Segher

