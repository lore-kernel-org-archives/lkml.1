Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZBKNid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZBKNid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbZBKNiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:38:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:17321 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbZBKNiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:38:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=DXgkcbr85Aj2igr2cN+mU/bAIzcfV96rRd/PK78erbmO7Q0ZErx/OcQid/AUF5rBc7
         py8ycQJnDV1HJWwp0AmNvzazWTU7TvIHwMl1278wgJE7Jj8xjf6OXVLndI87/e3H0We+
         Y248R2vcMxXO1Bva+QEg3bDdt3F5gmwZc9SeA=
Message-ID: <4992D4C3.3050108@gmail.com>
Date: Wed, 11 Feb 2009 14:38:11 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-input@vger.kernel.org
Subject: Re: dead USB devices after resume [mmotm 2009-02-10-16-35]
References: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org> <49928FDB.5020007@gmail.com> <200902111044.57869.rjw@sisk.pl> <4992A040.6080302@gmail.com>
In-Reply-To: <4992A040.6080302@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2009 10:54 AM, Jiri Slaby wrote:
> On 02/11/2009 10:44 AM, Rafael J. Wysocki wrote:
>> Please test current mainline, it may be a regression in there.
> 
> OK, will do.

I was not able to reproduce it with 1db8508. So it highly likely hasn't leaked
to the mainline.

>> How exactly are the failing devices connected to the box?
> 
> There is a hub in the kbd. The mouse and kbd is behind it, I suppose:
> 
> /:  Bus 08.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> /:  Bus 07.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> /:  Bus 06.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
>     |__ Port 1: Dev 2, If 0, Class=hub, Driver=hub/3p, 12M
>         |__ Port 1: Dev 3, If 0, Class=HID, Driver=usbhid, 12M
>         |__ Port 1: Dev 3, If 1, Class=HID, Driver=usbhid, 12M
>         |__ Port 2: Dev 4, If 0, Class=HID, Driver=usbhid, 1.5M
> /:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> /:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> /:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> /:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/6p, 480M
> /:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/6p, 480M
> 
> There is also a wheel at 6.3 if 1...
> 
> Bus 006 Device 004: ID 045e:00f0 Microsoft Corp.
> Bus 006 Device 003: ID 0458:004c KYE Systems Corp. (Mouse Systems) Slimstar Pro
> Keyboard
> Bus 006 Device 002: ID 04b4:2050 Cypress Semiconductor Corp.
> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> 
> I may try to plug the mouse directly to the root hub if it might help anyhow.

No change. Wherever it is connected it fails to emit anything.

BTW It is sufficient to unplug the mouse from the kbd (i.e. the hub) and replug
it back.
