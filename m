Return-Path: <linux-kernel-owner+w=401wt.eu-S1765325AbXJTFqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765325AbXJTFqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 01:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbXJTFqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 01:46:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:49798 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbXJTFqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 01:46:36 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
In-Reply-To: <200710200736.22129.maximlevitsky@gmail.com>
References: <1192670742.12879.5.camel@pasglop>
	 <200710200624.58261.maximlevitsky@gmail.com>
	 <1192856675.6745.5.camel@pasglop>
	 <200710200736.22129.maximlevitsky@gmail.com>
Content-Type: text/plain
Date: Sat, 20 Oct 2007 15:46:24 +1000
Message-Id: <1192859184.6745.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> I probably need to add this synchronize_irq() logic in dmfe.c too, but I probably do it later,
> I think I am overestimating this race, since most drivers don't do dev->insuspend checks in IRQ handler.
> Maybe even just use free_irq() after all....

Most drivers are probably underestimating the race :-)

free_irq() would work provided that you did the masking on chip before
(and unmask only after request_irq on the way back in). But it's a bit
like using a 10 tons truck to crush an ant... 

Ben.


