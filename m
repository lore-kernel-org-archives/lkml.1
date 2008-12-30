Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbYL3AY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbYL3AY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 19:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYL3AYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 19:24:09 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:39547 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753438AbYL3AYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 19:24:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gJ5d/71BKLcqrlHooe6fjkZyiv7bo7V9ldh5X74An7zBMNtnCQy8GZQx147P3tajqqCO0czZueskCya+/A33U14yaujmP7071qRToAbdOuFIF/Bh+rpmzO3h3cVlAcaa2lKRNoQtXvLSwSwiXrf6IH8OHdURRG5nGted4LjII7c=  ;
X-YMail-OSG: A8XDB5gVM1nQl_uMgudA4udP8aK2D9sCYRBp4zz87pHh.psJYrw1krYObxd1EWqfp6m5UVtEaLra29bIsSuAEe4NOQbcVpakzMzLt7abaH9g0sE2QG7FeQ_QJpSsaDkhNG4oI66HgjGMaVVAVA6NiOcJ7fmpeoq_0dblUdY0bcOfVSZ9L18pUXE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 10/13, revised] drivers/usb/gadget: use USB API functions rather than constants
Date: Mon, 29 Dec 2008 16:24:02 -0800
User-Agent: KMail/1.9.10
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0812292249230.2265@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0812292249230.2265@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812291624.02326.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 December 2008, Julia Lawall wrote:
> As compared to the previous version, the includes of usb.h have been dropped.
> This patch depends on the previously submitted patch "Move definitions from
> usb.h to usb/ch9.h".
> 
> 
> 
> From: Julia Lawall <julia@diku.dk>
> 
> This set of patches introduces calls to the following set of functions:
> 
> usb_endpoint_dir_in(epd)
> usb_endpoint_dir_out(epd)
> usb_endpoint_is_bulk_in(epd)
> usb_endpoint_is_bulk_out(epd)
> usb_endpoint_is_int_in(epd)
> usb_endpoint_is_int_out(epd)
> usb_endpoint_is_isoc_in(epd)
> usb_endpoint_is_isoc_out(epd)
> usb_endpoint_num(epd)
> usb_endpoint_type(epd)
> usb_endpoint_xfer_bulk(epd)
> usb_endpoint_xfer_control(epd)
> usb_endpoint_xfer_int(epd)
> usb_endpoint_xfer_isoc(epd)
> 
> In some cases, introducing one of these functions is not possible, and it
> just replaces an explicit integer value by one of the following constants:
> 
> USB_ENDPOINT_XFER_BULK
> USB_ENDPOINT_XFER_CONTROL
> USB_ENDPOINT_XFER_INT
> USB_ENDPOINT_XFER_ISOC
> 
> An extract of the semantic patch that makes these changes is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r1@ struct usb_endpoint_descriptor *epd; @@
> 
> - ((epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\)) ==
> - \(USB_ENDPOINT_XFER_CONTROL\|0\))
> + usb_endpoint_xfer_control(epd)
> 
> @r5@ struct usb_endpoint_descriptor *epd; @@
> 
> - ((epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\)) ==
> -  \(USB_DIR_IN\|0x80\))
> + usb_endpoint_dir_in(epd)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Thanks for the cleanup!


