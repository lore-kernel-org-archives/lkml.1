Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbXFWO2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbXFWO2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 10:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbXFWO2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 10:28:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52016 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123AbXFWO2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 10:28:32 -0400
Message-ID: <467D2E0E.1010600@anagramm.de>
Date: Sat, 23 Jun 2007 16:28:30 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Clifford Wolf <clifford@clifford.at>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Mem-2-Mem DMA - Generalized API (MPC8349E)
References: <20070623081615.GE5829@clifford.at>
In-Reply-To: <20070623081615.GE5829@clifford.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/IU20Wl1xl7tpUMd4OG9x/keengID1EUcjXsJ
 9cHzBYkQIb8K2Kpwt57Nr/ZnnxhUg6JUPeNXSOBnBv2XPBvats
 NUwlWxc9aRtdNHqdplR5A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Clifford!

Clifford Wolf schrieb:
> I'm curently working on an embedded project using the Freescale MPC8349E
> microcontroller (PPC e300 core + almost everything one needs for
> communicating with the rest of the world on one ~100$ chip).

Yes. These embedded CPU's are discussed more in detail in the
linux-ppc-embedded mailing list. See:
https://ozlabs.org/mailman/listinfo/linuxppc-embedded
Let's please move the implementation details to that list.

> I doubt that the MPC8349E is the only device out there with such a DMA
> controller and so I was looking for a generalized kernel API for working
> with such DMA controllers to add MPC8349E support to it (since grepping
> the kernel for the register addresses didn't show up any usefull results
> I assume that there is no existing implementaion).

I am using the MPC8540 and (re-)wrote a DMA driver to copy bulk image data
from a local bus FPGA to the dram memory. So, it's a proprietary driver
which can be published, but I think it doesn't make sense to have that
code in the kernel because it's only useful with exaxtly this one hardware
environment.

> Has anyone thought already about an API fur such a generic kernel
> framework? I was thinking about a 'copy using DMA if possible' function
> which is first sleeping until a DMA channel gets free, then reprograms
> this channel and again sleeps until the DMA transfer has been finished.

Please checkout the linux/Documentation/DMA* documents.
I don't know if it makes sense to do a *generic* implementation without
limitations in functionality and safety.

> The MPC8349E has scatter-gather features for source and destination and can
> eighter increment the source/destination addresses during the transfer or
> run in (8, 16 or 32 bit) fifo mode. So it is a bit more complicated than
> a 'memcpy on bus addresses which may sleep'.
> Extending the request_dma() - free_dma() API looks like the wrong way to go
> on this issue. It is afaics designed for a compleatly diffrent kind of DMA
> controller.

The scatter-gather setup implementation is working fine on my platform.
After setup/start of the DMA engine, I can poll some progress information
during the transfer to start processing of the data while the DMA machine still
sucks some more data in. At the end of the sg list, I get an interrupt and
the DMA channel is free again. Several (4) concurrent transfers should be
possible with this setup. However, some DMA-channel scheduling needs to be
implemented and made available in a generic kernel (or even userspace)
interface.

Regards,
-- 
Clemens Koller
_______________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Str. 45/1
81379 Muenchen
Germany

http://www.anagramm-technology.com
Phone: +49-89-741518-50
Fax: +49-89-741518-19
