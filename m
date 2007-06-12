Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbXFLWaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbXFLWaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 18:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbXFLW35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 18:29:57 -0400
Received: from terminus.zytor.com ([192.83.249.54]:47997 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbXFLW35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 18:29:57 -0400
Message-ID: <466F1E5C.5090002@zytor.com>
Date: Tue, 12 Jun 2007 15:29:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stanislav Brabec <sbrabec@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: Proposal: change keycode for scancode e0 32 from 150 to 172
References: <466F1462.5090008@hhs.nl>
In-Reply-To: <466F1462.5090008@hhs.nl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hans de Goede wrote:
> 
> In order to be able to better test / develop this I've bought 2 cheap
> such keyboards today, one ps2 and one both usb and ps2 capable.
> 
> When comparing usb vs ps2 / testing the keycodes generated for the easy
> access
> keys on my trust (microsoft compatible) keyboard. I noticed the homepage
> key sends keycode 150 with ps2 and 172 with USB, or for those who don't
> know the keycodes by head with ps2 it sends KEY_WWW and with usb it
> sends KEY_HOMEPAGE

I just tested this using Microsoft Natural Keyboard Pro, which is a
dual-mode (USB-PS/2) keyboard.

This key is labelled Web/Home and has a picture of a house on the keycap.

In PS/2 mode it reports E0 32 which gets converted to keycode 150.
In USB mode it reports E0 02 which gets converted to keycode 172.

I don't know if it's the keyboard itself that's being inconsistent, or
if it is the table in usbkbd.c that's broken (in which case it should be
fixed to be consistent with the keyboard in PS/2 mode.)

> I personally believe that the usb behaviour is correct and that the ps/2
> code should be modified to match for consistency. The ps/2 scancode to
> keycode mapping is set up to handle easy access / internet keys for
> microsoft compatible keyboards. So what is the right code to send here,
> tricky, see:
> http://www.s2.com.br/s2arquivos/361/Imagens/555Image.jpg
> http://www.keyboardco.com/keyboard_images/microsoft_ergonomic_keyboard_4000_black_usb_large.jpg
> 
> The logo on the key is a homepage logo, the text below is www/homepage.
> So what to send? I believe that for consistency with the usb codes send
> it should be KEY_HOMEPAGE, but thats based on a sample of 1 usb
> keyboard. Input on what other usb keyboards send for the key with the
> homepage iocn is very much welcome.

You seem to be of the opinion that "usb behaviour is correct", but don't
give any motivation why usb should take precedence.  Offhand, I would
expect there to be fewer translation layers for PS/2 and would therefore
assume PS/2 is more inherently correct.

	-hpa