> 
> ---
>  drivers/usb/gadget/at91_udc.c       |    2 +-
>  drivers/usb/gadget/atmel_usba_udc.c |    6 +++---
>  drivers/usb/gadget/dummy_hcd.c      |   10 +++++-----
>  drivers/usb/gadget/epautoconf.c     |   10 +++++-----
>  drivers/usb/gadget/fsl_qe_udc.c     |    8 ++++----
>  drivers/usb/gadget/fsl_usb2_udc.c   |   16 +++++++---------
>  drivers/usb/gadget/goku_udc.c       |    4 ++--
>  drivers/usb/gadget/m66592-udc.c     |   12 ++++++------
>  drivers/usb/gadget/net2280.c        |    9 ++++-----
>  drivers/usb/gadget/s3c2410_udc.c    |    4 ++--
>  10 files changed, 39 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
> index 0b2bb8f..0e27960 100644
> --- a/drivers/usb/gadget/at91_udc.c
> +++ b/drivers/usb/gadget/at91_udc.c
> @@ -485,7 +486,7 @@ static int at91_ep_enable(struct usb_ep *_ep,
>  		return -ESHUTDOWN;
>  	}
>  
> -	tmp = desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
> +	tmp = usb_endpoint_type(desc);
>  	switch (tmp) {
>  	case USB_ENDPOINT_XFER_CONTROL:
>  		DBG("only one control endpoint\n");
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> index 65b03e3..ddf00a7 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -529,7 +530,7 @@ usba_ep_enable(struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>  
>  	maxpacket = le16_to_cpu(desc->wMaxPacketSize) & 0x7ff;
>  
> -	if (((desc->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK) != ep->index)
> +	if ((usb_endpoint_num(desc) != ep->index)
>  			|| ep->index == 0
>  			|| desc->bDescriptorType != USB_DT_ENDPOINT
>  			|| maxpacket == 0
> @@ -550,12 +551,12 @@ usba_ep_enable(struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>  	DBG(DBG_HW, "%s: EPT_SIZE = %lu (maxpacket = %lu)\n",
>  			ep->ep.name, ept_cfg, maxpacket);
>  
> -	if ((desc->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN) {
> +	if (usb_endpoint_dir_in(desc)) {
>  		ep->is_in = 1;
>  		ept_cfg |= USBA_EPT_DIR_IN;
>  	}
>  
> -	switch (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
> +	switch (usb_endpoint_type(desc)) {
>  	case USB_ENDPOINT_XFER_CONTROL:
>  		ept_cfg |= USBA_BF(EPT_TYPE, USBA_EPT_TYPE_CONTROL);
>  		ept_cfg |= USBA_BF(BK_NUMBER, USBA_BK_NUMBER_ONE);
> diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
> index 9064696..f51ae30 100644
> --- a/drivers/usb/gadget/dummy_hcd.c
> +++ b/drivers/usb/gadget/dummy_hcd.c
> @@ -356,7 +356,7 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>  	 * especially for "ep9out" style fixed function ones.)
>  	 */
>  	retval = -EINVAL;
> -	switch (desc->bmAttributes & 0x03) {
> +	switch (usb_endpoint_type(desc)) {
>  	case USB_ENDPOINT_XFER_BULK:
>  		if (strstr (ep->ep.name, "-iso")
>  				|| strstr (ep->ep.name, "-int")) {
> @@ -423,8 +423,8 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>  
>  	dev_dbg (udc_dev(dum), "enabled %s (ep%d%s-%s) maxpacket %d\n",
>  		_ep->name,
> -		desc->bEndpointAddress & 0x0f,
> -		(desc->bEndpointAddress & USB_DIR_IN) ? "in" : "out",
> +		usb_endpoint_num(desc),
> +		usb_endpoint_dir_in(desc) ? "in" : "out",
>  		({ char *val;
>  		 switch (desc->bmAttributes & 0x03) {
>  		 case USB_ENDPOINT_XFER_BULK: val = "bulk"; break;
> @@ -533,7 +533,7 @@ dummy_queue (struct usb_ep *_ep, struct usb_request *_req,
>  	spin_lock_irqsave (&dum->lock, flags);
>  
>  	/* implement an emulated single-request FIFO */
> -	if (ep->desc && (ep->desc->bEndpointAddress & USB_DIR_IN) &&
> +	if (ep->desc && usb_endpoint_dir_in(ep->desc) &&
>  			list_empty (&dum->fifo_req.queue) &&
>  			list_empty (&ep->queue) &&
>  			_req->length <= FIFO_SIZE) {
> @@ -612,7 +612,7 @@ dummy_set_halt_and_wedge(struct usb_ep *_ep, int value, int wedged)
>  		return -ESHUTDOWN;
>  	if (!value)
>  		ep->halted = ep->wedged = 0;
> -	else if (ep->desc && (ep->desc->bEndpointAddress & USB_DIR_IN) &&
> +	else if (ep->desc && usb_endpoint_dir_in(ep->desc) &&
>  			!list_empty (&ep->queue))
>  		return -EAGAIN;
>  	else {
> diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
> index a36b117..8b3f994 100644
> --- a/drivers/usb/gadget/epautoconf.c
> +++ b/drivers/usb/gadget/epautoconf.c
> @@ -75,7 +76,7 @@ ep_matches (
>  		return 0;
>  
>  	/* only support ep0 for portable CONTROL traffic */
> -	type = desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
> +	type = usb_endpoint_type(desc);
>  	if (USB_ENDPOINT_XFER_CONTROL == type)
>  		return 0;
>  
> @@ -118,7 +119,7 @@ ep_matches (
>  		/* direction-restriction:  "..in-..", "out-.." */
>  		tmp--;
>  		if (!isdigit (*tmp)) {
> -			if (desc->bEndpointAddress & USB_DIR_IN) {
> +			if (usb_endpoint_dir_in(desc)) {
>  				if ('n' != *tmp)
>  					return 0;
>  			} else {
> @@ -164,7 +165,7 @@ ep_matches (
>  		u8	num = simple_strtoul (&ep->name [2], NULL, 10);
>  		desc->bEndpointAddress |= num;
>  #ifdef	MANY_ENDPOINTS
> -	} else if (desc->bEndpointAddress & USB_DIR_IN) {
> +	} else if (usb_endpoint_dir_in(desc)) {
>  		if (++in_epnum > 15)
>  			return 0;
>  		desc->bEndpointAddress = USB_DIR_IN | in_epnum;
> @@ -237,7 +238,7 @@ struct usb_ep * __init usb_ep_autoconfig (
>  	struct usb_ep	*ep;
>  	u8		type;
>  
> -	type = desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
> +	type = usb_endpoint_type(desc);
>  
>  	/* First, apply chip-specific "best usage" knowledge.
>  	 * This might make a good usb_gadget_ops hook ...
> @@ -258,7 +259,7 @@ struct usb_ep * __init usb_ep_autoconfig (
>  			if (ep && ep_matches (gadget, ep, desc))
>  				return ep;
>  		} else if (USB_ENDPOINT_XFER_BULK == type
> -				&& (USB_DIR_IN & desc->bEndpointAddress)) {
> +				&& usb_endpoint_dir_in(desc)) {
>  			/* DMA may be available */
>  			ep = find_ep (gadget, "ep2-bulk");
>  			if (ep && ep_matches (gadget, ep, desc))
> diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
> index d6c5bcd..5ae4bdb 100644
> --- a/drivers/usb/gadget/fsl_qe_udc.c
> +++ b/drivers/usb/gadget/fsl_qe_udc.c
> @@ -488,10 +489,10 @@ static int qe_ep_register_init(struct qe_udc *udc, unsigned char pipe_num)
>  	epparam = udc->ep_param[pipe_num];
>  
>  	usep = 0;
> -	logepnum = (ep->desc->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
> +	logepnum = usb_endpoint_num(ep->desc);
>  	usep |= (logepnum << USB_EPNUM_SHIFT);
>  
> -	switch (ep->desc->bmAttributes & 0x03) {
> +	switch (usb_endpoint_type(ep->desc)) {
>  	case USB_ENDPOINT_XFER_BULK:
>  		usep |= USB_TRANS_BULK;
>  		break;
> @@ -545,7 +546,7 @@ static int qe_ep_init(struct qe_udc *udc,
>  	/* Refer to USB2.0 spec table 9-13,
>  	*/
>  	if (pipe_num != 0) {
> -		switch (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
> +		switch (usb_endpoint_type(desc)) {
>  		case USB_ENDPOINT_XFER_BULK:
>  			if (strstr(ep->ep.name, "-iso")
>  					|| strstr(ep->ep.name, "-int"))
> @@ -642,7 +643,7 @@ static int qe_ep_init(struct qe_udc *udc,
>  
>  	/* initialize ep structure */
>  	ep->ep.maxpacket = max;
> -	ep->tm = (u8)(desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK);
> +	ep->tm = (u8)usb_endpoint_type(desc);
>  	ep->desc = desc;
>  	ep->stopped = 0;
>  	ep->init = 1;
> diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
> index f3c6703..7e06e51 100644
> --- a/drivers/usb/gadget/fsl_usb2_udc.c
> +++ b/drivers/usb/gadget/fsl_usb2_udc.c
> @@ -465,7 +466,7 @@ static int fsl_ep_enable(struct usb_ep *_ep,
>  	zlt = 1;
>  
>  	/* Assume the max packet size from gadget is always correct */
> -	switch (desc->bmAttributes & 0x03) {
> +	switch (usb_endpoint_type(desc)) {
>  	case USB_ENDPOINT_XFER_CONTROL:
>  	case USB_ENDPOINT_XFER_BULK:
>  	case USB_ENDPOINT_XFER_INT:
> @@ -496,25 +497,23 @@ static int fsl_ep_enable(struct usb_ep *_ep,
>  	/* Init EPx Queue Head (Ep Capabilites field in QH
>  	 * according to max, zlt, mult) */
>  	struct_ep_qh_setup(udc, (unsigned char) ep_index(ep),
> -			(unsigned char) ((desc->bEndpointAddress & USB_DIR_IN)
> +			(unsigned char) (usb_endpoint_dir_in(desc)
>  					?  USB_SEND : USB_RECV),
> -			(unsigned char) (desc->bmAttributes
> -					& USB_ENDPOINT_XFERTYPE_MASK),
> +			(unsigned char) usb_endpoint_type(desc),
>  			max, zlt, mult);
>  
>  	/* Init endpoint ctrl register */
>  	dr_ep_setup((unsigned char) ep_index(ep),
> -			(unsigned char) ((desc->bEndpointAddress & USB_DIR_IN)
> +			(unsigned char) (usb_endpoint_dir_in(desc)
>  					? USB_SEND : USB_RECV),
> -			(unsigned char) (desc->bmAttributes
> -					& USB_ENDPOINT_XFERTYPE_MASK));
> +			(unsigned char) usb_endpoint_type(desc));
>  
>  	spin_unlock_irqrestore(&udc->lock, flags);
>  	retval = 0;
>  
>  	VDBG("enabled %s (ep%d%s) maxpacket %d",ep->ep.name,
> -			ep->desc->bEndpointAddress & 0x0f,
> -			(desc->bEndpointAddress & USB_DIR_IN)
> +			usb_endpoint_num(ep->desc),
> +			usb_endpoint_dir_in(desc)
>  				? "in" : "out", max);
>  en_done:
>  	return retval;
> diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
> index 60aa048..70d38b8 100644
> --- a/drivers/usb/gadget/goku_udc.c
> +++ b/drivers/usb/gadget/goku_udc.c
> @@ -110,10 +111,10 @@ goku_ep_enable(struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>  		return -EINVAL;
>  	if (!dev->driver || dev->gadget.speed == USB_SPEED_UNKNOWN)
>  		return -ESHUTDOWN;
> -	if (ep->num != (desc->bEndpointAddress & 0x0f))
> +	if (ep->num != usb_endpoint_num(desc))
>  		return -EINVAL;
>  
> -	switch (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
> +	switch (usb_endpoint_type(desc)) {
>  	case USB_ENDPOINT_XFER_BULK:
>  	case USB_ENDPOINT_XFER_INT:
>  		break;
> diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
> index 43dcf9e..ed29838 100644
> --- a/drivers/usb/gadget/m66592-udc.c
> +++ b/drivers/usb/gadget/m66592-udc.c
> @@ -395,7 +396,7 @@ static void m66592_ep_setting(struct m66592 *m66592, struct m66592_ep *ep,
>  	ep->pipenum = pipenum;
>  	ep->ep.maxpacket = le16_to_cpu(desc->wMaxPacketSize);
>  	m66592->pipenum2ep[pipenum] = ep;
> -	m66592->epaddr2ep[desc->bEndpointAddress&USB_ENDPOINT_NUMBER_MASK] = ep;
> +	m66592->epaddr2ep[usb_endpoint_num(desc)] = ep;
>  	INIT_LIST_HEAD(&ep->queue);
>  }
>  
> @@ -427,7 +428,7 @@ static int alloc_pipe_config(struct m66592_ep *ep,
>  
>  	BUG_ON(ep->pipenum);
>  
> -	switch (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
> +	switch (usb_endpoint_type(desc)) {
>  	case USB_ENDPOINT_XFER_BULK:
>  		if (m66592->bulk >= M66592_MAX_NUM_BULK) {
>  			if (m66592->isochronous >= M66592_MAX_NUM_ISOC) {
> @@ -469,10 +470,10 @@ static int alloc_pipe_config(struct m66592_ep *ep,
>  	}
>  	ep->type = info.type;
>  
> -	info.epnum = desc->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
> +	info.epnum = usb_endpoint_num(desc);
>  	info.maxpacket = le16_to_cpu(desc->wMaxPacketSize);
>  	info.interval = desc->bInterval;
> -	if (desc->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
> +	if (usb_endpoint_dir_in(desc))
>  		info.dir_in = 1;
>  	else
>  		info.dir_in = 0;
> @@ -591,7 +592,7 @@ static void start_packet_read(struct m66592_ep *ep, struct m66592_request *req)
>  
>  static void start_packet(struct m66592_ep *ep, struct m66592_request *req)
>  {
> -	if (ep->desc->bEndpointAddress & USB_DIR_IN)
> +	if (usb_endpoint_dir_in(ep->desc))
>  		start_packet_write(ep, req);
>  	else
>  		start_packet_read(ep, req);
> @@ -905,7 +906,7 @@ static void irq_pipe_ready(struct m66592 *m66592, u16 status, u16 enb)
>  				ep = m66592->pipenum2ep[pipenum];
>  				req = list_entry(ep->queue.next,
>  						 struct m66592_request, queue);
> -				if (ep->desc->bEndpointAddress & USB_DIR_IN)
> +				if (usb_endpoint_dir_in(ep->desc))
>  					irq_packet_write(ep, req);
>  				else
>  					irq_packet_read(ep, req);
> diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
> index 12c6d83..8a1e5a7 100644
> --- a/drivers/usb/gadget/net2280.c
> +++ b/drivers/usb/gadget/net2280.c
> @@ -164,7 +165,7 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>  		return -ESHUTDOWN;
>  
>  	/* erratum 0119 workaround ties up an endpoint number */
> -	if ((desc->bEndpointAddress & 0x0f) == EP_DONTUSE)
> +	if (usb_endpoint_num(desc) == EP_DONTUSE)
>  		return -EDOM;
>  
>  	/* sanity check ep-e/ep-f since their fifos are small */
> @@ -195,12 +196,12 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>  
>  	/* set type, direction, address; reset fifo counters */
>  	writel ((1 << FIFO_FLUSH), &ep->regs->ep_stat);
> -	tmp = (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK);
> +	tmp = usb_endpoint_type(desc);
>  	if (tmp == USB_ENDPOINT_XFER_INT) {
>  		/* erratum 0105 workaround prevents hs NYET */
>  		if (dev->chiprev == 0100
>  				&& dev->gadget.speed == USB_SPEED_HIGH
> -				&& !(desc->bEndpointAddress & USB_DIR_IN))
> +				&& !usb_endpoint_dir_in(desc))
>  			writel ((1 << CLEAR_NAK_OUT_PACKETS_MODE),
>  				&ep->regs->ep_rsp);
>  	} else if (tmp == USB_ENDPOINT_XFER_BULK) {
> @@ -1230,8 +1231,7 @@ net2280_set_halt_and_wedge(struct usb_ep *_ep, int value, int wedged)
>  		return -EINVAL;
>  	if (!ep->dev->driver || ep->dev->gadget.speed == USB_SPEED_UNKNOWN)
>  		return -ESHUTDOWN;
> -	if (ep->desc /* not ep0 */ && (ep->desc->bmAttributes & 0x03)
> -						== USB_ENDPOINT_XFER_ISOC)
> +	if (ep->desc /* not ep0 */ && usb_endpoint_xfer_isoc(ep->desc))
>  		return -EINVAL;
>  
>  	spin_lock_irqsave (&ep->dev->lock, flags);
> diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
> index 9a2b892..31a7617 100644
> --- a/drivers/usb/gadget/s3c2410_udc.c
> +++ b/drivers/usb/gadget/s3c2410_udc.c
> @@ -1077,7 +1077,7 @@ static int s3c2410_udc_ep_enable(struct usb_ep *_ep,
>  	udc_write(max >> 3, S3C2410_UDC_MAXP_REG);
>  
>  	/* set type, direction, address; reset fifo counters */
> -	if (desc->bEndpointAddress & USB_DIR_IN) {
> +	if (usb_endpoint_dir_in(desc)) {
>  		csr1 = S3C2410_UDC_ICSR1_FFLUSH|S3C2410_UDC_ICSR1_CLRDT;
>  		csr2 = S3C2410_UDC_ICSR2_MODEIN|S3C2410_UDC_ICSR2_DMAIEN;
>  
> @@ -1112,7 +1112,7 @@ static int s3c2410_udc_ep_enable(struct usb_ep *_ep,
>  	tmp = desc->bEndpointAddress;
>  	dprintk (DEBUG_NORMAL, "enable %s(%d) ep%x%s-blk max %02x\n",
>  		 _ep->name,ep->num, tmp,
> -		 desc->bEndpointAddress & USB_DIR_IN ? "in" : "out", max);
> +		 usb_endpoint_dir_in(desc) ? "in" : "out", max);
>  
>  	local_irq_restore (flags);
>  	s3c2410_udc_set_halt(_ep, 0);
> 
> 


