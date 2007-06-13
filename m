Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbXFMFx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbXFMFx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 01:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXFMFxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 01:53:20 -0400
Received: from smtp3.versatel.nl ([62.58.50.90]:49275 "EHLO smtp3.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064AbXFMFxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 01:53:19 -0400
Message-ID: <466F897C.4050109@hhs.nl>
Date: Wed, 13 Jun 2007 08:06:52 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stanislav Brabec <sbrabec@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: Proposal: change keycode for scancode e0 32 from 150 to 172
References: <466F1462.5090008@hhs.nl> <466F1E5C.5090002@zytor.com>
In-Reply-To: <466F1E5C.5090002@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hans de Goede wrote:
>> In order to be able to better test / develop this I've bought 2 cheap
>> such keyboards today, one ps2 and one both usb and ps2 capable.
>>
>> When comparing usb vs ps2 / testing the keycodes generated for the easy
>> access
>> keys on my trust (microsoft compatible) keyboard. I noticed the homepage
>> key sends keycode 150 with ps2 and 172 with USB, or for those who don't
>> know the keycodes by head with ps2 it sends KEY_WWW and with usb it
>> sends KEY_HOMEPAGE
> 
> I just tested this using Microsoft Natural Keyboard Pro, which is a
> dual-mode (USB-PS/2) keyboard.
> 
> This key is labelled Web/Home and has a picture of a house on the keycap.
> 
> In PS/2 mode it reports E0 32 which gets converted to keycode 150.
> In USB mode it reports E0 02 which gets converted to keycode 172.
> 

Thanks, that confirms that the ps/2 translation (which assumes a microsoft or 
compatible keyboard) is wrong.

> I don't know if it's the keyboard itself that's being inconsistent, or
> if it is the table in usbkbd.c that's broken (in which case it should be
> fixed to be consistent with the keyboard in PS/2 mode.)
> 

See below.

>> I personally believe that the usb behaviour is correct and that the ps/2
>> code should be modified to match for consistency. The ps/2 scancode to
>> keycode mapping is set up to handle easy access / internet keys for
>> microsoft compatible keyboards. So what is the right code to send here,
>> tricky, see:
>> http://www.s2.com.br/s2arquivos/361/Imagens/555Image.jpg
>> http://www.keyboardco.com/keyboard_images/microsoft_ergonomic_keyboard_4000_black_usb_large.jpg
>>
>> The logo on the key is a homepage logo, the text below is www/homepage.
>> So what to send? I believe that for consistency with the usb codes send
>> it should be KEY_HOMEPAGE, but thats based on a sample of 1 usb
>> keyboard. Input on what other usb keyboards send for the key with the
>> homepage iocn is very much welcome.
> 
> You seem to be of the opinion that "usb behaviour is correct", but don't
> give any motivation why usb should take precedence.  Offhand, I would
> expect there to be fewer translation layers for PS/2 and would therefore
> assume PS/2 is more inherently correct.
> 

I'm of the opinion that the USB behaviour is correct, because usb generates the 
172 / KEY_HOMEPAGE in accordance with:
http://www.usb.org/developers/devclass_docs/Hut1_12.pdf
Page 84

Where as in the ps2 world there is no official scancode mapping for these 
special keys, hence I talk about microsoft and compatibles. Also the number of 
layers of translation in both cases is just 1: one table (ps2) versus one 
switch statement (usb)

Regards,

Hans
