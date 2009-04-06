Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbZDFOU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbZDFOU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 10:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbZDFOUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 10:20:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:49796 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654AbZDFOUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:20:46 -0400
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@gmail.com>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <4A6C5BFC-C079-4D19-A0FC-992DF2DCF6B4@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <20090404183120.GA21671@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] fsl-diu-fb: Pass the proper device for dma mapping routines
Date: Mon, 6 Apr 2009 09:16:00 -0500
References: <20090404183120.GA21671@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 4, 2009, at 1:31 PM, Anton Vorontsov wrote:

> The driver should pass a device that specifies internal DMA ops, but
> currently NULL pointers are passed, and thus following bug pops up:
>
>  Freescale DIU driver
>  ------------[ cut here ]------------
>  kernel BUG at arch/powerpc/include/asm/dma-mapping.h:237!
>  Oops: Exception in kernel mode, sig: 5 [#1]
>  ...
>  NIP [c01658b4] allocate_buf+0x0/0x8
>  LR [c0306554] fsl_diu_probe+0x2b4/0x518
>  Call Trace:
>  [df02be10] [c030638c] fsl_diu_probe+0xec/0x518 (unreliable)
>  [df02be60] [c020cdec] of_platform_device_probe+0x5c/0x84
>  [df02be80] [c018f5d0] really_probe+0x78/0x1a0
>  [df02bea0] [c018f7c0] __driver_attach+0xa4/0xa8
>  [df02bec0] [c018ea00] bus_for_each_dev+0x60/0x9c
>  [df02bef0] [c018f414] driver_attach+0x24/0x34
>  [df02bf00] [c018f168] bus_add_driver+0x12c/0x1cc
>  [df02bf20] [c018fbdc] driver_register+0x6c/0x110
>  [df02bf30] [c020ccb4] of_register_driver+0x54/0x70
>  [df02bf40] [c03d0a50] fsl_diu_init+0x70/0xa4
>  ...
>
> This patch fixes the issue.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> drivers/video/fsl-diu-fb.c |   34 +++++++++++++++++++++-------------
> 1 files changed, 21 insertions(+), 13 deletions(-)

applied

- k
