Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbZFVNtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbZFVNtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZFVNto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:49:44 -0400
Received: from mga06.intel.com ([134.134.136.21]:6378 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754439AbZFVNtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:49:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,268,1243839600"; 
   d="scan'208";a="526763696"
Message-ID: <4A3F8BF7.6010406@linux.intel.com>
Date: Mon, 22 Jun 2009 15:49:43 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend
 to 	disk, mce related?
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>	 <4A3E7F38.7030300@linux.intel.com>	 <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com>	 <4A3EE668.5090400@jp.fujitsu.com>	 <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>	 <4A3F55C7.4030909@linux.intel.com>	 <8db1092f0906220453k5595998er1400567cbcdf3e12@mail.gmail.com>	 <4A3F7A93.5080004@linux.intel.com> <8db1092f0906220627w61d9f97g88c91f770f732f03@mail.gmail.com>
In-Reply-To: <8db1092f0906220627w61d9f97g88c91f770f732f03@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> [   68.287417] ata2.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
> [   68.290331] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
> [   68.302257] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
> [   68.324357] ata1.00: configured for UDMA/133
> [   69.656127] btusb 4-1:1.0: no reset_resume for driver btusb?
> [   70.708015] usb 5-2: reset low speed USB device using uhci_hcd and address 3
> 
> It seems, that resume isn't resume completely.

The USB reset messages are normally not serious

> 
> 
> Also I try 20 seconds and find this in netconsole:
> [  532.576128] BUG: soft lockup - CPU#1 stuck for 61s! [ksensors:2670]
> [  532.576128] Modules linked in: i915 drm i2c_algo_bit video
> backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit snd[
> 532.576128]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  532.576128]  [<c01a266d>] sys_read+0x3d/0x70

Hmm strange lockup in the VFS, but in sensors context. Might or might not
be related.

Here's a debug patch for the poller: http://firstfloor.org/ak/mcp-debug
Can you apply that and try again and send me the output?

Thanks,

-Andi
