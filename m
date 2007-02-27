Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657AbXB0N66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657AbXB0N66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 08:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbXB0N66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 08:58:58 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:50766 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbXB0N65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 08:58:57 -0500
Date: Tue, 27 Feb 2007 08:55:35 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ioread32 endianess.
Message-ID: <20070227135535.GD3545@athena.road.mcmartin.ca>
References: <f19298770702260736i51622584r1979a202bdc64c1d@mail.gmail.com> <20070226160450.GB3787@athena.road.mcmartin.ca> <f19298770702270431i198e032fhe025e221a625140f@mail.gmail.com> <20070227132021.GC3545@athena.road.mcmartin.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227132021.GC3545@athena.road.mcmartin.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 08:20:21AM -0500, Kyle McMartin wrote:
> PCI is always little endian, unless it's not. In which case you're probably
> dealing with a graphics card which likely has some kind of palindromic
> register which you can read and write to set the endianness of the host
> interface. Whoo. Run on sentence.
> 

Perhaps we should have a Documentation/ entry for this...

io(read|write){8,16,32} are the "pci iomap" functions (see
asm-generic/iomap.h) they always byteswap so the value is little endian.

io(read|write){8,16,32}be are sister functions added to deal with big
endian busses. They always byteswap so the value is in big endian.

Both these previous functions can handle using a cookie based on an IO port
range, or an MMIO region.

(read|write){b,w,l} are the old style MMIO-mapped accessors. They also always
byteswap so the value is in little endian. There is no big endian equivalent
for the generic case.

__raw_(read|write){b,w,l} are also old style accessors. They always operate
in host endianness.

The above are (AFAIK) the only functions guaranteed to exist for MMIO.

Of course, most platforms either provide (in|out){b,w,l} or don't support
Port IO as well, but MMIO is the really complicated case.

In any event, <asm-generic/iomap.h> should shed a bit more light on using
these.

Cheers,
	Kyle M.
