Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbZELRPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbZELRPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbZELRNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:13:32 -0400
Received: from kroah.org ([198.145.64.141]:35211 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbZELRNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:13:30 -0400
Date: Tue, 12 May 2009 10:02:17 -0700
From: Greg KH <greg@kroah.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] usb_debug,usb_generic_serial: implement sysrq and
	serial break
Message-ID: <20090512170217.GL16247@kroah.com>
References: <1242073450-3794-1-git-send-email-jason.wessel@windriver.com> <1242073450-3794-2-git-send-email-jason.wessel@windriver.com> <1242073450-3794-3-git-send-email-jason.wessel@windriver.com> <1242073450-3794-4-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242073450-3794-4-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 03:24:09PM -0500, Jason Wessel wrote:
> The usb_debug driver was modified to implement serial break handling
> by using a "magic" data packet comprised of the sequence:
> 
>        0x00 0xff 0x01 0xfe   0x00 0xfe 0x01 0xff
> 
> When the tty layer requests a serial break the usb_debug driver sends
> the magic packet.  On the receiving side the magic packet is thrown
> away or a sysrq is activated depending on what kernel .config options
> have been set.
> 
> The generic serial driver was modified as well as the usb serial
> headers to generically implement sysrq processing in the same way the
> non usb uart based drivers implement the sysrq handling.  This will
> allow other usb serial devices to implement sysrq handling as desired.
> 
> The new usb serial functions are named similarly and implemented
> similarly to the uart functions as follows:
> 
> usb_serial_handle_break <-> uart_handle_break
> usb_serial_handle_sysrq_char <-> uart_handle_sysrq_char
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  drivers/usb/serial/Kconfig     |    7 +++++++
>  drivers/usb/serial/generic.c   |   30 ++++++++++++++++++------------
>  drivers/usb/serial/usb_debug.c |   39 +++++++++++++++++++++++++++++++++++++++
>  include/linux/usb/serial.h     |   34 ++++++++++++++++++++++++++++++++--
>  4 files changed, 96 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
> index c480ea4..3229321 100644
> --- a/drivers/usb/serial/Kconfig
> +++ b/drivers/usb/serial/Kconfig
> @@ -42,6 +42,13 @@ config USB_SERIAL_CONSOLE
>  
>  	  If unsure, say N.
>  
> +config USB_SERIAL_SYSRQ
> +       bool "Support inbound sysrq"
> +       depends on USB_SERIAL_CONSOLE && MAGIC_SYSRQ
> +       help
> +         Say y here to enable support for sysrq if the usb serial
> +         driver implements support for sysrq.
> +

I took this Kconfig option out, as it would just be confusing.  Just
always enable this, and if a driver wants to support it, it can, no need
for ifdefs or anything else.

thanks,

greg k-h
