Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbXHGIsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbXHGIsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 04:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbXHGIsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 04:48:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51931 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784AbXHGIsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 04:48:15 -0400
Message-ID: <46B83109.8060808@netcom.eu>
Date: Tue, 07 Aug 2007 10:44:57 +0200
From: David Engraf <david.engraf@netcom.eu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <gregkh@suse.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB BIOS early handoff only when the
 we the driver is configured
References: <Pine.LNX.4.44L0.0708031101530.2597-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0708031101530.2597-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19OuhSdazCNzqhpZKa5+ns46CNuC60hQSABhCb
 MiVK7Qk9rZo9L5E/sQDso0GfeCuTEurAMduRsgbvZ3M7pLKfDe
 updm3+juEafYLlm8Uc4VQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You said your Intel board has also problems with the handoff.
Could you try the follwing patch, because the EHCI documentation
says that the OS must set the EHCI_USBLEGSUP_OS bit and then
wait until EHCI_USBLEGSUP_BIOS is cleared. The kernel never
uses the EHCI_USBLEGSUP_OS flag at the moment.
On my system there is no change, but maybe this patch works on
your system.

Thanks
David Engraf

linux-2.6.22.1

diff -puN drivers/usb/host/pci-quirks_orig.c drivers/usb/host/pci-quirks.c

--- drivers/usb/host/pci-quirks_orig.c    2007-07-10 20:56:30.000000000
+0200
+++ drivers/usb/host/pci-quirks.c    2007-08-07 10:38:33.000000000 +0200
@@ -268,6 +268,8 @@ static void __devinit quirk_usb_disable_
                  * handoff..
                  */
                 pci_write_config_byte(pdev, offset + 3, 1);
+
+                pci_write_config_byte(pdev, offset, cap |
EHCI_USBLEGSUP_OS);
             }
 
             /* if boot firmware now owns EHCI, spin till


Alan Stern schrieb:
> On Fri, 3 Aug 2007, David Engraf wrote:
>
>   
>> So we have hardware which has problems when we are not doing the
>> handoff, and hardware which has
>> problems when we are  doing the handoff...
>>     
>
> What hardware has problems when we do the handoff?  Your system and 
> mine experience a delay, but it doesn't break anything.
>
>   
>> What is the best way to solve the problem? Maybe a kernel parameter, a
>> config flag or an automatic
>> hardware dependent check of the system?
>> In fact it is hard to find a solution which works for both as long as
>> the hardware has this bugs.
>>     
>
> If we really need it, I say we should use a Kconfig flag.
>
> Alan Stern
>
>   

