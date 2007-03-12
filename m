Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbXCLUiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbXCLUiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXCLUiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:38:08 -0400
Received: from outmx020.isp.belgacom.be ([195.238.4.201]:40575 "EHLO
	outmx020.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbXCLUiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:38:07 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Configuring generic drivers at runtime
Date: Mon, 12 Mar 2007 21:39:10 +0100
User-Agent: KMail/1.9.6
References: <200703102357.17661.laurent.pinchart@skynet.be>
In-Reply-To: <200703102357.17661.laurent.pinchart@skynet.be>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703122139.10504.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

as I got no reply to my previous e-mail, I assume it got stopped by 
grammar-checking filters, so I fixed the subject line :-) (this is what 
happens when you write the first word and the rest of the title 10 minutes 
apart). More seriously, this is a generic architecture issue which I'd like 
to get right. If nobody has any opinion on the subject, I'll just go on and 
implement my idea. But if something isn't going to be accepted in the 
mainline kernel, I'd rather find out now to spend time on finding a better 
idea.

Best regards,

Laurent Pinchart

> Hi everybody,
>
> I'm writing a Linux driver for USB Video Class (UVC) devices. Before
> submitting it to the kernel, there are still a few rough corners I'd like
> to polish. Comments would be appreciated for the following one.
>
> The UVC spec defines a way for device vendors to provide extensions to the
> standard through so-called extension units, identified by a GUID (Globally
> Unique IDentifier). An extension unit can define any number of controls
> (think of controls as simple parameters such as brightness, zoom, pan/tilt,
> shutter speed, ...). Devices advertise in their USB descriptors the
> extension units they support, along with the controls that are supported in
> each extension unit.
>
> To access those extension units from user-space, the UVC driver will offer
> two methods. One of them will map the controls defined by extension units
> to V4L2 controls. The question that arises is how to define and store those
> mappings.
>
> And obvious solution would be to have an ever growing array in the driver,
> storing control information for all possible extension units ever defined
> by webcam vendors. While this is quite straightforward, it might not be the
> most usable solution for device vendors who wouldn't want debug controls to
> be included in the kernel by default, or who wouldn't want to submit new
> control definitions for inclusion in the kernel (with the implied delay)
> every time a new device comes out.
>
> Another solution would be to introduce a way to define controls and
> mappings at runtime. Mappings would be stored in text-based user-space
> configuration files, distributed by vendors. A small user-space utility
> would add them through a few ioctls. This obviously raises some security
> concerns (regarding which users will be allowed to add mappings, or how
> many of them they can add).
>
> I would like comments regarding the second solution. Is this something that
> is likely to be accepted in the mainline kernel ? I don't know of any other
> Linux driver implementing such kind of dynamic runtime configuration.
>
> Best regards,
>
> Laurent Pinchart
