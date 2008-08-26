Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYHZW4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYHZW4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYHZW4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:56:14 -0400
Received: from n4b.bullet.mail.ac4.yahoo.com ([76.13.13.74]:40618 "HELO
	n4b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751641AbYHZW4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:56:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 237336.64873.bm@omp120.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=doGZluWmddklxYSK754zYh2NNrwYxcQMGndVl2/HAk9nEbaLYAxcBXG1DyvPZUMdpLz//wmHjWNOpuszJxm6Fw7puO4FWrupykhsJShJHXdN3dJOq6gEDAjZ+Xf9zkCNy+TbHKaG2xOe1dNd6tgmWuUFSLoz43wnYAIQYV9Femo=;
X-YMail-OSG: X.QxZ1MVM1mLLNZ.Q9JbKHMJ4enMpkiE.BYmQoPjMBK3KcfTZ27SBCY_reum_5Xvsg2Ho_.7w0h1T.eTyVlfrUDHXO9S9Y10YvOni.MrPNBOc_UH2RdAxReixXx.e_pPFh9QCIbaWUQ8zvRD1q6LUog-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Tue, 26 Aug 2008 15:56:11 -0700 (PDT)
From: amruth <amruth_pv@yahoo.com>
Reply-To: amruth_pv@yahoo.com
Subject: USB Serial device disconnect causes IRQ disable after using ehci controller halted
To: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>
Cc: Karsten Wiese <fzu@wemgehoertderstaat.de>,
       Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
In-Reply-To: <200808261443.47064.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <434860.93444.qm@web45203.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Alan/David
This patch below does not fix the issue it just stops IRQ being disabled but still ehci hcd crashes. Please let me know what could be causing the issue.Is the hardware having any issue.
The log is below
[  552.905001] magtek 5-2:1.0: Magtek 75/Excella USB card reader converter detected
[  552.905001] /usr/src/linux-2.6.26/drivers/usb/serial/magtek.c: magtek_startup
[  552.905001] usb 5-2: link qh0-00ff/d8f44080 start 0 [1/0 us]
[  552.905001] /usr/src/linux-2.6.26/drivers/usb/serial/magtek.c: magtek_startup - usb_submit_urb(int urb)
[  552.905001] usb 5-2: Magtek 75/Excella USB card reader converter now attached to ttyUSB0
[  552.905001] drivers/usb/core/inode.c: creating file '006'
[  552.905001] usb 5-2: New USB device found, idVendor=0801, idProduct=2231
[  552.905001] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  552.905025] usb 5-2: Product: STX
[  552.905030] usb 5-2: Manufacturer: MagTek
[  552.905035] usb 5-2: SerialNumber: STX001
[  552.909786] ehci_hcd 0000:00:1d.7: irq status c028 masked 20
[  552.909793] ehci_hcd 0000:00:1d.7: hcd state 1
[  552.909796] ehci_hcd 0000:00:1d.7: hcd state 1
[  552.909799] ehci_hcd 0000:00:1d.7: hcd state 1
[  558.654520] ehci_hcd 0000:00:1d.7: irq status 600f masked 7
[  558.654520] ehci_hcd 0000:00:1d.7: hcd state 1
[  558.654520] ehci_hcd 0000:00:1d.7: devpath 2 ep2in 3strikes
[  558.654520] /usr/src/linux-2.6.26/drivers/usb/serial/magtek.c: magtek_read_int_callback - port 0
[  558.654520] /usr/src/linux-2.6.26/drivers/usb/serial/magtek.c: return!!
[  558.654520] /usr/src/linux-2.6.26/drivers/usb/serial/magtek.c: urb status is -71
[  558.654520] usb 5-2: unlink qh0-00ff/d8f44080 start 0 [1/0 us]
[  558.654520] usb 5-2: link qh0-00ff/d8f44080 start 0 [1/0 us]
[  558.654520] usb 5-2: unlink qh0-00ff/d8f44080 start 0 [1/0 us]
[  558.656520] ehci_hcd 0000:00:1d.7: handshake failed: controller halted
[  558.656520] ehci_hcd 0000:00:1d.7: force halt; handshake e0840824 00004000 00004000 -> -110
[  558.656520] Pid: 0, comm: swapper Not tainted 2.6.26patched #2
[  558.656520]  [<e0b1e5e7>] handshake_on_error_set_halt+0x82/0x8c [ehci_hcd]
[  558.656520]  [<e0b1e611>] disable_periodic+0x20/0x40 [ehci_hcd]
[  558.656520]  [<e0b1ffef>] ehci_work+0x5e6/0x6ad [ehci_hcd]
[  558.656520]  [<c0424230>] ? printk+0x15/0x17
[  558.656520]  [<e0b23cb9>] ehci_irq+0x28a/0x2fd [ehci_hcd]
[  558.656520]  [<e096905d>] ? cdrom_newpc_intr+0x52e/0x544 [ide_cd_mod]
[  558.656520]  [<c042addd>] ? lock_timer_base+0x1f/0x3e
[  558.656520]  [<c05764c4>] usb_hcd_irq+0x27/0x58
[  558.656520]  [<c044b852>] handle_IRQ_event+0x21/0x48
[  558.656520]  [<c044c9fb>] handle_fasteoi_irq+0x77/0xac
[  558.656520]  [<c044c984>] ? handle_fasteoi_irq+0x0/0xac
[  558.656520]  [<c040598c>] do_IRQ+0xa9/0xd1
[  558.656520]  [<c04025f2>] ? default_idle+0x0/0x42
[  558.656520]  [<c040429b>] common_interrupt+0x23/0x28
[  558.656520]  [<c04025f2>] ? default_idle+0x0/0x42
[  558.656520]  [<c041007b>] ? acpi_save_state_mem+0xa/0x12b
[  558.656520]  [<c040261f>] ? default_idle+0x2d/0x42
[  558.656520]  [<c040256d>] cpu_idle+0x8b/0x9f
[  558.656520]  [<c061f329>] start_secondary+0x156/0x15b
[  558.656520]  =======================
[  558.656520] ehci_hcd 0000:00:1d.7: hcd state 0
[  558.656520] ehci_hcd 0000:00:1d.7: hcd state 0
[  558.656520] ehci_hcd 0000:00:1d.7: HC died; cleaning up
[  558.657583] hub 5-0:1.0: state 0 ports 8 chg 0000 evt 0000
[  558.657583] usb 5-2: USB disconnect, address 6
[  558.657583] usb 5-2: unregistering device
[  558.657583] usb 5-2: usb_disable_device nuking all URBs
[  558.657583] usb 5-2: unregistering interface 5-2:1.0
[  558.657583] /usr/src/linux-2.6.26/drivers/usb/serial/magtek.c: magtek_shutdown
[  558.657583] magtek ttyUSB0: Magtek 75/Excella USB card reader converter now disconnected from ttyUSB0
[  558.657584] magtek 5-2:1.0: device disconnected
[  558.657584] usb 5-2:1.0: uevent
[  558.658057] usb 5-2: uevent

