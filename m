Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbXF2I35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbXF2I35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 04:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbXF2I3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 04:29:48 -0400
Received: from s131.mittwaldmedien.de ([62.216.178.31]:25158 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbXF2I3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 04:29:47 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Clemens Koller <clemens.koller@anagramm.de>
Subject: Re: 2.6.21.5: BUG: usbtouchscreen.c DMC TSC-10 wrong descriptor type / type->init() failed.
Date: Fri, 29 Jun 2007 10:29:40 +0200
User-Agent: KMail/1.9.5
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       daniel.ritz@gmx.ch
References: <468294E4.40801@anagramm.de> <d120d5000706271004u5e2304dekd4ad5315cdd4a55@mail.gmail.com> <4683D444.5030408@anagramm.de>
In-Reply-To: <4683D444.5030408@anagramm.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706291029.40779.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> After the reset, I got a 0x06 0x00 back, which is fine.
>
> But when the driver sets the coordinate output rate, the
> TSC-103 answered 0x15 0x01 which means that the TSC-10 is used
> with an EEPROM but the EEPROM data is empty (which is
> correct).
>
> In that case the driver should at least continue to allow
> initialization of the EEPROM later on.

No, I don't think so. Not in it's current form.


Currently, usbtouchscreen doesn't have any means to initialize an 
EEPROM. And in the absence of such a possibility, you need other 
means to accomplish your task. The current behavior provides you 
with this "plan b":

If you set the rate and that doesn't work because no EEPROM is 
there, the driver fails. While doing it, it will release the 
device.

This brings in the opportunity to access the touchscreen 
controller from userspace, e.g. with libusb, and write the 
EEPROM. After this, reboot, and be happy. Because now the device 
would act correctly on the "set rate" command and would be 
usable.
