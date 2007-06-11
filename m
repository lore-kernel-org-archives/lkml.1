Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbXFKNMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbXFKNMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 09:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbXFKNME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 09:12:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50608 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbXFKNMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 09:12:00 -0400
Date: Mon, 11 Jun 2007 15:11:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: IRQ handler type mismatch for IRQ 7
Message-ID: <20070611131147.GA31307@elte.hu>
References: <19f34abd0706110607u6cf889dci9b8d48494cb40be0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0706110607u6cf889dci9b8d48494cb40be0@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> I receive this on a fresh install of Fedora 7 (x86_64) running 
> 2.6.21-1.3194.fc7, and wonder if it's something to worry about:
> 
> IRQ handler type mismatch for IRQ 7
> current handler: parport0

> [<ffffffff802adf6d>] request_irq+0xd7/0xfd
> [<ffffffff8039a583>] serial8250_startup+0x423/0x56f

so both parport and serial is on the same IRQ: #7, but the parport one 
does not support shared interrupt lines (IRQF_SHARED). You can probably 
change the mapping in the BIOS (change the serial one to say IRQ#3 or 
IRQ#4). I suspect you dont have any real parallel port hardware 
attached? (and probably no serial port hardware either?) So you can 
safely ignore this.

	Ingo
