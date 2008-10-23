Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYJWJor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYJWJor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYJWJoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:44:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46396 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYJWJoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:44:37 -0400
Date: Thu, 23 Oct 2008 11:46:18 +0200
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] w35und: make wb35_probe() and wb35_disconnect()
	funtions static
Message-ID: <20081023094618.GB1849@elf.ucw.cz>
References: <Pine.LNX.4.64.0810221905180.1679@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810221905180.1679@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-10-22 19:05:54, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The wb35_probe() and wb35_disconnect() functions are only used in wbusb.c so
> make them static and remove them from a header file.
> 
> Cc: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK.

> ---
>  drivers/staging/winbond/linux/wbusb.c   |    6 ++----
>  drivers/staging/winbond/linux/wbusb_f.h |    4 ----
>  2 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
> index b4be0d8..4b989c5 100644
> --- a/drivers/staging/winbond/linux/wbusb.c
> +++ b/drivers/staging/winbond/linux/wbusb.c
> @@ -173,9 +173,7 @@ static const struct ieee80211_ops wbsoft_ops = {
>  struct wbsoft_priv {
>  };
>  
> -
> -// Usb kernel subsystem will call this function when a new device is plugged into.
> -int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
> +static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
>  {
>  	struct wb35_adapter *adapter;
>  	PWBUSB		pWbUsb;
> @@ -329,7 +327,7 @@ int wb35_close(struct net_device *netdev)
>  	return 0;
>  }
>  
> -void wb35_disconnect(struct usb_interface *intf)
> +static void wb35_disconnect(struct usb_interface *intf)
>  {
>  	struct wb35_adapter * adapter = usb_get_intfdata(intf);
>  	usb_set_intfdata(intf, NULL);
> diff --git a/drivers/staging/winbond/linux/wbusb_f.h b/drivers/staging/winbond/linux/wbusb_f.h
> index 5225fa4..0402f66 100644
> --- a/drivers/staging/winbond/linux/wbusb_f.h
> +++ b/drivers/staging/winbond/linux/wbusb_f.h
> @@ -18,10 +18,6 @@ void WbUsb_destroy(phw_data_t pHwData);
>  unsigned char WbWLanInitialize(struct wb35_adapter *adapter);
>  #define	WbUsb_Stop( _A )
>  
> -int wb35_probe(struct usb_interface *intf,const struct usb_device_id *id_table);
> -void wb35_disconnect(struct usb_interface *intf);
> -
> -
>  #define WbUsb_CheckForHang( _P )
>  #define WbUsb_DetectStart( _P, _I )
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
