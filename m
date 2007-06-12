Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbXFLXEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbXFLXEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbXFLXEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:04:25 -0400
Received: from ip67-95-226-82.z226-95-67.customer.algx.net ([67.95.226.82]:1394
	"EHLO mail.micromemory.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756728AbXFLXEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:04:24 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jun 2007 19:04:24 EDT
Subject: Re: [PATCH 2/5] Add RapidIO sector to MPC8641HPCN board dts file.
From: Phil Terry <pterry@micromemory.com>
To: wei.zhang@freescale.com
Cc: mporter@kernel.crashing.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <11816389401714-git-send-email-wei.zhang@freescale.com>
References: <11816389393593-git-send-email-wei.zhang@freescale.com>
	 <1181638939310-git-send-email-wei.zhang@freescale.com>
	 <11816389401714-git-send-email-wei.zhang@freescale.com>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 15:58:32 -0700
Message-Id: <1181689112.9736.29.camel@pterry-fc6.micromemory.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: pterry@micromemory.com
X-Return-Path: pterry@micromemory.com
X-Envelope-From: pterry@micromemory.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: pterry@micromemory.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-12 at 17:02 +0800, Zhang Wei wrote:
> Add RapidIO sector to the MPC8641HPCN board dts file.
> 
> Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
> ---
>  arch/powerpc/boot/dts/mpc8641_hpcn.dts |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/boot/dts/mpc8641_hpcn.dts b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
> index 04626b1..e2ce06e 100644
> --- a/arch/powerpc/boot/dts/mpc8641_hpcn.dts
> +++ b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
> @@ -329,6 +329,19 @@
>  				>;
>  		};
>  
> +		srio@c0000 {
> +			device_type = "rapidio";
> +			compatible = "fsl,rapidio-v1.0";
> +			#address-cells = <2>;
> +			reg = <c0000 20000>;
> +			ranges = <0 0 c0000000 20000000>;

Don't understand the range setup... The code uses c0000000 as the start
and 20000000 as the size for the rapidio law. So whats the 0 0 for? 
At first I thought address-cells 2 means that the range numbers are
pairs expressing 64-bit numbers, eg start 0 0, size c0000000 20000000
but thats not right...

Sorry if I'm asking stupid questions....

And thanks for the patch, just what I need.

BTW do you have any notes/documentation on the space allocation routines
intended use. I'm trying to work it out but I don't see any actual users
of it yet... I need something like it for my distributed DMA driver,
hence the interest.

Cheers
Phil

> +			interrupt-parent = <&mpic>;
> +			/* err_irq bell_outb_irq bell_inb_irq
> +						msg1_tx_irq msg1_rx_irq
> +						msg2_tx_irq msg2_rx_irq */
> +			interrupts = <30 2 31 2 32 2 35 2 36 2 37 2 38 2>;
> +		};
> +
>  		mpic: pic@40000 {
>  			clock-frequency = <0>;
>  			interrupt-controller;


