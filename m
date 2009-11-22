Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbZKVIUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbZKVIUK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 03:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZKVIUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 03:20:09 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:54686 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbZKVIUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 03:20:08 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Gernot Hillier <gernot@hillier.de>
Subject: Re: [PATCH] Add support for Mobilcom Debitel USB UMTS Surf-Stick to option driver
Date: Sun, 22 Nov 2009 09:20:16 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Matthias Urlichs <smurf@smurf.noris.de>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <4B08F18C.3040904@hillier.de>
In-Reply-To: <4B08F18C.3040904@hillier.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911220920.16717.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 22. November 2009 09:08:44 schrieb Gernot Hillier:
> In addition, this device seems to ignore setting of RTS/DTR by option_send_
> setup and doesn't answer the usb_control_msg leading to a 5 s timeout
> (USB_CTRL_SET_TIMEOUT) in userspace open() and other operations. As this
> confused several impatient userspace applications like Minicom and
>  ModemManager, I decided to reduce the timeout to more reasonable 1000 ms.
>  I don't think the usual USB GSM stick needs longer, so this should be
>  safe.

Unfortunately the 5s timeout comes from the USB spec for control
messages. So reducing it is a serious matter. In this case I'd prefer
if you introduce a special case for these devices and fail the operation
without doing any IO.

	Regards
		Oliver
