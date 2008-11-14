Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbYKNTUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbYKNTUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYKNTUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:20:44 -0500
Received: from mail.hauppauge.com ([167.206.143.4]:3619 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbYKNTUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:20:43 -0500
X-Greylist: delayed 925 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2008 14:20:43 EST
Message-ID: <491DCBDD.4000703@linuxtv.org>
Date: Fri, 14 Nov 2008 14:05:01 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-maintainer <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] dvb: usb vendor_ids/product_ids
 are	__le16
References: <1226686796.5483.33.camel@brick>
In-Reply-To: <1226686796.5483.33.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey, et al:

Harvey Harrison wrote:
> Noticed by sparse:
> drivers/media/dvb/dvb-usb/af9015.c:756:25: warning: restricted __le16 degrades to integer
> drivers/media/dvb/dvb-usb/af9015.c:744:28: warning: restricted __le16 degrades to integer
>
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/media/dvb/dvb-usb/af9015.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
> index 4b2af32..eb4495a 100644
> --- a/drivers/media/dvb/dvb-usb/af9015.c
> +++ b/drivers/media/dvb/dvb-usb/af9015.c
> @@ -742,7 +742,7 @@ static int af9015_read_config(struct usb_device *udev)
>  			}
>  		} else {
>  			switch (udev->descriptor.idVendor) {
> -			case USB_VID_LEADTEK:
> +			case cpu_to_le16(USB_VID_LEADTEK):
>  				af9015_properties[i].rc_key_map =
>  				  af9015_rc_keys_leadtek;
>  				af9015_properties[i].rc_key_map_size =
>   


Wouldn't it be nicer to just switch on 
cpu_to_le16(udev->descriptor.idVendor) ?  This would be a 1-line change, 
compile to a smaller footprint, and be easier to read.

Personally, I prefer to try to avoid duplicating code in places where a 
single operation may occur centrally.

Regards,

Mike
