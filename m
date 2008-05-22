Return-Path: <linux-kernel-owner+w=401wt.eu-S932258AbYEVLnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbYEVLnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757720AbYEVLmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:42:52 -0400
Received: from eracle.polito.it ([130.192.3.44]:43053 "EHLO polito.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756838AbYEVLmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:42:51 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 May 2008 07:42:51 EDT
X-ExtScanner: Niversoft's FindAttachments (free)
Message-ID: <48354E2B.8010003@libero.it>
Date: Thu, 22 May 2008 12:42:51 +0200
From: Fabio Tosetto <tosettofabio83@libero.it>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: avorontsov@ru.mvista.com, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, galak@kernel.crashing.org,
       garyj@denx.de, g.liakhovetski@gmx.de
Subject: SD-MMC over SPI on PSC6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I have an embedded system with an on-board processor powerpc 
MPC5200B
and Linux kernel 2.6.22,
I must turn over to MMC SPI on the PSC6.

The MMC over SPI is connected to MPC5200b, here's how:

  MPC5200B
----------------                                        
                       
|                                                                 
|------------------
         PSC1_2 |--->------------Chip_Select (out)---------|      
                       
|                                                                 |
                       |                        
                                         |     SD CARD
         ETH_17 |---<------------IRQ (in)------------------|   MMC over SPI
                       |                                                
                 |
                       
|                                                                 |
         PSC6_0 |---<------------SPI_RXD (in)------------|
                       
|                                                                 |
                       
|                                                                 |
         PSC6_2 |--->------------SPI_TXD (out)-----------|
                       |                                                 
                |
                       |                                                 
                |
         PSC6_3 |--->------------SPI_CLK (out)-----------|
                       
|                                                                 
|------------------
----------------

Now on the menuconfig enabling these options:

$ make ARCH=powerpc CROSS_COMPILE=powerpc-linux-gnu- menuconfig

Platform support  --->
   [*] MPC5200 (L25R) bugfix support
   [*] Freescale Lite5200 Eval Board

Device Drivers  ---> SPI Support --->
   [*] SPI support
  <*> Freescale MPC52xx PSC SPI controller

Now I have applied those patch:
http://www.mail-archive.com/spi-devel-general@lists.sourceforge.net/msg00150.html

Now on the menuconfig enabling these options:

$ make ARCH=powerpc CROSS_COMPILE=powerpc-linux-gnu- menuconfig

Device Drivers  --->  MMC/SD card support --->
 [*] MMC debugging
<*> MMC block device driver
<*> MMC host test driver
<*> MMC/SD over SPI

Is correct applied those patch and enable those options into menuconfig?

thanks Fabio
