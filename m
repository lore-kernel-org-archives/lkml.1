Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbZEZSiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbZEZSiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbZEZSiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:38:12 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37594 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbZEZSiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oR2O1CkX1yQeFHlIqJsl19v0fC/F1LFbDZkAr4szXS4Wy+GtYBpfJIt+ZpJwiVYyV4
         cU/bAHNF475661MDkXSpG9z0us2UiOCLVcpQFEvSiqkJIZWR7xsIm1gp2n77X9ulMA/L
         aIivfq35fyPIp+DF0X4GQ+56GJM0Pq5Q3gmEg=
MIME-Version: 1.0
In-Reply-To: <20090526174213.806710164@linux.intel.com>
References: <20090526174012.423883376@linux.intel.com>
	 <20090526174213.806710164@linux.intel.com>
Date: Tue, 26 May 2009 14:32:45 -0400
X-Google-Sender-Auth: d99579eb8a0a516f
Message-ID: <37219a840905261132q6b0a7289x3408fb904ddf90df@mail.gmail.com>
Subject: Re: [PATCH 4/6] dvb/dvb-usb: prepare for FIRMWARE_NAME_MAX removal
From: Michael Krufky <mkrufky@kernellabs.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 1:40 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> From: Samuel Ortiz <sameo@linux.intel.com>
> To: Mauro Carvalho Chehab <mchehab@infradead.org>
>
> We're going to remove the FIRMWARE_NAME_MAX definition in order to avoid any
> firmware name length restriction.
> This patch changes the dvb_usb_device_properties firmware field accordingly.
>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
>
> ---
>  drivers/media/dvb/dvb-usb/dvb-usb.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: iwm-2.6/drivers/media/dvb/dvb-usb/dvb-usb.h
> ===================================================================
> --- iwm-2.6.orig/drivers/media/dvb/dvb-usb/dvb-usb.h    2009-05-26 17:24:36.000000000 +0200
> +++ iwm-2.6/drivers/media/dvb/dvb-usb/dvb-usb.h 2009-05-26 17:25:19.000000000 +0200
> @@ -196,7 +196,7 @@ struct dvb_usb_device_properties {
>  #define CYPRESS_FX2     3
>        int        usb_ctrl;
>        int        (*download_firmware) (struct usb_device *, const struct firmware *);
> -       const char firmware[FIRMWARE_NAME_MAX];
> +       const char *firmware;
>        int        no_reconnect;
>
>        int size_of_priv;
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Samuel,

Your patch makes the following change:

-       const char firmware[FIRMWARE_NAME_MAX];
+       const char *firmware;

Before your change, struct dvb_usb_device_properties actually contains
memory allocated for the firmware filename.  After your change, this
is nothing but a pointer.

This will cause an OOPS.

Regards,

Mike Krufky
