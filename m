Return-Path: <linux-kernel-owner+w=401wt.eu-S1031084AbXDZO3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031084AbXDZO3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031050AbXDZO3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:29:00 -0400
Received: from h155.mvista.com ([63.81.120.155]:25673 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031055AbXDZO26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:28:58 -0400
Message-ID: <4630B789.3040402@ru.mvista.com>
Date: Thu, 26 Apr 2007 18:30:33 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Mike Mattie <codermattie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: htpt366 PCI latency value is really high
References: <20070426064927.13d0ed72@reforged>
In-Reply-To: <20070426064927.13d0ed72@reforged>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Mike Mattie wrote:

> while hunting down some latency problems I found something quite odd.
> The latency reported by lspci -v for the HTP203N card is enormous.

> 00:09.0 RAID bus controller: Triones Technologies, Inc. HPT302/302N
> (rev 02) Subsystem: Triones Technologies, Inc. Unknown device 0001
>         Flags: bus master, 66MHz, medium devsel, latency 120, IRQ 17
>         I/O ports at ec00 [size=8]
>         I/O ports at e800 [size=4]
>         I/O ports at e400 [size=8]
>         I/O ports at e000 [size=4]
>         I/O ports at dc00 [size=256]
>         Expansion ROM at dffe0000 [disabled by cmd] [size=128K]
>         Capabilities: [60] Power Management version 2

> I am assuming that the "latency" field here is the PCI latency timer
> which means this card is a bus hog. 

> From some reading on this issue linux methodically sets a sane value for 
> all the PCI cards it sets up, which looks normal on the rest of the system, 
> which is set to the value: 32

   Hm, I'm only seeing clamping to the smallest of 64 and pcibios_max_latency (255) in arch/i386/pci/i386.c if the latency value is too low... Which arch are you using?

> setting the value 32 with:

> setpci -v -s "00:09.0" latency_timer=32

> 00:09.0 RAID bus controller: Triones Technologies, Inc. HPT302/302N (rev 02)
>         Subsystem: Triones Technologies, Inc. Unknown device 0001
>         Flags: bus master, 66MHz, medium devsel, latency 48, IRQ 17
>         I/O ports at ec00 [size=8]
>         I/O ports at e800 [size=4]
>         I/O ports at e400 [size=8]
>         I/O ports at e000 [size=4]
>         I/O ports at dc00 [size=256]
>         Expansion ROM at dffe0000 [disabled by cmd] [size=128K]
>         Capabilities: [60] Power Management version 2

> Results in 48, which is not what I asked, but hopefully this is
> linux doing the right thing.

   Not sure -- seems likely that it's the chip's own enforced minimum instead...

> I know this chipset is pretty brain-damaged, but is this
> high latency value a work-around for broken hardware, or

   More like it.  Although HighPoint's own drivers force 64.

> just a oversight ?

   Not likely since the value is too "special"...

> Cheers,
> Mike Mattie - codermattie@gmail.com

WBR, Sergei
