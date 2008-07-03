Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbYGCOIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbYGCOIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYGCOIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:08:20 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:32947 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbYGCOIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:08:19 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [Bug 10868] Oops on loading ipaq module since 2.6.26, prevents use of device
Date: Thu, 3 Jul 2008 16:08:44 +0200
User-Agent: KMail/1.9.9
Cc: Adam Williamson <awilliamson@mandriva.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org,
       Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Matthias Geissert <matthias.geissert@web.de>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik> <200807031005.59691.oliver@neukum.org> <20080703085733.GB11254@cs181140183.pp.htv.fi>
In-Reply-To: <20080703085733.GB11254@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031608.46457.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 03 Juli 2008 10:57:33 schrieb Adrian Bunk:
> On Thu, Jul 03, 2008 at 10:05:57AM +0200, Oliver Neukum wrote:
 
> > As far as I can tell somebody changed the ipaq driver in 2.6.26-rc6. I cannot
> > find the exact patch that did it in Greg's directory. As it causes a regression
> > here's a reversal.
> 
> 
> It was changed by:

Thanks, did you do git magic?

> commit e1879b19b0abdb387e4aeb0b935a486cc75042fb
> Author: Matthias Geissert <matthias.geissert@web.de>
> Date:   Thu Mar 6 22:00:33 2008 +0100
> 
>     USB: ipaq: fix devices having more than one endpoint
>     
>     The ipaq module  supports devices with one endpoint only. Some devices,
>     e.g. Yakumo Delta 300, have more than one endpoint.
>     
>     This patch fixes support for devices having up to 2 endpoints which used
>     to work on older kernel versions.
>     
>     Signed-off-by: Matthias Geissert <matthias.geissert@web.de>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> diff --git a/drivers/usb/serial/ipaq.c b/drivers/usb/serial/ipaq.c
> index 9b38a08..17f2a53 100644
> --- a/drivers/usb/serial/ipaq.c
> +++ b/drivers/usb/serial/ipaq.c
> @@ -571,9 +571,9 @@ static struct usb_serial_driver ipaq_device = {
>  	.usb_driver = 		&ipaq_driver,
>  	.id_table =		ipaq_id_table,
>  	.num_interrupt_in =	NUM_DONT_CARE,
> -	.num_bulk_in =		1,
> -	.num_bulk_out =		1,
> -	.num_ports =		1,
> +	.num_bulk_in =		NUM_DONT_CARE,
> +	.num_bulk_out =		NUM_DONT_CARE,

This is good.

> +	.num_ports =		2,

This is fatal.

The patch I sent reverts only this part, so this issue is solved.

	Regards
		Oliver
