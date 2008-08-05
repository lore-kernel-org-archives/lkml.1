Return-Path: <linux-kernel-owner+w=401wt.eu-S1763724AbYHEVqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763724AbYHEVqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbYHEVqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:46:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:51445 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbYHEVqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:46:37 -0400
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Karsten Keil <kkeil@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>
In-Reply-To: <20080805210239.GB6052@pingi.kke.suse.de>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de>
	 <1217910588.24157.151.camel@pasglop>
	 <20080805113111.GA6827@pingi.kke.suse.de>
	 <1217941466.24157.190.camel@pasglop>
	 <20080805172549.GA6052@pingi.kke.suse.de>
	 <alpine.LFD.1.10.0808051140250.3257@nehalem.linux-foundation.org>
	 <20080805210239.GB6052@pingi.kke.suse.de>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 07:45:53 +1000
Message-Id: <1217972753.24157.204.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> static void
> my_out32(struct card *c, u_int offset, u-int data) 
> {
> 	if (c->mode == MMIO) {
> 		...
> 	} else {
> 		...
> 	}
> }
> 
> or use 2 function, one for the MMIO and one for the PIO model and then use
> indirect calls (like c->my_out32(...)) ?

The former is more ugly but slightly faster on some archs.

Indirect function calls tend to be slightly slower than an if / else
statement that can be more easily predicted by the processor.

But in the case of IOs, it's not going to be a big deal, -especially- if
you use the _rep forms for data transfers (and thus don't do an indirect
call for each read/write). So it's totally up to you.

Cheers,
Ben.


