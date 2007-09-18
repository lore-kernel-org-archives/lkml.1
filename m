Return-Path: <linux-kernel-owner+w=401wt.eu-S1761100AbXIRRr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100AbXIRRr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbXIRRrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:47:18 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1748 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbXIRRrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:47:17 -0400
X-Server-Uuid: 20144BB6-FB76-4F11-80B6-E6B2900CA0D7
Subject: Re: bnx2 dirver's firmware images
From: "Michael Chan" <mchan@broadcom.com>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
cc: linux-kernel@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <200709181823.26429.vda.linux@googlemail.com>
References: <200709181823.26429.vda.linux@googlemail.com>
Date: Tue, 18 Sep 2007 11:45:14 -0700
Message-ID: <1190141114.9540.216.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6AEED0914VK546711-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 18:23 +0100, Denys Vlasenko wrote:
> Hi Michael,
> 
> In bnx2_fw.h I see the following:
> 
> static u32 bnx2_RXP_b06FwBss[(0x13dc/4) + 1] = { 0x0 };
> 
> static struct fw_info bnx2_rxp_fw_06 = {
> ...
>         .bss                            = bnx2_RXP_b06FwBss,
> ...
> };
> 
> I grepped for the usage of .bss member (grepped for '[.>]bss[^_]')
> and it is used only here:
> 
>         if (fw->bss) {
>                 int j;
> 
>                 for (j = 0; j < (fw->bss_len/4); j++, offset += 4) {
>                         REG_WR_IND(bp, offset, fw->bss[j]);
>                 }
>         }
> 
> If I understand it correctly, you read zero words one by one from
> bnx2_RXP_b06FwBss and writing them into the card. This is very
> suboptimal usage of nearly 5k of kernel unswappable memory.
> 
> Do you plan to fix it?

We can compress all the different sections of the firmware.  Currently,
we only compress the biggest chunks and the rest are uncompressed.
These zeros should compress to almost nothing.  But I agree that the
firmware is still big.

> 
> Do you have any plans to switch to request_firmware() interface,
> which will allow you to avoid keeping firmware in unswappable kernel
> memory and thus free ~80k?

Matching the correct version of the firmware with the driver is the main
issue.

David, what's your opinion on this?

> 
> $ size bnx2.o
>    text    data     bss     dec     hex filename
>   52255   81551    6360  140166   22386 bnx2.o
> --
> vda
> 

