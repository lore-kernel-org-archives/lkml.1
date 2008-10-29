Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbYJ2XIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbYJ2XIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbYJ2XIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:08:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52730 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbYJ2XIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:08:12 -0400
Date: Thu, 30 Oct 2008 00:09:39 +0100
From: Pavel Machek <pavel@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 13/49] Staging: w35und: remove usb_submit_urb wrapper
	function
Message-ID: <20081029230939.GI1976@elf.ucw.cz>
References: <20081029223832.GC21657@kroah.com> <1225320016-21803-13-git-send-email-greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225320016-21803-13-git-send-email-greg@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-10-29 15:39:40, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> No need for a simple wrapper here.
> 
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Pavel Machek <pavel@suse.cz>

ACK.

> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/staging/winbond/linux/wb35reg.c |    2 +-
>  drivers/staging/winbond/linux/wb35rx.c  |    2 +-
>  drivers/staging/winbond/linux/wb35tx.c  |    4 ++--
>  drivers/staging/winbond/linux/wbusb_f.h |    1 -
>  4 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/winbond/linux/wb35reg.c b/drivers/staging/winbond/linux/wb35reg.c
> index 041be81..c2864b1 100644
> --- a/drivers/staging/winbond/linux/wb35reg.c
> +++ b/drivers/staging/winbond/linux/wb35reg.c
> @@ -434,7 +434,7 @@ Wb35Reg_EP0VM(phw_data_t pHwData )
>  
>  	reg->EP0vm_state = VM_RUNNING;
>  
> -	ret = wb_usb_submit_urb( urb );
> +	ret = usb_submit_urb(urb, GFP_ATOMIC);
>  
>  	if (ret < 0) {
>  #ifdef _PE_REG_DUMP_
> diff --git a/drivers/staging/winbond/linux/wb35rx.c b/drivers/staging/winbond/linux/wb35rx.c
> index ae91b62..e565746 100644
> --- a/drivers/staging/winbond/linux/wb35rx.c
> +++ b/drivers/staging/winbond/linux/wb35rx.c
> @@ -70,7 +70,7 @@ void Wb35Rx(  phw_data_t pHwData )
>  
>  	pWb35Rx->EP3vm_state = VM_RUNNING;
>  
> -	retv = wb_usb_submit_urb(urb);
> +	retv = usb_submit_urb(urb, GFP_ATOMIC);
>  
>  	if (retv != 0) {
>  		printk("Rx URB sending error\n");
> diff --git a/drivers/staging/winbond/linux/wb35tx.c b/drivers/staging/winbond/linux/wb35tx.c
> index 3c40e31..c54ef30 100644
> --- a/drivers/staging/winbond/linux/wb35tx.c
> +++ b/drivers/staging/winbond/linux/wb35tx.c
> @@ -65,7 +65,7 @@ void Wb35Tx(phw_data_t pHwData)
>  			  Wb35Tx_complete, pHwData);
>  
>  	pWb35Tx->EP4vm_state = VM_RUNNING;
> -	retv = wb_usb_submit_urb( pUrb );
> +	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
>  	if (retv<0) {
>  		printk("EP4 Tx Irp sending error\n");
>  		goto cleanup;
> @@ -240,7 +240,7 @@ void Wb35Tx_EP2VM(phw_data_t pHwData)
>  			  pltmp, MAX_INTERRUPT_LENGTH, Wb35Tx_EP2VM_complete, pHwData, 32);
>  
>  	pWb35Tx->EP2vm_state = VM_RUNNING;
> -	retv = wb_usb_submit_urb( pUrb );
> +	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
>  
>  	if (retv < 0) {
>  		#ifdef _PE_TX_DUMP_
> diff --git a/drivers/staging/winbond/linux/wbusb_f.h b/drivers/staging/winbond/linux/wbusb_f.h
> index 5a811f6..db47e1d 100644
> --- a/drivers/staging/winbond/linux/wbusb_f.h
> +++ b/drivers/staging/winbond/linux/wbusb_f.h
> @@ -16,7 +16,6 @@ void WbUsb_destroy(phw_data_t pHwData);
>  unsigned char WbWLanInitialize(struct wb35_adapter *adapter);
>  #define	WbUsb_Stop( _A )
>  
> -#define wb_usb_submit_urb(_A) usb_submit_urb(_A, GFP_ATOMIC)
>  #define wb_usb_alloc_urb(_A) usb_alloc_urb(_A, GFP_ATOMIC)
>  
>  #define WbUsb_CheckForHang( _P )

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
