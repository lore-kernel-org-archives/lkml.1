Return-Path: <linux-kernel-owner+w=401wt.eu-S1764997AbXKOSWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764997AbXKOSWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758312AbXKOSWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:22:24 -0500
Received: from smtp151.sat.emailsrvr.com ([66.216.121.151]:48284 "EHLO
	smtp151.sat.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758308AbXKOSWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:22:23 -0500
X-Greylist: delayed 1824 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2007 13:22:23 EST
Message-ID: <473C86A2.1060505@keyspan.com>
Date: Thu, 15 Nov 2007 09:49:22 -0800
From: Lucy McCoy <lucy@keyspan.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: bbpetkov@yahoo.de, Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] keyspan: init termios properly
References: <20071103100301.GA5615@gollum.tnic>
In-Reply-To: <20071103100301.GA5615@gollum.tnic>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg & Boris,

I've been out of town and just saw this.

This patch will work with the 19HS but WILL BREAK all other Keyspan
adapters.  It will take me a few days to get to looking at a correct fix but
that keyspan_send_setup(port, 1) (and the '1' is the important part) 
must happen once
when the port is first opened.  The cflag can just be set to whatever 
the normal default
is for your serial environment.  What are the defaults?

Lucy

Borislav Petkov wrote:
> Hi Greg,
>
>    i get the following backtrace when booting the kernel with "console=ttyUSB0
>    console=tty0" while using a Keyspan USA-19HS the usb-to-serial converter
>    connected to a desktop machine:
>
> <snip>
> [   43.782384] usbcore: registered new interface driver usbserial
> [   43.782444] drivers/usb/serial/usb-serial.c: USB Serial Driver core
> [   43.782543] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan - (without firmware)
> [   43.782652] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan 1 port adapter
> [   43.782759] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan 2 port adapter
> [   43.782866] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan 4 port adapter
> [   43.782980] usbcore: registered new interface driver keyspan
> [   43.783040] drivers/usb/serial/keyspan.c: v1.1.5:Keyspan USB to Serial Converter Driver
> ...
> [  124.816533] usb 3-1: new full speed USB device using uhci_hcd and address 2
> [  125.135811] usb 3-1: configuration #1 chosen from 2 choices
> [  125.140709] keyspan 3-1:1.0: Keyspan 1 port adapter converter detected
> [  125.141110] usb 3-1: Keyspan 1 port adapter converter now attached to ttyUSB0
> [  125.142446] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000084
> [  125.142597] printing eip: c02654ca *pde = 00000000 
> [  125.142764] BUG: using smp_processor_id() in preemptible [00000001] code: khubd/142
> [  125.142861] caller is die+0x59/0x1eb
> [  125.142930]  [<c0105026>] show_trace_log_lvl+0x1a/0x2f
> [  125.143054]  [<c0105a19>] show_trace+0x12/0x14
> [  125.143173]  [<c0105b34>] dump_stack+0x16/0x18
> [  125.143293]  [<c01e3c2f>] debug_smp_processor_id+0xa3/0xb8
> [  125.143429]  [<c0105310>] die+0x59/0x1eb
> [  125.143546]  [<c0119b07>] do_page_fault+0x42c/0x505
> [  125.143680]  [<c02f8622>] error_code+0x72/0x78
> [  125.143802]  [<c0262a50>] usb_console_setup+0x182/0x282
> [  125.143925]  [<c0122676>] register_console+0xe9/0x21c
> [  125.144048]  [<c02628a4>] usb_serial_console_init+0x31/0x33
> [  125.144171]  [<c026190f>] usb_serial_probe+0xe3c/0xf55
> [  125.144293]  [<c0253718>] usb_probe_interface+0xb6/0xe7
> [  125.144424]  [<c0233b8c>] driver_probe_device+0xcb/0x14f
> [  125.144548]  [<c0233c18>] __device_attach+0x8/0xa
> [  125.144678]  [<c0232fb8>] bus_for_each_drv+0x3b/0x63
> [  125.144799]  [<c0233ca9>] device_attach+0x70/0x85
> [  125.144919]  [<c0232f2f>] bus_attach_device+0x29/0x77
> [  125.145040]  [<c0232044>] device_add+0x302/0x514
> [  125.145160]  [<c02521ff>] usb_set_configuration+0x418/0x46d
> [  125.145283]  [<c0258b67>] generic_probe+0x53/0x94
> [  125.145403]  [<c02534a9>] usb_probe_device+0x38/0x3e
> [  125.145523]  [<c0233b8c>] driver_probe_device+0xcb/0x14f
> [  125.145656]  [<c0233c18>] __device_attach+0x8/0xa
> [  125.145776]  [<c0232fb8>] bus_for_each_drv+0x3b/0x63
> [  125.146675]  [<c0233ca9>] device_attach+0x70/0x85
> [  125.146795]  [<c0232f2f>] bus_attach_device+0x29/0x77
> [  125.146916]  [<c0232044>] device_add+0x302/0x514
> [  125.147036]  [<c024dc69>] usb_new_device+0x44/0x82
> [  125.147160]  [<c024eeaa>] hub_thread+0x65a/0xa13
> [  125.147280]  [<c0132daf>] kthread+0x3b/0x64
> [  125.147400]  [<c0104c87>] kernel_thread_helper+0x7/0x10
> [  125.147521]  =======================
> [  125.147600] Oops: 0000 [#1] PREEMPT SMP 
> [  125.147805] Modules linked in: usbhid video output tg3 intel_agp uhci_hcd psmouse agpgart rtc evdev
> [  125.148403] 
> [  125.148466] Pid: 142, comm: khubd Not tainted (2.6.24-rc1-521-g54866f0 #16)
> [  125.148546] BUG: using smp_processor_id() in preemptible [00000001] code: khubd/142
> [  125.148646] caller is __show_registers+0xad/0x1d8
> [  125.148717]  [<c0105026>] show_trace_log_lvl+0x1a/0x2f
> [  125.148839]  [<c0105a19>] show_trace+0x12/0x14
> [  125.148958]  [<c0105b34>] dump_stack+0x16/0x18
> [  125.149077]  [<c01e3c2f>] debug_smp_processor_id+0xa3/0xb8
> [  125.149201]  [<c0102344>] __show_registers+0xad/0x1d8
> [  125.149321]  [<c01050f7>] show_registers+0x19/0x1d9
> [  125.149440]  [<c01053d6>] die+0x11f/0x1eb
> [  125.149557]  [<c0119b07>] do_page_fault+0x42c/0x505
> [  125.149688]  [<c02f8622>] error_code+0x72/0x78
> [  125.149808]  [<c0262a50>] usb_console_setup+0x182/0x282
> [  125.149930]  [<c0122676>] register_console+0xe9/0x21c
> [  125.150051]  [<c02628a4>] usb_serial_console_init+0x31/0x33
> [  125.150175]  [<c026190f>] usb_serial_probe+0xe3c/0xf55
> [  125.150296]  [<c0253718>] usb_probe_interface+0xb6/0xe7
> [  125.150416]  [<c0233b8c>] driver_probe_device+0xcb/0x14f
> [  125.150538]  [<c0233c18>] __device_attach+0x8/0xa
> [  125.150669]  [<c0232fb8>] bus_for_each_drv+0x3b/0x63
> [  125.150792]  [<c0233ca9>] device_attach+0x70/0x85
> [  125.150913]  [<c0232f2f>] bus_attach_device+0x29/0x77
> [  125.151036]  [<c0232044>] device_add+0x302/0x514
> [  125.151156]  [<c02521ff>] usb_set_configuration+0x418/0x46d
> [  125.151281]  [<c0258b67>] generic_probe+0x53/0x94
> [  125.151402]  [<c02534a9>] usb_probe_device+0x38/0x3e
> [  125.151523]  [<c0233b8c>] driver_probe_device+0xcb/0x14f
> [  125.151658]  [<c0233c18>] __device_attach+0x8/0xa
> [  125.151780]  [<c0232fb8>] bus_for_each_drv+0x3b/0x63
> [  125.151902]  [<c0233ca9>] device_attach+0x70/0x85
> [  125.152023]  [<c0232f2f>] bus_attach_device+0x29/0x77
> [  125.152146]  [<c0232044>] device_add+0x302/0x514
> [  125.152266]  [<c024dc69>] usb_new_device+0x44/0x82
> [  125.152388]  [<c024eeaa>] hub_thread+0x65a/0xa13
> [  125.152508]  [<c0132daf>] kthread+0x3b/0x64
> [  125.152633]  [<c0104c87>] kernel_thread_helper+0x7/0x10
> [  125.152754]  =======================
> [  125.152822] EIP: 0060:[<c02654ca>] EFLAGS: 00010246 CPU: 0
> [  125.152901] EIP is at keyspan_open+0x11c/0x19d
> [  125.152971] EAX: 00000000 EBX: c19e7c00 ECX: c19e7c00 EDX: c19e7c00
> [  125.153047] ESI: c1bd3e00 EDI: 00000002 EBP: c1886b54 ESP: c1886b1c
> [  125.153123]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [  125.153197] Process khubd (pid: 142, ti=c1886000 task=c1843080 task.ti=c1886000)
> [  125.153274] Stack: 00000246 22222222 22222222 22222222 22222222 c03eeb40 c19e7c00 0000006e 
> [  125.153775]        c1aeab40 c030fcec c02f72b5 c19e7c00 0000006e c03eed18 c1886bb0 c0262a50 
> [  125.154264]        c02316d6 c1886b68 c0232e33 c1aeab40 c1886b78 c01dd877 00000cbd c1886b80 
> [  125.154762] Call Trace:
> [  125.154875]  [<c0105026>] show_trace_log_lvl+0x1a/0x2f
> [  125.154995]  [<c01050d6>] show_stack_log_lvl+0x9b/0xa3
> [  125.155115]  [<c0105182>] show_registers+0xa4/0x1d9
> [  125.155235]  [<c01053d6>] die+0x11f/0x1eb
> [  125.155352]  [<c0119b07>] do_page_fault+0x42c/0x505
> [  125.155472]  [<c02f8622>] error_code+0x72/0x78
> [  125.155654]  [<c0262a50>] usb_console_setup+0x182/0x282
> [  125.155774]  [<c0122676>] register_console+0xe9/0x21c
> [  125.155893]  [<c02628a4>] usb_serial_console_init+0x31/0x33
> [  125.156013]  [<c026190f>] usb_serial_probe+0xe3c/0xf55
> [  125.156131]  [<c0253718>] usb_probe_interface+0xb6/0xe7
> [  125.156251]  [<c0233b8c>] driver_probe_device+0xcb/0x14f
> [  125.156370]  [<c0233c18>] __device_attach+0x8/0xa
> [  125.156488]  [<c0232fb8>] bus_for_each_drv+0x3b/0x63
> [  125.156616]  [<c0233ca9>] device_attach+0x70/0x85
> [  125.156734]  [<c0232f2f>] bus_attach_device+0x29/0x77
> [  125.156852]  [<c0232044>] device_add+0x302/0x514
> [  125.156969]  [<c02521ff>] usb_set_configuration+0x418/0x46d
> [  125.157089]  [<c0258b67>] generic_probe+0x53/0x94
> [  125.157207]  [<c02534a9>] usb_probe_device+0x38/0x3e
> [  125.157325]  [<c0233b8c>] driver_probe_device+0xcb/0x14f
> [  125.157445]  [<c0233c18>] __device_attach+0x8/0xa
> [  125.157562]  [<c0232fb8>] bus_for_each_drv+0x3b/0x63
> [  125.157689]  [<c0233ca9>] device_attach+0x70/0x85
> [  125.157806]  [<c0232f2f>] bus_attach_device+0x29/0x77
> [  125.157925]  [<c0232044>] device_add+0x302/0x514
> [  125.158041]  [<c024dc69>] usb_new_device+0x44/0x82
> [  125.158160]  [<c024eeaa>] hub_thread+0x65a/0xa13
> [  125.158277]  [<c0132daf>] kthread+0x3b/0x64
> [  125.158393]  [<c0104c87>] kernel_thread_helper+0x7/0x10
> [  125.158512]  =======================
> [  125.158577] Code: 74 08 8b 4d e8 8b 01 89 42 28 8b 96 98 00 00 00 85 d2 74 08 8b 5d e8 8b 03 89 42 28 8b 55 e0 8b 4d e0 8b 5d e0 8b 42 04 8a 49 48 <8b> 90 84 00 00 00 8b 7a 08 88 4d f3 8b 13 8a 52 0c 88 55 e7 e8 
> [   50.035324] EIP: [<c02654ca>] keyspan_open+0x11c/0x19d SS:ESP 0068:c1886b1c
>
> </snip>
>
> and this happens, imho, because in usb_console_setup(), port->tty is set to NULL
> prior to calling serial->type->open() which is keyspan_open() in this case. In
> keyspan_open(), otoh, some premature terminal config is done for the purposes of
> the setup message by deref'ing, among others, port->tty->termios->c_flag, which,
> as we saw before :) is NULL and BAM! The patch below is against current git
> (v2.6.24-rc1-573-g74521c2).
>
> ---
> From: Borislav Petkov <bbpetkov@yahoo.de>
>
> Remove redundant code leading to NULL ptr deref and let terminal config settings
> take place in the proper initialization path in usb_console_setup().
>
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> --
>
>  drivers/usb/serial/keyspan.c |   38 ++++++--------------------------------
>  1 files changed, 6 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
> index 6bfdba6..1f7ab15 100644
> --- a/drivers/usb/serial/keyspan.c
> +++ b/drivers/usb/serial/keyspan.c
> @@ -1215,20 +1215,18 @@ static int keyspan_chars_in_buffer (struct usb_serial_port *port)
>  
>  static int keyspan_open (struct usb_serial_port *port, struct file *filp)
>  {
> -	struct keyspan_port_private 	*p_priv;
> -	struct keyspan_serial_private 	*s_priv;
> -	struct usb_serial 		*serial = port->serial;
> +	struct keyspan_port_private	*p_priv;
> +	struct keyspan_serial_private	*s_priv;
> +	struct usb_serial		*serial = port->serial;
>  	const struct keyspan_device_details	*d_details;
>  	int				i, err;
> -	int				baud_rate, device_port;
>  	struct urb			*urb;
> -	unsigned int			cflag;
>  
>  	s_priv = usb_get_serial_data(serial);
>  	p_priv = usb_get_serial_port_data(port);
>  	d_details = p_priv->device_details;
> -	
> -	dbg("%s - port%d.", __FUNCTION__, port->number); 
> +
> +	dbg("%s - port%d.", __FUNCTION__, port->number);
>  
>  	/* Set some sane defaults */
>  	p_priv->rts_state = 1;
> @@ -1249,7 +1247,7 @@ static int keyspan_open (struct usb_serial_port *port, struct file *filp)
>  		urb->dev = serial->dev;
>  
>  		/* make sure endpoint data toggle is synchronized with the device */
> -		
> +
>  		usb_clear_halt(urb->dev, urb->pipe);
>  
>  		if ((err = usb_submit_urb(urb, GFP_KERNEL)) != 0) {
> @@ -1265,30 +1263,6 @@ static int keyspan_open (struct usb_serial_port *port, struct file *filp)
>  		/* usb_settoggle(urb->dev, usb_pipeendpoint(urb->pipe), usb_pipeout(urb->pipe), 0); */
>  	}
>  
> -	/* get the terminal config for the setup message now so we don't 
> -	 * need to send 2 of them */
> -
> -	cflag = port->tty->termios->c_cflag;
> -	device_port = port->number - port->serial->minor;
> -
> -	/* Baud rate calculation takes baud rate as an integer
> -	   so other rates can be generated if desired. */
> -	baud_rate = tty_get_baud_rate(port->tty);
> -	/* If no match or invalid, leave as default */		
> -	if (baud_rate >= 0
> -	    && d_details->calculate_baud_rate(baud_rate, d_details->baudclk,
> -				NULL, NULL, NULL, device_port) == KEYSPAN_BAUD_RATE_OK) {
> -		p_priv->baud = baud_rate;
> -	}
> -
> -	/* set CTS/RTS handshake etc. */
> -	p_priv->cflag = cflag;
> -	p_priv->flow_control = (cflag & CRTSCTS)? flow_cts: flow_none;
> -
> -	keyspan_send_setup(port, 1);
> -	//mdelay(100);
> -	//keyspan_set_termios(port, NULL);
> -
>  	return (0);
>  }
>  
>   
