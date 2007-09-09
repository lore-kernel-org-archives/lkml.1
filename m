Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbXIIVsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbXIIVsD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 17:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbXIIVry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 17:47:54 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:56474 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbXIIVry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 17:47:54 -0400
Message-ID: <46E46A3F.2050708@freescale.com>
Date: Sun, 09 Sep 2007 16:48:47 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: Zhang Wei <wei.zhang@freescale.com>, shannon.nelson@intel.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx	processors.
References: <11891624582950-git-send-email-wei.zhang@freescale.com> <e9c3a7c20709091053u607e710ay1eb76c53312706ea@mail.gmail.com>
In-Reply-To: <e9c3a7c20709091053u607e710ay1eb76c53312706ea@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:

> This routine implies that there is a piece of code somewhere that
> wants to select which channels it can use.  A similar effect can be
> achieved by registering a dma_client with the dmaengine interface
> ('dma_async_client_register').  Then when the client code makes a call
> to 'dma_async_client_chan_request' it receives a 'dma_event_callback'
> for each channel in the system.  It will also be asynchronously
> notified of channels entering and leaving the system.  The goal is to
> share a common infrastructure for channel management.

Are you familiar with the "flat device tree" used for PowerPC systems?  The 
"piece of code somewhere" is the device tree subsystem that parses the device 
tree, which is compiled from the .dts files in arch/powerpc/boot/dts.

The FDT is how PowerPC systems specify hardware configuration.  In the case of 
85xx, the FDT contains entries for each DMA device (typically 2), and the 
entries contain sub-entries for each DMA channel as well as the address of the 
register sets for each channel.

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
