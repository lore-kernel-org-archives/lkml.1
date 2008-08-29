Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbYH2PnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbYH2PnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYH2PnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:43:07 -0400
Received: from isuela.unizar.es ([155.210.1.53]:49582 "EHLO isuela.unizar.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbYH2PnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:43:06 -0400
Message-Id: <1556548A-8DD1-4212-BBEB-9AB34280854E@ono.com>
From: "=?ISO-8859-1?Q?=22J.A._Magall=F3n=22?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1D3903ED-3FEB-4E12-B1A9-269C5B73012F@ono.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: Unhiding devices in pci bus
Date: Fri, 29 Aug 2008 17:43:04 +0200
References: <1D3903ED-3FEB-4E12-B1A9-269C5B73012F@ono.com>
X-Mailer: Apple Mail (2.926)
X-Mail-Scanned: Criba 2.0 + Clamd & Bogofilter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2008.08.29, at 16:36, J.A. Magallón wrote:

> Hi all...
>
> I have an Aspire One, and the JMicron SD Card reader is hidden from  
> sysfs
> space, it only shows if I do an lspci -H1 (direct hardware access):
> ...
> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI  
> Express Port 1 (rev 02)
> 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI  
> Express Port 2 (rev 02)
> 00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI  
> Express Port 3 (rev 02)
> 00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI  
> Express Port 4 (rev 02)
> ...

Forgot to say that this only happens after you have inserted a card
once. You can then remove it and the device stays there.
Unfortunately I can't boot with the card in, because udev hangs
forever on boot...

>
> 04:00.0 System peripheral: JMicron Technologies, Inc. Device 2382
> 04:00.2 SD Host controller: JMicron Technologies, Inc. Device 2381
> 04:00.3 System peripheral: JMicron Technologies, Inc. Device 2383
> 04:00.4 System peripheral: JMicron Technologies, Inc. Device 2384
>
> one:~# lspci -t
> -[0000:00]-+-00.0
>           +-02.0
>           +-02.1
>           +-1b.0
>           +-1c.0-[0000:01]--
>           +-1c.1-[0000:02]----00.0
>           +-1c.2-[0000:03]----00.0
>           +-1c.3-[0000:04]--
>           +-1d.0
>           +-1d.1
>           +-1d.2
>           +-1d.3
>           +-1d.7
>           +-1e.0-[0000:05]--
>           +-1f.0
>           +-1f.2
>           \-1f.3
>
> one:~# lspci -H1 -t
> -[0000:00]-+-00.0
>           +-02.0
>           +-02.1
>           +-1b.0
>           +-1c.0-[0000:01]--
>           +-1c.1-[0000:02]--
>           +-1c.2-[0000:03]----00.0
>           +-1c.3-[0000:04]--+-00.0
>           |                 +-00.2
>           |                 +-00.3
>           |                 \-00.4
>           +-1d.0
>           +-1d.1
>           +-1d.2
>           +-1d.3
>           +-1d.7
>           +-1e.0-[0000:05]--
>           +-1f.0
>           +-1f.2
>           \-1f.3
>
> lspci -M:
>
> ...
> 00: Primary host bus
> 	1e.0 Bridge to 05-05
> 	1c.3 Bridge to 04-04
> 	1c.2 Bridge to 03-03
> 	1c.1 Bridge to 02-02
> 	1c.0 Bridge to 01-01
> ...
>
> If I load the driver (sdhci), it does not detect anything. It looks  
> like
> it is hidden/hung after one of the pci bridges, how can I make this  
> device
> visible for the driver ?
>
> Thanks.
>
> --
> J.A. Magallon <jamagallon()ono!com>     \               Software is  
> like sex:
>                                         \         It's better when  
> it's free
> Mandriva Linux release 2009.0 (Cooker) for i586
> Linux 2.6.25-jam13 (gcc 4.3.1 20080515 (GCC) #1 SMP
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
J.A. Magallon <jamagallon()ono!com>     \               Software is  
like sex:
                                          \         It's better when  
it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam13 (gcc 4.3.1 20080515 (GCC) #1 SMP



