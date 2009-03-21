Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbZCUAp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbZCUAp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 20:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbZCUApK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 20:45:10 -0400
Received: from [213.79.90.228] ([213.79.90.228]:42264 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752287AbZCUApJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 20:45:09 -0400
Date: Sat, 21 Mar 2009 03:45:06 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: yamazaki <yamazaki-seiji@jcom.home.ne.jp>
Cc: sdhci-devel@list.drzeus.cx, Arnd Bergmann <arnd@arndb.de>,
       Liu Dave <DaveLiu@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Ben Dooks <ben-linux@fluff.org>,
       Pierre Ossman <drzeus-sdhci@drzeus.cx>
Subject: Re: [PATCH 11/11] mmc: Add OpenFirmware bindings for SDHCI driver
Message-ID: <20090321004506.GA13031@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090320224330.GA23390@oksana.dev.rtsoft.ru> <200903210015.AA00742@cj3020122-b.jcom.home.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <200903210015.AA00742@cj3020122-b.jcom.home.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 09:15:25AM +0900, yamazaki wrote:
> Hi 
> 
> Thank you for your reply.
> I know RICOH has PCI SD/MMC controller. But R5C807 RICOH is not the PCI device
> which is probably new product.

Ah, then it must be connected via MPC8347's localbus.

Well, then you need 2.6.29-rcX kernels, for example
http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc8.tar.bz2
is suitable.

Untar it and apply the patches (they'll apply fine on that
kernel). Then you'll need some device tree additions for
your MPC8347 board, something like this:

        localbus@e0005000 {
                #address-cells = <2>;
                #size-cells = <1>;
                compatible = "fsl,mpc8347-localbus",
                             "fsl,pq2pro-localbus";
                reg = <0xe0005000 0xd8>;
                ranges = <0x1 0x0 0xf0000000 0x1000>;
		// ^^ change the 0xf0000000 to the actual address
                sdhci@1,0 {
                        compatible = "ricoh,r5c807", "generic-sdhci";
                        reg = <0x1 0x0 0x1000>;
                        interrupts = <ricoh-interrupt-here 0x8>;
                        interrupt-parent = <&ipic>;
                        // if needed, clock-frequency = <freq-in-HZ-here>;
                };
        };

Note that I'm not sure what endiannes you'll get when connecting
the ricoh chip to the big-endinan host...

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
