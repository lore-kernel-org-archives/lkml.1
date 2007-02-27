Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784AbXB0Og0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbXB0Og0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXB0OgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:36:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:38460 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbXB0OgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:36:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iDgMfFOKKJxZBjqO/1k8+uhf8bnX7ZWRAUlNE8LNJiuTpBXh5YFKrbtrHZfHTywyLUNm7KCySMIZM7im5SiBkMoBmXfzYX4/7tpoejAB5YfJn5IhtijiZ04FGs5GrRKyX6LQAcy9Oh3lNZYlGm79u/lF0cG/ae/9IGZHDzuFjho=
Message-ID: <f19298770702270636j2c03f537je578768b33d95237@mail.gmail.com>
Date: Tue, 27 Feb 2007 17:36:22 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Kyle McMartin" <kyle@mcmartin.ca>
Subject: Re: ioread32 endianess.
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070227135535.GD3545@athena.road.mcmartin.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f19298770702260736i51622584r1979a202bdc64c1d@mail.gmail.com>
	 <20070226160450.GB3787@athena.road.mcmartin.ca>
	 <f19298770702270431i198e032fhe025e221a625140f@mail.gmail.com>
	 <20070227132021.GC3545@athena.road.mcmartin.ca>
	 <20070227135535.GD3545@athena.road.mcmartin.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/07, Kyle McMartin <kyle@mcmartin.ca> wrote:
> On Tue, Feb 27, 2007 at 08:20:21AM -0500, Kyle McMartin wrote:
> > PCI is always little endian, unless it's not. In which case you're probably
PCI is always LE, but the host may be different. If you read some data
from a PCI device
on a LE host, the data would be OK, but on a BE host, you may need to
swap it. Right?

More fun comes when you are doing DMA...

> > dealing with a graphics card which likely has some kind of palindromic
> > register which you can read and write to set the endianness of the host
> > interface. Whoo. Run on sentence.
> >
>
> Perhaps we should have a Documentation/ entry for this...
>
> io(read|write){8,16,32} are the "pci iomap" functions (see
> asm-generic/iomap.h) they always byteswap so the value is little endian.
They do even if the target bus is not little endian, right?

>
> io(read|write){8,16,32}be are sister functions added to deal with big
> endian busses. They always byteswap so the value is in big endian.
>
> Both these previous functions can handle using a cookie based on an IO port
> range, or an MMIO region.
>
> (read|write){b,w,l} are the old style MMIO-mapped accessors. They also always
> byteswap so the value is in little endian. There is no big endian equivalent
> for the generic case.
>
> __raw_(read|write){b,w,l} are also old style accessors. They always operate
> in host endianness.
>
> The above are (AFAIK) the only functions guaranteed to exist for MMIO.
>
> Of course, most platforms either provide (in|out){b,w,l} or don't support
> Port IO as well, but MMIO is the really complicated case.
>
> In any event, <asm-generic/iomap.h> should shed a bit more light on using
> these.
>
> Cheers,
>         Kyle M.
>
