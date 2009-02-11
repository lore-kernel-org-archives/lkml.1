Return-Path: <linux-kernel-owner+w=401wt.eu-S1758425AbZBKVuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425AbZBKVuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZBKVue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:50:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57264 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbZBKVuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:50:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: dead USB devices after resume [mmotm 2009-02-10-16-35]
Date: Wed, 11 Feb 2009 22:49:56 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-tst; KDE/4.2.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-input@vger.kernel.org
References: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org> <4992A040.6080302@gmail.com> <4992D4C3.3050108@gmail.com>
In-Reply-To: <4992D4C3.3050108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902112249.57070.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 February 2009, Jiri Slaby wrote:
> On 02/11/2009 10:54 AM, Jiri Slaby wrote:
> > On 02/11/2009 10:44 AM, Rafael J. Wysocki wrote:
> >> Please test current mainline, it may be a regression in there.
> > 
> > OK, will do.
> 
> I was not able to reproduce it with 1db8508. So it highly likely hasn't leaked
> to the mainline.

Great, thanks for verifying!

> >> How exactly are the failing devices connected to the box?
> > 
> > There is a hub in the kbd. The mouse and kbd is behind it, I suppose:
> > 
> > /:  Bus 08.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> > /:  Bus 07.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> > /:  Bus 06.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> >     |__ Port 1: Dev 2, If 0, Class=hub, Driver=hub/3p, 12M
> >         |__ Port 1: Dev 3, If 0, Class=HID, Driver=usbhid, 12M
> >         |__ Port 1: Dev 3, If 1, Class=HID, Driver=usbhid, 12M
> >         |__ Port 2: Dev 4, If 0, Class=HID, Driver=usbhid, 1.5M
> > /:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> > /:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> > /:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> > /:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/6p, 480M
> > /:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/6p, 480M
> > 
> > There is also a wheel at 6.3 if 1...
> > 
> > Bus 006 Device 004: ID 045e:00f0 Microsoft Corp.
> > Bus 006 Device 003: ID 0458:004c KYE Systems Corp. (Mouse Systems) Slimstar Pro
> > Keyboard
> > Bus 006 Device 002: ID 04b4:2050 Cypress Semiconductor Corp.
> > Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > 
> > I may try to plug the mouse directly to the root hub if it might help anyhow.
> 
> No change. Wherever it is connected it fails to emit anything.
> 
> BTW It is sufficient to unplug the mouse from the kbd (i.e. the hub) and replug
> it back.

Well, I thought it might be an ordering issue, but apparently it isn't.

Thanks,
Rafael
