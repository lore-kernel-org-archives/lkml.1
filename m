Return-Path: <linux-kernel-owner+w=401wt.eu-S1946053AbXEAXCC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946053AbXEAXCC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:02:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946055AbXEAXCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:02:01 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:55425 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946053AbXEAXB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:01:59 -0400
Message-ID: <4637C651.9080102@gmail.com>
Date: Wed, 02 May 2007 00:59:29 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org> <4637A3F6.70508@gmail.com> <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2007 11:41 PM, Linus Torvalds wrote:

> The standard extended modes are actually really useful, if for a very 
> simply reason: they give you bigger more lines on screen when a bug 
> happens.
> 
> So I _still_ occasionally use "vga=extended" just for that reason. The  
> default 80x25 thing scrolls most oops away.

Not the right time, but I've wanted to ask for ages... why can't we keep 
hardware scrolling through the VGA text buffer on a OOPS available from 
Shift-PageUp/Down? With hardware scrolling it's really minimal code IIRC.

>> I'd consider keeping anything but VESA 1.2 (which that ET4000 and most all
>> other Super VGA cards of the era also do!) nonsensical and as far as I'm
>> concerned this includes all the VGA modes with the strange number of lines; a
>> 43/60-line VGA screen is too horrible to look at anyway...
> 
> 80x50 is useful for the above reason. Yeah, it's ugly, but it's useful for 
> the "It's too much work to try to do anything but just take a digital 
> photo of the screen". And that 50-line mode will actually be 43 in EGA 
> mode, I think.
> 
> The 132x50 mode is probably a bit prettier, and is fairly common too, and 
> useful for the same reason.
> 
> And once you support those, you might as well support all the VESA text 
> modes.

Yes, keeping VESA is sensible if you keep anything but note that many of the 
extended text modes video.S can set are not VESA modes but modes available 
on any standard VGA through tweaking VGA registers. The standard VGA text 
modes are:

Mode 0/1:	40x25 (monochrome/colour)
Mode 2/3:	80x25 (monochrome/colour)
Mode 7:		80x25 (monochrome, MDA/Hercules)

VESA 1.2 adds text modes:

Mode 0x108:	80x60
Mode 0x109:	132x25
Mode 0x10a:	132x43
Mode 0x10b:	132x50
Mode 0x10c:	132x60

That 80x43 mode is one of the "specially tweaked VGA modes" (by using a 8x8 
character cell instead of the normal 8x14 on the 640x350 screen; it turns 
into 80x50 on 640x400).

Well, yes, for symetry with the 132x VESA fonts I guess that 80x43/50 may be 
kept; they're sort of "standard" in the sense that they've been widely used 
  and VESA probably only didn't include them since that was the case already 
anyway. And you can set them through standard BIOS calls to replace the font.

But note there are also tweaked "80x28", "80x30", "80x34", and "80x60" modes 
there that I feel do not serve any purpose whatsoever and do make for rather 
involved code that I expect HPA wouldn't so much mind killing. Having:

1) the standard CGA/MDA/HGA/EGA/VGA modes on an adapter that can do them
2) 80x43/80x50 on the EGA/VGA
3) the VESA 1.2 alphanumeric modes if we have VESA.

should really be enough I feel (and 2 only since it's simple and well-known)

> And yes, I'm literally talking about the *text* modes. Not all of us want 
> to have fbcon built in - I prefer my text-mode lean and mean and fast as 
> hell, and if I want a frame buffer, I'll take X11, thank you very much.

I agree and don't use fbcon myself. This is (slowly, very slowly) becoming a 
bit of an obsolete standpoint even on a PC though; doing away with VGA may 
not be all that bad on new machines. And with the absolutely horrible 
interpolation TFTS do on anything but their native resolutions, looking at a 
640x350/400 screen is sometimes almost too painful even for short purposes 
when you have one of those.

Rene.

