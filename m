Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbXGCXyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbXGCXyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 19:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbXGCXyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 19:54:38 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:63223 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbXGCXyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 19:54:37 -0400
Date: Tue, 03 Jul 2007 17:53:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] libata_acpi: A different strategy for using ACPI
 information
In-reply-to: <fa.rEwk8NvbygVfpOfb23QZ97ZMeXs@ifi.uio.no>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Message-id: <468AE196.9070202@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.rEwk8NvbygVfpOfb23QZ97ZMeXs@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Lots of BIOSen simply return the BIOS set modes via the ACPI methods and
> pass back the values you give it across suspend/resume. Thus instead of
> trying to do clever stuff with this data we instead use it as a way to
> take a sneak peak at cable type information when viable. This should help
> us catch more of the laptops that do weird stuff, the VIA SATA bridges
> and the totally horked Nvidia cable handling.
> 
> For now its only used by the VIA and AMD/NV driver until we get a better
> idea of whether this is a sensible idea or not.
> 
> Opinions ?
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Looks fairly reasonable to me. However, I suspect any use of _GTM is 
somewhat dangerous (at least after the resume) unless we use the _STM 
and _GTF methods in the proper sequence when resuming. (Is that in the 
-mm tree now?)

Keep in mind that in the pata_acpi case where we don't do anything to 
program the hardware directly, we can still use _STM to program a lower 
speed than the BIOS chose if we decide to do this. Windows does indeed 
do this (you can force PIO mode in the control panel, and it will also 
reduce UDMA speeds or drop to PIO if there are too many CRC errors or 
timeouts), so this should be safe. We just had better be sure that the 
speed we give it is valid, since there is no sane way for the function 
to indicate failure. (Thus the problem with the "cram in all possible 
values to see what it supports" strategy for determining mode limits..)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

