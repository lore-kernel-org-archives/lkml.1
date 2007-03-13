Return-Path: <linux-kernel-owner+w=401wt.eu-S1751532AbXCMJyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbXCMJyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbXCMJyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:54:40 -0400
Received: from twin.jikos.cz ([213.151.79.26]:57567 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbXCMJyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:54:39 -0400
Date: Tue, 13 Mar 2007 10:54:15 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Robert Marquardt <marquardt@codemercs.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Question re hiddev
In-Reply-To: <45F650CB.1080409@codemercs.com>
Message-ID: <Pine.LNX.4.64.0703131048100.14144@twin.jikos.cz>
References: <200703081354.28281.gene.heskett@verizon.net>
 <200703090103.32583.gene.heskett@verizon.net> <20070309111947.5fa58c3c.zaitcev@redhat.com>
 <200703091928.24832.gene.heskett@verizon.net> <Pine.LNX.4.64.0703101414520.26904@twin.jikos.cz>
 <45F650CB.1080409@codemercs.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Robert Marquardt wrote:

> > as there are many Bluetooth devices with conform to HID specification
> Namely the Wii controller which is already happily used by many programmers
> through Windows HID API.

Hi Robert,

not only this piece of hardware, but many others - for example almost all 
Bluetooth keyboards and mice are capable of working both in HID and HCI 
modes, etc. The layer introduced in 2.6.20 gives them the possibility of 
using full reporting facilities of the HID layer.

> > There are still pending issues though, one of them being converting 
> > the HID layer to bus, so that individual device that don't wish the 
> > certain device to be handled by generic HID code, register on this HID 
> > bus and handle the HID events from given device in a unified way (for 
> > example current Wacom driver would use this facility, among other). As 
> > a bonus, this is going to shrink the hid_blacklist, which currently 
> > has to contain all devices for which there are specialized drivers.
> Ah, this means our iowarrior driver will be shortlived.

I don't think so. Firstly, it will take some time until the HID layer is 
converted to bus, as I have another things pending. Secondly, the 
iowarrior driver will still be needed to handle the HW-specific reports 
that won't be handled by the generic HID layer, it would only have to be 
changed to register through the HID bus.

> Do you know the Windows HID API? It would be nice to take it into 
> account so that a compatible API can be written. 

No, I don't know Windows HID api at all. Is it worth looking at?

> Mainly this needs a way to add a ReportID of 0x00 to reports from 
> devices without ReportIDs and access to the HID descriptor so the usages 
> can be extracted from a report.

Just a sidenote - this is in fact what I am currently implementing also 
for the new hidraw userspace interface.

Thanks,

-- 
Jiri Kosina
