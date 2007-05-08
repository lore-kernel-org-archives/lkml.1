Return-Path: <linux-kernel-owner+w=401wt.eu-S1032035AbXEHUM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032035AbXEHUM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968261AbXEHUMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:12:22 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:42364 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967846AbXEHUMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:12:21 -0400
Message-ID: <4640D988.1040504@freescale.com>
Date: Tue, 08 May 2007 15:11:52 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       =?ISO-8859-1?Q?Ismail_D=F6nmez?= <ismail@pardus.org.tr>,
       Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Kconfig warnings on latest GIT
References: <200705080004.14570.ismail@pardus.org.tr> <20070508143127.38fafa3c.kim.phillips@freescale.com>
In-Reply-To: <20070508143127.38fafa3c.kim.phillips@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kim Phillips wrote:
> On Tue, 8 May 2007 00:04:14 +0300
> Ismail Dönmez <ismail@pardus.org.tr> wrote:
> 
>> drivers/net/Kconfig:2279:warning: 'select' used by config symbol 'UCC_GETH' 
>> refers to undefined symbol 'UCC_FAST'
> 
> looks like this introduces the error:
> 
> commit 7d776cb596994219584257eb5956b87628e5deaf
> Author: Timur Tabi <timur@freescale.com>
> Date:   Mon Mar 12 15:40:27 2007 -0500
> 
>     [POWERPC] QE: automatically select QE options

I have a dilemma, so I need help fixing this bug.

This particular patch is necessary because without it, selecting support for the QE is too 
complicated.

Background: The QUICC Engine (QE) is a microcontroller on some Freescale CPUs that can 
mimic a wide variety of devices.  It has multiple controllers (called UCCs), and each one 
can be an ethernet device, or a UART, or an HDLC thingy, etc.  There's a QE library and a 
bunch of other support code in the arch/powerpc directory, so the QE is a powerpc-specific 
device.  However, all of the drivers that use it are located in drivers/xxx.

This isn't a new problem.  The common solution is to define some intermediate Kconfig 
option, like UCC_FAST_TEMP in the driver's Kconfig.  Selecting UCC_FAST will then also set 
UCC_FAST_TEMP.  The device driver then depends on UCC_FAST_TEMP.

There's also a UCC_SLOW option with the same problem.

The dillema is that there is no single device driver class that depends on UCC_FAST. 
Currently, there's only one that uses UCC_FAST: the ucc_geth driver.  But I'm also working 
on a UART driver.

So my question is: in which Kconfig do I define "UCC_FAST_TEMP" and "UCC_SLOW_TEMP"?  At 
first I thought, just put it in drivers/Kconfig, but that Kconfig does nothing but 
including other Kconfigs.  I believe that if I submit a patch that adds "UCC_FAST_TEMP" 
and "UCC_SLOW_TEMP" to drivers/Kconfig, it will be rejected.  Either that, or I'll spend 
six weeks trying to persuade everyone that it's a good idea.

Does anyone have any suggestions on how I can fix this?

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
