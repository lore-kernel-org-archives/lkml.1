Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbYG0BsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbYG0BsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 21:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbYG0BsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 21:48:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:28358 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbYG0BsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 21:48:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=c6LDuXlSZMp/Ss/Dj6kYwjWe3vjuyi4b25g74ixzxno/G3YyDVVgW8PckxXj0DeZyE
         HM91OiMc40wXEL1nxRP+M68YElsDk8RsZ053r6VUrP/uahF+wSvk0a0f8p4g/DRlcIRY
         2j0WeeBw2HXdDlhUGyolVsNNP+OlZCLx7x2hI=
Message-ID: <86802c440807261848g3bb3e87dh121d1f11f6f64d77@mail.gmail.com>
Date: Sat, 26 Jul 2008 18:48:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH] usb: don't hide bios bug warning
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080727012454.GA22219@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807261812.15836.yhlu.kernel@gmail.com>
	 <20080727012454.GA22219@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 6:24 PM, Greg KH <gregkh@suse.de> wrote:
> On Sat, Jul 26, 2008 at 06:12:15PM -0700, Yinghai Lu wrote:
>>
>> quirk_usb_disable_handoff will wait a while if there is BIOS bug.
>> let the end user know the reason for that.
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> ---
>>  drivers/usb/host/pci-quirks.c |    9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> Index: linux-2.6/drivers/usb/host/pci-quirks.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/usb/host/pci-quirks.c
>> +++ linux-2.6/drivers/usb/host/pci-quirks.c
>> @@ -190,7 +190,8 @@ static void __devinit quirk_usb_handoff_
>>                       msleep(10);
>>               }
>>               if (wait_time <= 0)
>> -                     dev_warn(&pdev->dev, "OHCI: BIOS handoff failed"
>> +                     dev_printk(KERN_WARNING, &pdev->dev,
>> +                                     "OHCI: BIOS handoff failed"
>
> This is the exact same thing here, no change.
>
>> @@ -242,7 +243,8 @@ static void __devinit quirk_usb_disable_
>>               switch (cap & 0xff) {
>>               case 1:                 /* BIOS/SMM/... handoff support */
>>                       if ((cap & EHCI_USBLEGSUP_BIOS)) {
>> -                             dev_dbg(&pdev->dev, "EHCI: BIOS handoff\n");
>> +                             dev_printk(KERN_DEBUG, &pdev->dev,
>> +                                             "EHCI: BIOS handoff\n");
>
> Is this what you really want to see?  But you just made things noiser.
>
>> @@ -283,7 +285,8 @@ static void __devinit quirk_usb_disable_
>>                               /* well, possibly buggy BIOS... try to shut
>>                                * it down, and hope nothing goes too wrong
>>                                */
>> -                             dev_warn(&pdev->dev, "EHCI: BIOS handoff failed"
>> +                             dev_printk(KERN_WARNING, &pdev->dev,
>> +                                             "EHCI: BIOS handoff failed"
>
> This is the exact same thing, no change.
>
> confused,

end user will not set CONFIG_USB_DEBUG, so that dev_warn will do nothing.

YH
