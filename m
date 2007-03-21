Return-Path: <linux-kernel-owner+w=401wt.eu-S965105AbXCUVzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbXCUVzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 17:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965111AbXCUVzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 17:55:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:49527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965105AbXCUVzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 17:55:04 -0400
Date: Wed, 21 Mar 2007 14:53:09 -0700
From: Greg KH <gregkh@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kevin Lloyd <linux@sierrawireless.com>,
       Johannes H?lzl <johannes.hoelzl@gmx.de>,
       Kevin Lloyd <klloyd@sierrawireless.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc4: NULL pointer dereference oops when unplugging sierra device
Message-ID: <20070321215309.GA18940@suse.de>
References: <4601A3B9.3030701@goop.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <4601A3B9.3030701@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 21, 2007 at 02:29:29PM -0700, Jeremy Fitzhardinge wrote:
> My laptop has a built-in Sierra wireless device.  When I flicked the
> switch to disable it, which effectively unplugs the USB device, I got
> this oops:
> 
> sierra3 ttyUSB0: Sierra USB modem (3 port) converter now disconnected from ttyUSB0
> PM: Removing info for usb-serial:ttyUSB0
> PM: Removing info for No Bus:ttyUSB1
> sierra3 ttyUSB1: Sierra USB modem (3 port) converter now disconnected from ttyUSB1
> PM: Removing info for usb-serial:ttyUSB1
> PM: Removing info for No Bus:ttyUSB2
> sierra3 ttyUSB2: Sierra USB modem (3 port) converter now disconnected from ttyUSB2
> PM: Removing info for usb-serial:ttyUSB2
> BUG: unable to handle kernel NULL pointer dereference at virtual address 0000018c
>  printing eip:
> f8e52cd7
> *pde = 34187001
> Oops: 0000 [#1]
> SMP 
> Modules linked in: ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc sierra usbserial i915 drm
>  autofs4 hidp rfcomm l2cap bluetooth xt_tcpudp iptable_filter ip_tables x_tables vfat fat video ibm_acpi p
> arport_pc lp parport snd_hda_intel snd_hda_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_
> seq_device snd_pcm_oss wlan_scan_sta snd_mixer_oss snd_pcm ath_rate_sample ath_pci mmc_block wlan sdhci sn
> d_timer pcspkr e1000 snd soundcore sg ohci1394 ath_hal mmc_core snd_page_alloc ieee1394 rtc_cmos rtc_core 
> serio_raw rtc_lib rtc ehci_hcd uhci_hcd
> CPU:    0
> EIP:    0060:[<f8e52cd7>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.21-rc4 #126)
> EIP is at sierra_shutdown+0x3a/0x113 [sierra]
> eax: 00000000   ebx: 00000000   ecx: 00000000   edx: f8e52c9d
> esi: 00000000   edi: e889fa1c   ebp: e84c0e2c   esp: e84c0e0c
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process pppd (pid: 3847, ti=e84c0000 task=e8553550 task.ti=e84c0000)
> Stack: 00000002 e84c0e18 c01cfda8 e84c0e20 c0240431 e889fa1c 00000003 e8a79d00 
>        e84c0e50 f8e219e4 f8e5212d 00000021 00000000 00000000 00000000 e889fa50 
>        f8e21956 e84c0e70 c01d099a e84c0e78 f8e52c58 e84c0e6c f6c5576c f6c55760 
> Call Trace:
>  [<c0104e98>] show_trace_log_lvl+0x1a/0x2f
>  [<c0104f4a>] show_stack_log_lvl+0x9d/0xa5
>  [<c0105114>] show_registers+0x1c2/0x293
>  [<c0105307>] die+0x122/0x224
>  [<c030fe69>] do_page_fault+0x505/0x5e1
>  [<c030e5c4>] error_code+0x7c/0x84
>  [<f8e219e4>] destroy_serial+0x8e/0x124 [usbserial]
>  [<c01d099a>] kref_put+0x63/0x71
>  [<f8e217f0>] usb_serial_put+0x10/0x12 [usbserial]
>  [<f8e2194e>] serial_close+0xb6/0xbe [usbserial]
>  [<c0225290>] release_dev+0x1f0/0x5f9
>  [<c02256ab>] tty_release+0x12/0x1c
>  [<c0167cf2>] __fput+0xb8/0x162
>  [<c0167db3>] fput+0x17/0x19
>  [<c016591c>] filp_close+0x54/0x5c
>  [<c01668cd>] sys_close+0x63/0x97
>  [<c0103f04>] syscall_call+0x7/0xb
>  =======================
> Code: e5 f8 00 74 1c c7 44 24 08 97 2e e5 f8 c7 44 24 04 06 2f e5 f8 c7 04 24 22 2f e5 f8 e8 47 ff 2c c7 3
> 1 f6 eb 4c 8b 44 b7 14 31 db <8b> 80 8c 01 00 00 89 45 ec 8b 55 ec 8b 04 9a 85 c0 74 0b 83 78 
> EIP: [<f8e52cd7>] sierra_shutdown+0x3a/0x113 [sierra] SS:ESP 0068:e84c0e0c
> 
> 
> This was compiled from git change
> 0a14fe6e5efd0af0f9c6c01e0433445d615d0110.  .config attached.  The
> hardware is a Lenovo ThinkPad X60, with the integrated Verizon Sierra
> wireless modem:

Hm, do the two patches attached below fix this problem for you?

The second one might not be needed, but it is there for "correctness" :)

thanks,

greg k-h

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="usb-sierra-close-race.patch"

>From oneukum@suse.de Tue Mar 20 05:54:01 2007
From: Oliver Neukum <oneukum@suse.de>
To: Kevin Lloyd <linux@sierrawireless.com>, Greg KH <gregkh@suse.de>
Subject: USB: sierra close race
Date: Tue, 20 Mar 2007 13:54:05 +0100
Message-Id: <200703201354.06455.oneukum@suse.de>

the sierra driver does not directly use usb_kill_urb(). It uses a wrapper.
This wrapper means that callbacks which are running are not killed during
close, resubmitting and illicitly pushing data into the tty layer.
The whole purpose of usb_kill_urb() is subverted. The wrapper must be removed.
The same problem as the option driver.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/sierra.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -456,12 +456,6 @@ static int sierra_open(struct usb_serial
 	return (0);
 }
 
-static inline void stop_urb(struct urb *urb)
-{
-	if (urb && urb->status == -EINPROGRESS)
-		usb_kill_urb(urb);
-}
-
 static void sierra_close(struct usb_serial_port *port, struct file *filp)
 {
 	int i;
@@ -479,9 +473,9 @@ static void sierra_close(struct usb_seri
 
 		/* Stop reading/writing urbs */
 		for (i = 0; i < N_IN_URB; i++)
-			stop_urb(portdata->in_urbs[i]);
+			usb_unlink_urb(portdata->in_urbs[i]);
 		for (i = 0; i < N_OUT_URB; i++)
-			stop_urb(portdata->out_urbs[i]);
+			usb_unlink_urb(portdata->out_urbs[i]);
 	}
 	port->tty = NULL;
 }
@@ -585,9 +579,9 @@ static void sierra_shutdown(struct usb_s
 		port = serial->port[i];
 		portdata = usb_get_serial_port_data(port);
 		for (j = 0; j < N_IN_URB; j++)
-			stop_urb(portdata->in_urbs[j]);
+			usb_unlink_urb(portdata->in_urbs[j]);
 		for (j = 0; j < N_OUT_URB; j++)
-			stop_urb(portdata->out_urbs[j]);
+			usb_unlink_urb(portdata->out_urbs[j]);
 	}
 
 	/* Now free them */

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sierra.patch"

---
 drivers/usb/serial/sierra.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -577,7 +577,12 @@ static void sierra_shutdown(struct usb_s
 	/* Stop reading/writing urbs */
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
+		if (!port)
+			continue;
 		portdata = usb_get_serial_port_data(port);
+		if (!portdata)
+			continue;
+
 		for (j = 0; j < N_IN_URB; j++)
 			usb_unlink_urb(portdata->in_urbs[j]);
 		for (j = 0; j < N_OUT_URB; j++)
@@ -587,7 +592,11 @@ static void sierra_shutdown(struct usb_s
 	/* Now free them */
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
+		if (!port)
+			continue;
 		portdata = usb_get_serial_port_data(port);
+		if (!portdata)
+			continue;
 
 		for (j = 0; j < N_IN_URB; j++) {
 			if (portdata->in_urbs[j]) {
@@ -606,6 +615,8 @@ static void sierra_shutdown(struct usb_s
 	/* Now free per port private data */
 	for (i = 0; i < serial->num_ports; i++) {
 		port = serial->port[i];
+		if (!port)
+			continue;
 		kfree(usb_get_serial_port_data(port));
 	}
 }

--WIyZ46R2i8wDzkSu--
