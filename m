Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYBPMwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYBPMwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 07:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYBPMwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 07:52:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:30304 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbYBPMwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 07:52:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=A0ngWcE/lCSvU3BHsRHUW/JD9kpqPuKQp8+IRBFX36bnZQd3ur8dbE4/e6gZGWDk3gtNj54DlTfc5GMZ/PYDsdo/gyPtZ2ZnZCtUrUB7cCqomf4X0X6PMov3KABKC1XFZOvSKRyv/ZJwMF7ABLRH+3pyarG1dM96j+9b2RC0wKA=
Message-ID: <47B6DC7A.3040308@gmail.com>
Date: Sat, 16 Feb 2008 13:52:10 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Stephan Rose <stephan@eciinternational.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: PL2303 Driver missing support for USB to Serial Cable
References: <1203001060.8420.11.camel@software>
In-Reply-To: <1203001060.8420.11.camel@software>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2008 03:57 PM, Stephan Rose wrote:
> I recently purchased a USB->Com Port serial cable from Radio Shack
> (Model number 26-183) which did no seem to want to work. After looking
> into it I discovered that it is based on the Prolific chipset using the
> PL2303 driver. 
> 
> I then checked the Vendor and Product ID against the list in the drive
> and sure enough, the IDs were missing in the driver.
> 
> So here are my modifications to the PL2303 driver which have been
> working flawlessly on my system the whole week:
> 
> drivers/usb/serial/pl2303.h
> --------
> 
> /* Radio Shack 26-183 */
> #define RADIOSHACK26183_VENDOR_ID 0x05ad
> #define RADIOSHACK26183_PRODUCT_ID 0x0fba
> 
> drivers/usb/serial/pl2303.c
> --------
> 
> Added to struct usb_device_id id_table
> 
> { USB_DEVICE(RADIOSHACK26183_VENDOR_ID RADIOSHACK26183_PRODUCT_ID) }
> 
> I still have to manually modprobe the module as the kernel won't
> automatically load it when I connect the device, no idea what I would
> need to change where for that to happen.
> 
> The above though does successfully add support for that serial cable so
> I thought I'd share it with the kernel list so that it can possibly be
> added to the kernel and I can stop having to re-compile the driver every
> kernel update. :)

Well, would you mind creating, testing and posting a patch?
