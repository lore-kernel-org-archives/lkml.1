Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbYJWJpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbYJWJpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYJWJow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:44:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46399 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbYJWJov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:44:51 -0400
Date: Thu, 23 Oct 2008 11:46:32 +0200
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] w35und: remove unused wb35_open() and wb35_close()
	functions
Message-ID: <20081023094632.GC1849@elf.ucw.cz>
References: <Pine.LNX.4.64.0810221905550.1679@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810221905550.1679@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-10-22 19:06:13, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The functions are not used anywhere so remove them.
> 
> Cc: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK.

> ---
>  drivers/staging/winbond/linux/wbusb.c   |   19 -------------------
>  drivers/staging/winbond/linux/wbusb_f.h |    2 --
>  2 files changed, 0 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
> index 4b989c5..c3394bf 100644
> --- a/drivers/staging/winbond/linux/wbusb.c
> +++ b/drivers/staging/winbond/linux/wbusb.c
> @@ -308,25 +308,6 @@ WbUsb_destroy(phw_data_t pHwData)
>  {
>  }
>  
> -int wb35_open(struct net_device *netdev)
> -{
> -	struct wb35_adapter * adapter = (struct wb35_adapter *)netdev->priv;
> -	phw_data_t pHwData = &adapter->sHwData;
> -
> -        netif_start_queue(netdev);
> -
> -	//TODO : put here temporarily
> -	hal_set_accept_broadcast(pHwData, 1); // open accept broadcast
> -
> -	return 0;
> -}
> -
> -int wb35_close(struct net_device *netdev)
> -{
> -	netif_stop_queue(netdev);
> -	return 0;
> -}
> -
>  static void wb35_disconnect(struct usb_interface *intf)
>  {
>  	struct wb35_adapter * adapter = usb_get_intfdata(intf);
> diff --git a/drivers/staging/winbond/linux/wbusb_f.h b/drivers/staging/winbond/linux/wbusb_f.h
> index 0402f66..a1d5946 100644
> --- a/drivers/staging/winbond/linux/wbusb_f.h
> +++ b/drivers/staging/winbond/linux/wbusb_f.h
> @@ -11,8 +11,6 @@
>  //
>  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  
> -int wb35_open(struct net_device *netdev);
> -int wb35_close(struct net_device *netdev);
>  unsigned char WbUsb_initial(phw_data_t pHwData);
>  void WbUsb_destroy(phw_data_t pHwData);
>  unsigned char WbWLanInitialize(struct wb35_adapter *adapter);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
