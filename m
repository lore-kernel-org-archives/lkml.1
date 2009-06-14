Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbZFNOlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbZFNOlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 10:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZFNOkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 10:40:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:65486 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbZFNOkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 10:40:51 -0400
MIME-Version: 1.0
In-Reply-To: <1244765062-14144-3-git-send-email-w.sang@pengutronix.de>
References: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de> 
	<1244765062-14144-3-git-send-email-w.sang@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 14 Jun 2009 08:40:34 -0600
Message-ID: <fa686aa40906140740m43e9dd8am4d242310f681c95c@mail.gmail.com>
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@ozlabs.org,
       "Hans J. Koch" <hjk@linutronix.de>, Magnus Damm <magnus.damm@gmail.com>,
       linuxppc-dev@ozlabs.org, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 6:04 PM, Wolfram Sang<w.sang@pengutronix.de> wrote:
> Picking up the now exported generic probe function from the
> platform-variant of this driver, this patch adds an of-version. Also add
> the binding documentation.
>
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Cc: Hans J. Koch <hjk@linutronix.de>
> Cc: Greg KH <gregkh@suse.de>
> ---
>
> In probe, I put the resources-array on the stack to simplify the code. If this
> is considered too huge for the stack (140 byte for a 32-bit system at the
> moment), I can also post a version using kzalloc.
>
>  Documentation/powerpc/dts-bindings/uio-generic.txt |   16 +++
>  drivers/uio/Kconfig                                |    6 +
>  drivers/uio/Makefile                               |    1 +
>  drivers/uio/uio_of_genirq.c                        |   98 ++++++++++++++++++++
>  4 files changed, 121 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/powerpc/dts-bindings/uio-generic.txt
>  create mode 100644 drivers/uio/uio_of_genirq.c
>
> diff --git a/Documentation/powerpc/dts-bindings/uio-generic.txt b/Documentation/powerpc/dts-bindings/uio-generic.txt
> new file mode 100644
> index 0000000..8ad9861
> --- /dev/null
> +++ b/Documentation/powerpc/dts-bindings/uio-generic.txt
> @@ -0,0 +1,16 @@
> +UIO for custom devices
> +
> +A device which will be mapped using the UIO subsystem.
> +
> +Properties:
> + - compatible : should contain the specific model used, followed by
> +                "generic-uio".
> + - reg : address range(s) of the device (up to MAX_UIO_MAPS)
> + - interrupts : interrupt of the device
> +
> +Example:
> +        c64fpga@0 {
> +                compatible = "ptx,c64fpga001", "generic-uio";
> +                reg = <0x0 0x10000>;
> +                interrupts = <0 0 3>;
> +        };

Hmmm, I'm not happy about this.  The device tree describes the
hardware, not the way Linux uses the hardware.  UIO definitely falls
into the category of Linux implementation detail.

This should be approached from the other way around.  Either the
generic-uio of_platform driver should contain an explicit list of
devices to be handled by UIO, or the OF infrastructure should be
modified to allow things like force binding of_devices to of_drivers
at runtime.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
