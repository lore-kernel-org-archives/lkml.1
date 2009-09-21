Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZIUUR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZIUUR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 16:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbZIUUR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 16:17:28 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:50999 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZIUUR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 16:17:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qvAkbjB2q9vdEfczVSeDSLtKy8A1yX3L/Oe8OKSJUPIxcdQSYOnOVn3gMaSonbDRut
         aL5JsC5vj68GRY/9oBwy6PHtJXTqL7H7Rxnc507hLkesePHgKMpNMnouOIgHsxnx5BmB
         UH+DZLj1+R1Re5A+5w778QQKVUUFiOk18t2XA=
Message-ID: <4AB7DF4E.9040703@gmail.com>
Date: Mon, 21 Sep 2009 22:17:18 +0200
From: Henk Martijn <h.h.martijn@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-0.1-default-07068-g43c1266 lockdep warning and scheduling
 while atomic BUG
References: <1253560490.2934.42.camel@localhost> <4AB7D9B8.6000501@gmail.com> <200909212204.50047.oliver@neukum.org>
In-Reply-To: <200909212204.50047.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes that worked, Thanks!

/Henk

Oliver Neukum wrote:
> Am Montag, 21. September 2009 21:53:28 schrieb Henk Martijn:
>> This is a i7 based DELL and current git throws the following warning and
>> bug at me during boot:
> 
> Please try this patch
> 
> 	Regards
> 		Oliver
> 
> --
> 
> commit ca5c4a1397d1a1c0d1074f4d8922630fdd732780
> Author: Oliver Neukum <oliver@neukum.org>
> Date:   Mon Sep 21 22:02:01 2009 +0200
> 
>     hid:usbhid: fix wrong use of GFP_KERNEL
>     
>     hid_input_report() must be told it is called in interrupt context
> 
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index 1b0e07a..ab2869d 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -455,7 +455,7 @@ static void hid_ctrl(struct urb *urb)
>  		if (usbhid->ctrl[usbhid->ctrltail].dir == USB_DIR_IN)
>  			hid_input_report(urb->context,
>  				usbhid->ctrl[usbhid->ctrltail].report->type,
> -				urb->transfer_buffer, urb->actual_length, 0);
> +				urb->transfer_buffer, urb->actual_length, 1);
>  		break;
>  	case -ESHUTDOWN:	/* unplug */
>  		unplug = 1;
> 
> 

