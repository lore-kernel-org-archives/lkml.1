Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbYHEVou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbYHEVou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757991AbYHEVom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:44:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:51407 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757922AbYHEVom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:44:42 -0400
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Karsten Keil <kkeil@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>
In-Reply-To: <20080805172549.GA6052@pingi.kke.suse.de>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de>
	 <1217910588.24157.151.camel@pasglop>
	 <20080805113111.GA6827@pingi.kke.suse.de>
	 <1217941466.24157.190.camel@pasglop>
	 <20080805172549.GA6052@pingi.kke.suse.de>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 07:43:56 +1000
Message-Id: <1217972636.24157.201.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 19:25 +0200, Karsten Keil wrote:
> Yes this stuff looks really cool, but unfortunately in our case it is not
> so easy to remove the different IO functions for MMIO and PIO, since for
> MMIO the chip use a flat register model, for PIO it use indirect addressing
> via only 2 ports, one for the register offset and one for the data IO.
> 
> Maybe we can use the trick from lib/iomap.c to detect which
> kind of IO is needed, but unfortunately PIO_OFFSET, PIO_MASK and
> PIO_RESERVED are not exported so it would need to copy the defines, which
> isn't a really clean solution.

Don't use a trick like that. Not all archs use lib/iomap.c and those who
don't have their own implementation using a different way of
differenciating them.

In any case, that's fine, you can still keep track of whether you
initially mapped things IO or MEM and use different access methods
without having to use different accessors.

Cheers,
Ben.


