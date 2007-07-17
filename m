Return-Path: <linux-kernel-owner+w=401wt.eu-S933632AbXGQPB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbXGQPB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXGQPBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:01:51 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:28170 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXGQPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:01:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C0KenE3ZaLnQqNJDzWJy74GQL71hVbCel+5fu/6XlKFLV/oVhNfnb1ZD3Mrf/ASyR9FMQLyRgqNODMT+QXSB1Y6WQINjD+vmuCUAEx3vjUycl/IbnymWtV/AfUdYZqsKnSZNDuJD4kuo/ehKHt5ko22nLKzsB+T9kbGeAjYxWEo=
Message-ID: <d120d5000707170801u27e11936h9546bd36da7a1162@mail.gmail.com>
Date: Tue, 17 Jul 2007 11:01:48 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: [PATCH] appletouch powersaving - please apply for 2.6.23-rc1
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Nicolas Boichat" <nicolas@boichat.ch>,
       "Michael Hanselmann" <linux-kernel@hansmi.ch>,
       "Peter Osterlund" <petero2@telia.com>,
       "Frank Arnold" <frank@scirocco-5v-turbo.de>,
       "Stelian Pop" <stelian@popies.net>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Greg Kroah-Hartman" <greg@kroah.com>
In-Reply-To: <1184656218.14051.43.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184656218.14051.43.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 7/17/07, Soeren Sonnenburg <kernel@nn7.de> wrote:
>
>  err_free_buffer:
> @@ -656,6 +699,7 @@ static void atp_disconnect(struct usb_interface *iface)
>
>        usb_set_intfdata(iface, NULL);
>        if (dev) {
> +               cancel_work_sync(&dev->work);
>                usb_kill_urb(dev->urb);
>                input_unregister_device(dev->input);
>                usb_buffer_free(dev->udev, dev->datalen,
>

This should go into atp_close() and I think you need to do
cancel_work_sync after calling usb_kill_urb() otherwise you risk it
being submitted while you gettingto kill the urb.

How many boxes did you try this patch on?

-- 
Dmitry
