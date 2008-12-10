Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYLJJmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYLJJmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 04:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbYLJJmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 04:42:15 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:33690 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573AbYLJJmN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 04:42:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYEAHsdP0nCTsYx/2dsb2JhbACBbM5Lgwc
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] usb: make printk messges more searchable
Date: Wed, 10 Dec 2008 10:42:17 +0100
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org
References: <20081210072921.GA18142@localhost>
In-Reply-To: <20081210072921.GA18142@localhost>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200812101042.17530.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wu,

On Wednesday 10 December 2008, Wu Fengguang wrote:
> Make USB printk messages long and straightforward.  One of these
> decorated USB error messages cost me some smart efforts to locate.

That would make the code break the 80 columns limit.

>From "Documentation/CodingStyle":

"The limit on the length of lines is 80 columns and this is a strongly
preferred limit."

Best regards,

Laurent Pinchart

> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  drivers/usb/core/hub.c |   89 ++++++++++++++++++---------------------
>  1 file changed, 43 insertions(+), 46 deletions(-)
>
> --- linux-2.6.orig/drivers/usb/core/hub.c
> +++ linux-2.6/drivers/usb/core/hub.c
> @@ -107,7 +107,8 @@ MODULE_PARM_DESC (blinkenlights, "true t
>  /* define initial 64-byte descriptor request timeout in milliseconds */
>  static int initial_descriptor_timeout = USB_CTRL_GET_TIMEOUT;
>  module_param(initial_descriptor_timeout, int, S_IRUGO|S_IWUSR);
> -MODULE_PARM_DESC(initial_descriptor_timeout, "initial 64-byte descriptor
> request timeout in milliseconds (default 5000 - 5.0 seconds)");
> +MODULE_PARM_DESC(initial_descriptor_timeout,
> +		"initial 64-byte descriptor request timeout in milliseconds (default
> 5000 - 5.0 seconds)");
>
>  /*
>   * As of 2.6.10 we introduce a new USB device initialization scheme which
> @@ -131,8 +132,7 @@ MODULE_PARM_DESC(old_scheme_first,
>  static int use_both_schemes = 1;
>  module_param(use_both_schemes, bool, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(use_both_schemes,
> -		"try the other device initialization scheme if the "
> -		"first one fails");
> +		"try the other device initialization scheme if the first one fails");
>
>  /* Mutual exclusion for EHCI CF initialization.  This interferes with
>   * port reset on some companion controllers.
> @@ -545,8 +545,7 @@ static unsigned hub_power_on(struct usb_
>  	if ((wHubCharacteristics & HUB_CHAR_LPSM) < 2)
>  		dev_dbg(hub->intfdev, "enabling power on all ports\n");
>  	else
> -		dev_dbg(hub->intfdev, "trying to enable port power on "
> -				"non-switchable hub\n");
> +		dev_dbg(hub->intfdev, "trying to enable port power on non-switchable
> hub\n"); for (port1 = 1; port1 <= hub->descriptor->bNbrPorts; port1++)
>  		set_port_feature(hub->hdev, port1, USB_PORT_FEAT_POWER);
>
> @@ -1020,8 +1019,7 @@ static int hub_configure(struct usb_hub
>
>  			if (remaining < hdev->maxchild * 100)
>  				dev_warn(hub_dev,
> -					"insufficient power available "
> -					"to use all downstream ports\n");
> +					"insufficient power available to use all downstream ports\n");
>  			hub->mA_per_port = 100;		/* 7.2.1.1 */
>  		}
>  	} else {	/* Self-powered external hub */
> @@ -1136,8 +1134,8 @@ static int hub_probe(struct usb_interfac
>  	hdev = interface_to_usbdev(intf);
>
>  	if (hdev->level == MAX_TOPO_LEVEL) {
> -		dev_err(&intf->dev, "Unsupported bus topology: "
> -				"hub nested too deep\n");
> +		dev_err(&intf->dev,
> +			"Unsupported bus topology: hub nested too deep\n");
>  		return -E2BIG;
>  	}
>
> @@ -1476,8 +1474,8 @@ static void announce_device(struct usb_d
>  	dev_info(&udev->dev, "New USB device found, idVendor=%04x,
> idProduct=%04x\n", le16_to_cpu(udev->descriptor.idVendor),
>  		le16_to_cpu(udev->descriptor.idProduct));
> -	dev_info(&udev->dev, "New USB device strings: Mfr=%d, Product=%d, "
> -		"SerialNumber=%d\n",
> +	dev_info(&udev->dev,
> +		"New USB device strings: Mfr=%d, Product=%d, SerialNumber=%d\n",
>  		udev->descriptor.iManufacturer,
>  		udev->descriptor.iProduct,
>  		udev->descriptor.iSerialNumber);
> @@ -1542,7 +1540,7 @@ static int usb_configure_device_otg(stru
>  					 * customize to match your product.
>  					 */
>  					dev_info(&udev->dev,
> -						"can't set HNP mode; %d\n",
> +						"can't set HNP mode: %d\n",
>  						err);
>  					bus->b_hnp_enable = 0;
>  				}
> @@ -1723,8 +1721,9 @@ int usb_authorize_device(struct usb_devi
>  	}
>  	result = usb_get_device_descriptor(usb_dev, sizeof(usb_dev->descriptor));
>  	if (result < 0) {
> -		dev_err(&usb_dev->dev, "can't re-read device descriptor for "
> -			"authorization: %d\n", result);
> +		dev_err(&usb_dev->dev,
> +			"can't re-read device descriptor for authorization: %d\n",
> +			result);
>  		goto error_device_descriptor;
>  	}
>  	usb_dev->authorized = 1;
> @@ -2020,8 +2019,8 @@ int usb_port_suspend(struct usb_device *
>  				USB_CTRL_SET_TIMEOUT);
>  	} else {
>  		/* device has up to 10 msec to fully suspend */
> -		dev_dbg(&udev->dev, "usb %ssuspend\n",
> -				udev->auto_pm ? "auto-" : "");
> +		dev_dbg(&udev->dev, "%s\n",
> +			udev->auto_pm ? "usb auto-suspend" : "usb suspend");
>  		usb_set_device_state(udev, USB_STATE_SUSPENDED);
>  		msleep(10);
>  	}
> @@ -2045,8 +2044,8 @@ static int finish_port_resume(struct usb
>  	u16	devstatus;
>
>  	/* caller owns the udev device lock */
> -	dev_dbg(&udev->dev, "finish %sresume\n",
> -			udev->reset_resume ? "reset-" : "");
> +	dev_dbg(&udev->dev, "%s\n",
> +		udev->reset_resume ? "finish reset-resume" : "finish resume");
>
>  	/* usb ch9 identifies four variants of SUSPENDED, based on what
>  	 * state the device resumes to.  Linux currently won't see the
> @@ -2098,8 +2097,9 @@ static int finish_port_resume(struct usb
>  					NULL, 0,
>  					USB_CTRL_SET_TIMEOUT);
>  			if (status)
> -				dev_dbg(&udev->dev, "disable remote "
> -					"wakeup, status %d\n", status);
> +				dev_dbg(&udev->dev,
> +					"disable remote wakeup, status %d\n",
> +					status);
>  		}
>  		status = 0;
>  	}
> @@ -2582,9 +2582,9 @@ hub_port_init (struct usb_hub *hub, stru
>  				goto fail;
>  			}
>  			if (r) {
> -				dev_err(&udev->dev, "device descriptor "
> -						"read/%s, error %d\n",
> -						"64", r);
> +				dev_err(&udev->dev,
> +					"device descriptor read/64, error %d\n",
> +					r);
>  				retval = -EMSGSIZE;
>  				continue;
>  			}
> @@ -2621,9 +2621,9 @@ hub_port_init (struct usb_hub *hub, stru
>
>  		retval = usb_get_device_descriptor(udev, 8);
>  		if (retval < 8) {
> -			dev_err(&udev->dev, "device descriptor "
> -					"read/%s, error %d\n",
> -					"8", retval);
> +			dev_err(&udev->dev,
> +					"device descriptor read/8, error %d\n",
> +					retval);
>  			if (retval >= 0)
>  				retval = -EMSGSIZE;
>  		} else {
> @@ -2650,8 +2650,8 @@ hub_port_init (struct usb_hub *hub, stru
>
>  	retval = usb_get_device_descriptor(udev, USB_DT_DEVICE_SIZE);
>  	if (retval < (signed)sizeof(udev->descriptor)) {
> -		dev_err(&udev->dev, "device descriptor read/%s, error %d\n",
> -			"all", retval);
> +		dev_err(&udev->dev, "device descriptor read/all, error %d\n",
> +			retval);
>  		if (retval >= 0)
>  			retval = -ENOMSG;
>  		goto fail;
> @@ -2681,8 +2681,8 @@ check_highspeed (struct usb_hub *hub, st
>  	status = usb_get_descriptor (udev, USB_DT_DEVICE_QUALIFIER, 0,
>  			qual, sizeof *qual);
>  	if (status == sizeof *qual) {
> -		dev_info(&udev->dev, "not running at top speed; "
> -			"connect to a high speed hub\n");
> +		dev_info(&udev->dev,
> +			"not running at top speed; connect to a high speed hub\n");
>  		/* hub LEDs are probably harder to miss than syslog */
>  		if (hub->has_indicators) {
>  			hub->indicator[port1-1] = INDICATOR_GREEN_BLINK;
> @@ -2719,9 +2719,9 @@ hub_power_remaining (struct usb_hub *hub
>  		else
>  			delta = 8;
>  		if (delta > hub->mA_per_port)
> -			dev_warn(&udev->dev, "%dmA is over %umA budget "
> -					"for port %d!\n",
> -					delta, hub->mA_per_port, port1);
> +			dev_warn(&udev->dev,
> +				 "%dmA is over %umA budget for port %d!\n",
> +				 delta, hub->mA_per_port, port1);
>  		remaining -= delta;
>  	}
>  	if (remaining < 0) {
> @@ -2812,8 +2812,9 @@ static void hub_port_connect_change(stru
>  		status = hub_port_debounce(hub, port1);
>  		if (status < 0) {
>  			if (printk_ratelimit())
> -				dev_err(hub_dev, "connect-debounce failed, "
> -						"port %d disabled\n", port1);
> +				dev_err(hub_dev,
> +					"connect-debounce failed, port %d disabled\n",
> +					port1);
>  			portstatus &= ~USB_PORT_STAT_CONNECTION;
>  		} else {
>  			portstatus = status;
> @@ -2883,8 +2884,7 @@ static void hub_port_connect_change(stru
>  			le16_to_cpus(&devstat);
>  			if ((devstat & (1 << USB_DEVICE_SELF_POWERED)) == 0) {
>  				dev_err(&udev->dev,
> -					"can't connect bus-powered hub "
> -					"to this port\n");
> +					"can't connect bus-powered hub to this port\n");
>  				if (hub->has_indicators) {
>  					hub->indicator[port1-1] =
>  						INDICATOR_AMBER_BLINK;
> @@ -3067,9 +3067,8 @@ static void hub_events(void)
>  			if (portchange & USB_PORT_STAT_C_ENABLE) {
>  				if (!connect_change)
>  					dev_dbg (hub_dev,
> -						"port %d enable change, "
> -						"status %08x\n",
> -						i, portstatus);
> +						 "port %d enable change, status %08x\n",
> +						 i, portstatus);
>  				clear_port_feature(hdev, i,
>  					USB_PORT_FEAT_C_ENABLE);
>
> @@ -3083,10 +3082,8 @@ static void hub_events(void)
>  				    && !connect_change
>  				    && hdev->children[i-1]) {
>  					dev_err (hub_dev,
> -					    "port %i "
> -					    "disabled by hub (EMI?), "
> -					    "re-enabling...\n",
> -						i);
> +						 "port %i disabled by hub (EMI?), re-enabling...\n",
> +						 i);
>  					connect_change = 1;
>  				}
>  			}
> @@ -3420,8 +3417,8 @@ static int usb_reset_and_verify_device(s
>  		ret = usb_set_interface(udev, desc->bInterfaceNumber,
>  			desc->bAlternateSetting);
>  		if (ret < 0) {
> -			dev_err(&udev->dev, "failed to restore interface %d "
> -				"altsetting %d (error=%d)\n",
> +			dev_err(&udev->dev,
> +				"failed to restore interface %d altsetting %d (error=%d)\n",
>  				desc->bInterfaceNumber,
>  				desc->bAlternateSetting,
>  				ret);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