Thanks
Amruth p.v


--- On Tue, 8/26/08, David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <david-b@pacbell.net>
> Subject: Re: USB Serial device disconnect causes IRQ disable after using ehci controller halted
> To: "Alan Stern" <stern@rowland.harvard.edu>
> Cc: "Karsten Wiese" <fzu@wemgehoertderstaat.de>, "amruth" <amruth_pv@yahoo.com>, "Oliver Neukum" <oliver@neukum.org>, "USB list" <linux-usb@vger.kernel.org>, "Kernel development list" <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
> Date: Tuesday, August 26, 2008, 4:43 PM
> On Tuesday 26 August 2008, Alan Stern wrote:
> > While it certainly would be a good idea to prevent the
> handshake 
> > failures from occurring in the first place -- Dave,
> aren't you working 
> > on a patch for that? -- we should also make sure that
> when they do 
> > occur, the controller gets reset properly.  And an
> error message should 
> > be printed in the log.
> 
> Like this?
> 
> Greg, please queue for 2.6.27 unless someone finds a
> problem with this patch.
> 
> 
> =========	SNIP!  SNIP!  SNIPPITY SNIP!
> From: David Brownell
> <dbrownell@users.sourceforge.net>
> 
> I noticed that the "Refactor "if (handshake())
> state = HC_STATE_HALT"
> patch from earlier this year perpetuated a potential
> problem:  it can
> mark the controller as halted when it's still running
> (but not acting
> as, perhaps wrongly, expected).
> 
> That caused some hangs and crashes, rather than more polite
> failure
> modes of a truly halted controller.  This patch forces a
> true halt,
> and emits a (previously missing) diagnostic.
> 
> Signed-off-by: David Brownell
> <dbrownell@users.sourceforge.net>
> ---
>  drivers/usb/host/ehci-hcd.c |   26
> ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
> 
> --- a/drivers/usb/host/ehci-hcd.c	2008-08-15
> 14:04:27.000000000 -0700
> +++ b/drivers/usb/host/ehci-hcd.c	2008-08-15
> 14:04:36.000000000 -0700
> @@ -145,16 +145,6 @@ static int handshake (struct ehci_hcd
> *e
>  	return -ETIMEDOUT;
>  }
>  
> -static int handshake_on_error_set_halt(struct ehci_hcd
> *ehci, void __iomem *ptr,
> -				       u32 mask, u32 done, int usec)
> -{
> -	int error = handshake(ehci, ptr, mask, done, usec);
> -	if (error)
> -		ehci_to_hcd(ehci)->state = HC_STATE_HALT;
> -
> -	return error;
> -}
> -
>  /* force HC to halt state from unknown (EHCI spec section
> 2.3) */
>  static int ehci_halt (struct ehci_hcd *ehci)
>  {
> @@ -173,6 +163,22 @@ static int ehci_halt (struct ehci_hcd
> *e
>  			  STS_HALT, STS_HALT, 16 * 125);
>  }
>  
> +static int handshake_on_error_set_halt(struct ehci_hcd
> *ehci, void __iomem *ptr,
> +				       u32 mask, u32 done, int usec)
> +{
> +	int error;
> +
> +	error = handshake(ehci, ptr, mask, done, usec);
> +	if (error) {
> +		ehci_halt(ehci);
> +		ehci_to_hcd(ehci)->state = HC_STATE_HALT;
> +		ehci_err(ehci, "force halt; handhake %p %08x %08x
> -> %d\n",
> +			ptr, mask, done, error);
> +	}
> +
> +	return error;
> +}
> +
>  /* put TDI/ARC silicon into EHCI mode */
>  static void tdi_reset (struct ehci_hcd *ehci)
>  {
> 
> 
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


      

