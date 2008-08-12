Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbYHLAJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbYHLAJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 20:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbYHLAI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 20:08:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562AbYHLAI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 20:08:57 -0400
Date: Mon, 11 Aug 2008 17:08:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH RESEND] agp: fix SIS 5591/5592 wrong PCI id
Message-Id: <20080811170803.0f3f5df9.akpm@linux-foundation.org>
In-Reply-To: <20080810225452.48ab9fd1.krzysztof.h1@wp.pl>
References: <20080810225452.48ab9fd1.krzysztof.h1@wp.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008 22:54:52 +0200
Krzysztof Helt <krzysztof.h1@wp.pl> wrote:

> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> The correct id for the AGP bridge is the id of 
> the main host (5591) not the id of the PCI-to-PCI
> bridge AGP (0001). Output from "lspci -nv" shows 
> that only the former has AGP capabilities flag set:
> 
> 00:00.0 0600: 1039:5591 (rev 02)
>         Flags: bus master, medium devsel, latency 64
>         Memory at ec000000 (32-bit, non-prefetchable) [size=32M]
>         Capabilities: [c0] AGP version 1.0
> 
> 00:02.0 0604: 1039:0001 (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>         I/O behind bridge: 0000c000-0000cfff
>         Memory behind bridge: eb500000-eb5fffff
>         Prefetchable memory behind bridge: eb300000-eb3fffff
> 
> 
> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> ---
> 
> The AGP bridge is correctly detected with the patch applied.
> I have tested it on PC Chips M570 motherboard.
> 
> --- linux-mm/drivers/char/agp/sis-agp.c~	2008-08-04 18:00:31.133979040 +0200
> +++ linux-mm/drivers/char/agp/sis-agp.c	2008-08-06 18:33:02.162916563 +0200
> @@ -241,7 +241,7 @@ static struct pci_device_id agp_sis_pci_
>  		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
>  		.class_mask	= ~0,
>  		.vendor		= PCI_VENDOR_ID_SI,
> -		.device		= PCI_DEVICE_ID_SI_5591_AGP,
> +		.device		= PCI_DEVICE_ID_SI_5591,
>  		.subvendor	= PCI_ANY_ID,
>  		.subdevice	= PCI_ANY_ID,
>  	},

This fix appears to be applicable to both 2.6.25.x and to 2.6.26.x.  Do you
think that the problem which it solves is sufficiently serious to
warrant the backport?

Thanks.
