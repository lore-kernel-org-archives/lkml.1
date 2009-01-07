Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbZAGMqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbZAGMqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZAGMqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:46:31 -0500
Received: from matrixpower.ru ([195.178.208.66]:55360 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbZAGMqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:46:31 -0500
Date: Wed, 7 Jan 2009 15:46:29 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107124629.GA31732@ioremap.net>
References: <20090106183704.GC32491@kernel.dk> <20090107044232.GA22218@gondor.apana.org.au> <20090107112906.GA28161@ioremap.net> <20090107115032.GA25198@gondor.apana.org.au> <20090107115605.GA29250@ioremap.net> <20090107115921.GA25323@gondor.apana.org.au> <20090107121530.GA30164@ioremap.net> <20090107122238.GB25673@gondor.apana.org.au> <20090107123741.GA31255@ioremap.net> <20090107124246.GA26034@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107124246.GA26034@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 11:42:46PM +1100, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > Doesn't your tcp fallbacks to kernel_sendmsg() without sg in
> > tcp_sendpage()? And then just feeds data into the stack the same way it
> > happens with send() i.e. by copying it.
> 
> Good point.  Did he check GSO though? GSO will always enable SG
> on the socket regardless of the netdev's setting.  And if the device
> started out with SG enabled then recent kernels will enable GSO
> by default.

Willy, what was the kernel you are tested no-accel behaviour and what
were the gso settings?
Can you add a simple single print into tcp_sendpage() to determine if
content was copied or fed into do_tcp_sendpages() otherwise?

-- 
	Evgeniy Polyakov
