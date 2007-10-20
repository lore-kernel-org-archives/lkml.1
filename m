Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbXJTEGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbXJTEGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 00:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbXJTEGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 00:06:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:39094 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbXJTEGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 00:06:13 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
In-Reply-To: <200710200510.01409.maximlevitsky@gmail.com>
References: <1192670742.12879.5.camel@pasglop>
	 <200710200402.43106.maximlevitsky@gmail.com>
	 <alpine.LFD.0.999.0710191924520.3794@woody.linux-foundation.org>
	 <200710200510.01409.maximlevitsky@gmail.com>
Content-Type: text/plain
Date: Sat, 20 Oct 2007 14:06:01 +1000
Message-Id: <1192853161.17235.34.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >  - even when you ignore the interrupt (because the driver doesn't care, 
> >    it's suspending), you need to make sure the hardware gets shut up by 
> >    reading (or writing) the proper interrupt status register.
> I agree, but while device is powered off, its registers can't be accessed
> Thus, if I ack the IRQ every time the handler is called, I will access the 
> powered off device (this is probably won't hurt a lot, but a bit incorrectly)

It will actually crash your machine on some platforms. So no, best is to
-not- ack. The masking is enough, the IRQ will go down eventually.

Ben.


