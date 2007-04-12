Return-Path: <linux-kernel-owner+w=401wt.eu-S1945910AbXDLGOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945910AbXDLGOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 02:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945911AbXDLGOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 02:14:12 -0400
Received: from hoemail1.lucent.com ([192.11.226.161]:42100 "EHLO
	hoemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945910AbXDLGOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 02:14:11 -0400
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2007 02:14:11 EDT
Message-ID: <461DCC3E.9020900@alcatel-lucent.com>
Date: Thu, 12 Apr 2007 14:05:50 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: help me on 2.6.15 kernel on MPC850
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Apr 2007 06:05:30.0964 (UTC) FILETIME=[93484940:01C77CC8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Guys,

The CPU was spinning when executing in head_8xx.S::initial_mmu. I have 
located the instruction that cause the spinning through on-board leds. 
Do you have any ideas?

#ifdef CONFIG_8xx_COPYBACK
       mtspr   SPRN_DC_CST, r8                                     <<< 
The spinning was caused by this instruction
#endif

#else
       /*
        * For a debug option, I left this here to easily enable
        * the write through cache mode
        */
       lis     r8, DC_SFWT@h
       mtspr   SPRN_DC_CST, r8
       lis     r8, IDC_ENABLE@h
       mtspr   SPRN_DC_CST, r8
#endif

       blr

-----------------------------

The output from u-boot:

=> tftp 0x100000 uImage
Using SCC ETHERNET device
TFTP from server 90.0.0.3; our IP address is 90.0.0.50
Filename 'uImage'.
Load address: 0x100000
Loading: #################################################################
        #################################################################
        ###################################
done
Bytes transferred = 844738 (ce3c2 hex)
=> bootm
## Booting image at 00100000 ...
  Image Name:   Linux-2.6.15
  Created:      2007-04-07  17:25:29 UTC
  Image Type:   PowerPC Linux Kernel Image (gzip compressed)
  Data Size:    844674 Bytes = 824.9 kB
  Load Address: 00000000
  Entry Point:  00000000
  Verifying Checksum ... OK
  Uncompressing Kernel Image ... OK               <<< The CPU is 
spinning then

-----------------------------

The hardware, bootloader, linux I'm using:

1) MPC850, 1KB DCache + 2KB ICache
2) u-boot 1.1.4 ( Data Cache is turned off all the way, but instruction 
cache is always on)
3) ppclinux 2.6.15

Thanks,
Gavin

