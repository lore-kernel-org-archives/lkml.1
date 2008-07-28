Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbYG1Kv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbYG1Kv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 06:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbYG1KvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 06:51:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:38083 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbYG1KvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 06:51:20 -0400
Subject: Re: mISDN still breaking the allmodconfig build...
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David Miller <davem@davemloft.net>, sfr@canb.auug.org.au, kkeil@suse.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-Reply-To: <93120C4B-D2F4-4479-806B-2141AC3DC607@holtmann.org>
References: <20080727.170235.97056809.davem@davemloft.net>
	 <93120C4B-D2F4-4479-806B-2141AC3DC607@holtmann.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 20:50:53 +1000
Message-Id: <1217242253.11188.197.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 03:03 +0200, Marcel Holtmann wrote:
> Hi Dave,
> 
> > More fallout from the premature mISDN driver merge:
> >
> > drivers/isdn/hardware/mISDN/hfcmulti.c:5255:2: error: #error "not  
> > running on big endian machines now"
> 
> is that only the HFC driver or the whole mISDN stack?
> 
> I know that the two old ISDN stacks where really bad on big endian,  
> but my assumption was that we did sort this out in the end.

Well, I got it working well enough (the old one) on a ppc405 about 5 or
6 years ago... It did require some endian & dma mapping fixing, iirc, in
the hisax pci driver, but nothing very tricky.

What bugs me is that we -fixed- at least some of these things in the old
stack, up to the point where I could use it reliably in some commercial
products, and now we are merging a new stack which, in that area, is a
clear regression over the old code.

One basic premise to me for replacing a whole stack with a new one is
that the new one should be -at-least- as good as the old one in all
areas, and those (virt_to_bus and endianness) are pretty major.

Ben.


