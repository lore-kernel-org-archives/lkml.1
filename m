Return-Path: <linux-kernel-owner+w=401wt.eu-S933688AbXEGN3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688AbXEGN3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 09:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbXEGN3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 09:29:11 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:39475 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933688AbXEGN3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:29:10 -0400
X-Greylist: delayed 1746 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2007 09:29:10 EDT
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <m3vef5biob.fsf@maximus.localdomain>
References: <m3abwhcy74.fsf@maximus.localdomain> <m3vef5biob.fsf@maximus.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5BB7E1AB-5CE1-43C8-8CE3-E0DE0236BD09@cam.ac.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Russell King <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [PATCH 3/3] Intel IXP4xx network drivers
Date: Mon, 7 May 2007 13:59:26 +0100
To: Krzysztof Halasa <khc@pm.waw.pl>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2007, at 01:07, Krzysztof Halasa wrote:

> Adds IXP4xx drivers for built-in CPU components:
> - hardware queue manager
> - NPE (network coprocessors),
> - Ethernet ports,
> - HSS (sync serial) ports (currently only non-channelized HDLC).
>
> Both Ethernet and HSS drivers use queue manager and NPE driver and
> require external firmware file(s) available from www.intel.com.
>
> "Platform device" definitions for Ethernet ports on IXDP425  
> development
> platform are provided (though it has been tested on not yet available
> IXP425-based hardware only)
>
> Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>

Immediate comments as follows:

(Krzysztof has already seen them in a private email but I'm putting  
them out so people can publically disagree with me if I have got this  
wrong.)

Code placement:
Queue Manager & NPE code => arch/arm/mach-ixp4xx
WAN driver code => drivers/net/wan
Eth code => drivers/net/arm

Kconfig:
I'm not convinced about 'config IXP4XX_NETDEVICES'. I'd lose it  
together with the drivers/net/ixp4xx directory
Ethernet & HSS code should probably select NPE and QMGR (rather than  
depend) but these options should still be exposed in arch/arm/mach- 
ixp4xx/Kconfig

Michael-Luke Jones

PS: Please cc me on replies as I only subscribe to l-a-k.
