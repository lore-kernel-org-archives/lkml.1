Return-Path: <linux-kernel-owner+w=401wt.eu-S933488AbYBHJKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbYBHJKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 04:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759982AbYBHJKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 04:10:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:22487 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759967AbYBHJKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 04:10:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rewuM0JsabsaYkrxLS11bgAVHDjDM5YWeAjQfiMt5QxPe+MoQZnKQgnhsq54sZsvkhQ2tgH8E/0b0PgTCtdsdAy5bhYi5eFZ2/sVWEl2QPqftAsf1XRK+720joCJkMC3DnsvtOqDqBbPAB9nm9RwljURCRB6YHYtYp6GLJWIPQk=
Message-ID: <47AC1C6E.1090101@gmail.com>
Date: Fri, 08 Feb 2008 10:10:06 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
CC: grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Xilinx: hwicap driver
References: <47AB6552.7040503@gmail.com> <20080208021747.92253161805C@mail10-sin.bigfish.com>
In-Reply-To: <20080208021747.92253161805C@mail10-sin.bigfish.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2008 03:17 AM, Stephen Neuendorffer wrote:
> This includes code for new fifo-based xps_hwicap in addition to the
> older opb_hwicap, which has a significantly different interface.  The
> common code between the two drivers is largely shared.
> 
> Significant differences exists between this driver and what is
> supported in the EDK drivers.  In particular, most of the
> architecture-specific code for reconfiguring individual FPGA resources
> has been removed.  This functionality is likely better provided in a
> user-space support library.  In addition, read and write access is
> supported.  In addition, although the xps_hwicap cores support
> interrupt-driver mode, this driver only supports polled operation, in
> order to make the code simpler, and since the interrupt processing
> overhead is likely to slow down the throughput under Linux.
> 
> Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
> 
> Fixed to add mutexes, and a few style issues.
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> The final update to xilinx_hwicap.h was missing.
> 
> fix some missing __user tags and incorrect section tags.
> convert semaphores to mutexes.
> make probed_devices re-entrancy and error condition safe.
> fix some backwards memcpys.
> some other minor cleanups.

Looks good to me.

> Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
> ---
[...]
> diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
> new file mode 100644
> index 0000000..2caac31
> --- /dev/null
> +++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
> @@ -0,0 +1,923 @@
[...]
> +module_param(xhwicap_major, int, S_IRUGO);
> +module_param(xhwicap_minor, int, S_IRUGO);
> +
> +/* An array, which is set to true when the device is registered. */
> +static bool probed_devices[HWICAP_DEVICES];
> +static struct mutex icap_sem;

Just a sideway note, static DEFINE_MUTEX(icap_sem); and you don't need to 
runtime init it then.

