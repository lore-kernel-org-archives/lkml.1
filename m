Return-Path: <linux-kernel-owner+w=401wt.eu-S1760585AbZCUHqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbZCUHqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 03:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbZCUHqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 03:46:09 -0400
Received: from smtp11.m3.home.ne.jp ([220.152.44.17]:58239 "EHLO
	smtp11.m3.home.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbZCUHqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 03:46:09 -0400
Message-Id: <200903210747.AA00743@cj3020122-b.jcom.home.ne.jp>
From: yamazaki <yamazaki-seiji@jcom.home.ne.jp>
Date: Sat, 21 Mar 2009 16:47:47 +0900
To: avorontsov@ru.mvista.com
Cc: sdhci-devel@list.drzeus.cx, Arnd Bergmann <arnd@arndb.de>,
       Liu Dave <DaveLiu@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Ben Dooks <ben-linux@fluff.org>,
       Pierre Ossman <drzeus-sdhci@drzeus.cx>
Subject: Re: [PATCH 11/11] mmc: Add OpenFirmware bindings for SDHCI driver
In-Reply-To: <20090321004506.GA13031@oksana.dev.rtsoft.ru>
References: <20090321004506.GA13031@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.12
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

Thank you for your reply again.

>Ah, then it must be connected via MPC8347's localbus.

That's right.

I will try it,and I inform them of the result. 

>On Sat, Mar 21, 2009 at 09:15:25AM +0900, yamazaki wrote:
>> Hi 
>> 
>> Thank you for your reply.
>> I know RICOH has PCI SD/MMC controller. But R5C807 RICOH is not the PCI device
>> which is probably new product.
>
>Ah, then it must be connected via MPC8347's localbus.
>
>Well, then you need 2.6.29-rcX kernels, for example
>http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc8.tar.bz2
>is suitable.
>
>Untar it and apply the patches (they'll apply fine on that
>kernel). Then you'll need some device tree additions for
>your MPC8347 board, something like this:
>
>        localbus@e0005000 {
>                #address-cells = <2>;
>                #size-cells = <1>;
>                compatible = "fsl,mpc8347-localbus",
>                             "fsl,pq2pro-localbus";
>                reg = <0xe0005000 0xd8>;
>                ranges = <0x1 0x0 0xf0000000 0x1000>;
>		// ^^ change the 0xf0000000 to the actual address
>                sdhci@1,0 {
>                        compatible = "ricoh,r5c807", "generic-sdhci";
>                        reg = <0x1 0x0 0x1000>;
>                        interrupts = <ricoh-interrupt-here 0x8>;
>                        interrupt-parent = <&ipic>;
>                        // if needed, clock-frequency = <freq-in-HZ-here>;
>                };
>        };
>
>Note that I'm not sure what endiannes you'll get when connecting
>the ricoh chip to the big-endinan host...
>
>-- 
>Anton Vorontsov
>email: cbouatmailru@gmail.com
>irc://irc.freenode.net/bd2

----
yamazaki-seiji@jcom.home.ne.jp
