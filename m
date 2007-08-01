Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbXHAHW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbXHAHW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbXHAHWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:22:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56487 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbXHAHWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:22:18 -0400
Message-ID: <46B03468.3010307@netcom.eu>
Date: Wed, 01 Aug 2007 09:21:12 +0200
From: David Engraf <david.engraf@netcom.eu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       gregkh@suse.de, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB BIOS early handoff only when the
 we the driver is configured
References: <Pine.LNX.4.44L0.0707311058470.3520-100000@iolanthe.rowland.org> <46B03078.5040305@netcom.eu>
In-Reply-To: <46B03078.5040305@netcom.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19lghxdU8OtVpxBwt8/oJVJ2OwFXEA/Yfs4ous
 +An0l4aEnc39sCw+aLvuFhU92lUXiHiJkiBOGq5uOsDnIZCFqp
 LXBsd3FXPDgch6dvV87RQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment I have a Jetway/VIA Mainboard which seems to have a
problem with the handoff.
Evenwhen I wait about 20 seconds the EHCI_USBLEGSUP_BIOS flag is not
cleared. I think this is a BIOS
bug and I will have to talk to Jetway/VIA.
On the other hand, I don't need the EHCI controller in my kernel, so I
think the kernel shouldn't take the
handover for the EHCI controller like other OS which do not have an usb
driver and so don't know that
there is a EHCI_USBLEGSUP_BIOS flag which should be cleared.

David Engraf


Alan Stern schrieb:
> On Tue, 31 Jul 2007, David Engraf wrote:
>
>   
>> When CONFIG_USB_UHCI_HCD, CONFIG_USB_OHCI_HCD or CONFIG_USB_EHCI_HCD is
>> not configured we don't need to call the quirk_usb_handoff_xxxx function
>> in driver/usb/host/pci_quiks.c.
>>
>> I think the kernel shouldn't take the control over the usb controller
>> when we don't have the driver for it,
>> so with this patch the kernel takes the control only when the driver is
>> configured.
>>     
>
> Have you found a system where this really improves behavior or is it 
> just theoretical?
>
> There _is_ a theoretical reason for running the handoff routines even 
> when the corresponding driver isn't configured.  Namely, at startup the 
> controller will be in some undetermined state as a result of usage by 
> the firmware.  Resetting it to a known idle state is a good idea.
>
> Bear in mind that on some systems, not performing the handoff has
> caused interrupt storms during startup.
>
> Alan Stern
>
>   
>

-- 
Mit freundlichen Grüßen

 

David Engraf

 

 
Netcom Sicherheitstechnik GmbH
Rheinallee 189
55120 Mainz
Tel: 	+49 6131 6305 0
Fax: 	+49 6131 6305 40
Email: 	david.engraf@netcom.eu

 
Sitz der Gesellschaft: Mainz
Registergericht: Amtsgericht Mainz, 14HRB3411
Geschäftsführer: Peter Otto

