Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbYG1B7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbYG1B7K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 21:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYG1B65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 21:58:57 -0400
Received: from aun.it.uu.se ([130.238.12.36]:35877 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYG1B64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 21:58:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18573.10107.853761.684410@harpo.it.uu.se>
Date: Mon, 28 Jul 2008 03:57:15 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Miller <davem@davemloft.net>
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, kkeil@suse.de
Subject: Re: mISDN still breaking the allmodconfig build...
In-Reply-To: <20080727.180736.74131389.davem@davemloft.net>
References: <20080727.170235.97056809.davem@davemloft.net>
	<93120C4B-D2F4-4479-806B-2141AC3DC607@holtmann.org>
	<20080727.180736.74131389.davem@davemloft.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:
 > From: Marcel Holtmann <marcel@holtmann.org>
 > Date: Mon, 28 Jul 2008 03:03:04 +0200
 > 
 > > > More fallout from the premature mISDN driver merge:
 > > >
 > > > drivers/isdn/hardware/mISDN/hfcmulti.c:5255:2: error: #error "not  
 > > > running on big endian machines now"
 > > 
 > > is that only the HFC driver or the whole mISDN stack?
 > > 
 > > I know that the two old ISDN stacks where really bad on big endian,  
 > > but my assumption was that we did sort this out in the end.
 > 
 > One of the two mISDN drivers uses the deprecated virt_to_bus()
 > interface for handling DMA addresses (that doesn't even work on many
 > x86 systems these days) and the other mISDN driver gives the above
 > big-endian compile time error.
 > 
 > In short, this driver was not ready for merging at all.

Why on earth does a generic (I hope) protocol driver (some ISDN
thingy in this case) care about endianess at all?

Or has things come to a "the world's an x86" ("the world's a VAX" for
old-timers but add 25+ years or so) situation where the majority of
coders don't even consider that machines might be different from what
they use? If so, a deep sigh of sadness.

(Not that I prefer a particular endianess. My point being that coders
shouldn't make endianess assumptions unless they're really^3 important.)>
