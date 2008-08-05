Return-Path: <linux-kernel-owner+w=401wt.eu-S1762428AbYHESni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762428AbYHESni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbYHESn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:43:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755621AbYHESn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:43:29 -0400
Date: Tue, 5 Aug 2008 11:42:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Karsten Keil <kkeil@suse.de>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
In-Reply-To: <20080805172549.GA6052@pingi.kke.suse.de>
Message-ID: <alpine.LFD.1.10.0808051140250.3257@nehalem.linux-foundation.org>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de> <1217910588.24157.151.camel@pasglop> <20080805113111.GA6827@pingi.kke.suse.de> <1217941466.24157.190.camel@pasglop> <20080805172549.GA6052@pingi.kke.suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Aug 2008, Karsten Keil wrote:
> 
> Maybe we can use the trick from lib/iomap.c to detect which
> kind of IO is needed, but unfortunately PIO_OFFSET, PIO_MASK and
> PIO_RESERVED are not exported so it would need to copy the defines, which
> isn't a really clean solution.

Even if they were exported, you couldn't.

lib/iomap.c is _not_ generic code. It's a library function for 
architectures that don't do it some other way. But various architectures 
can choose to not use lib/iomap.c at all - for example, they may have MMIO 
and PIO in the same address space, so they don't need the conditionals at 
all (because all the work was done at mapping time, not at runtime).

So if you actually have different models of operation for PIO and MMIO, 
then yes, you need to handle that in the driver itself.

		Linus
