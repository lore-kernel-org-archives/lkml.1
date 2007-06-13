Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbXFMKib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbXFMKib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 06:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbXFMKiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 06:38:23 -0400
Received: from styx.suse.cz ([82.119.242.94]:32843 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756705AbXFMKiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 06:38:23 -0400
Date: Wed, 13 Jun 2007 12:38:06 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stanislav Brabec <sbrabec@suse.cz>
Subject: Re: Proposal: change keycode for scancode e0 32 from 150 to 172
Message-ID: <20070613103806.GF19888@suse.cz>
References: <466F1462.5090008@hhs.nl> <466F1E5C.5090002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466F1E5C.5090002@zytor.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 03:29:48PM -0700, H. Peter Anvin wrote:
> I just tested this using Microsoft Natural Keyboard Pro, which is a
> dual-mode (USB-PS/2) keyboard.
> 
> This key is labelled Web/Home and has a picture of a house on the keycap.
> 
> In PS/2 mode it reports E0 32 which gets converted to keycode 150.
> In USB mode it reports E0 02 which gets converted to keycode 172.
> 
> I don't know if it's the keyboard itself that's being inconsistent, or
> if it is the table in usbkbd.c that's broken (in which case it should be
> fixed to be consistent with the keyboard in PS/2 mode.)

USB keyboards don't send scancodes, what you see is smoke and mirrors.

Yes, the atkbd.c and hid-input.c mappings are inconsistent. We probably
want to fix atkbd.c (scancode->keycode mapping), and maybe also
char/keyboard.c (keycode->synth scancode mapping).

> > The logo on the key is a homepage logo, the text below is www/homepage.
> > So what to send? I believe that for consistency with the usb codes send
> > it should be KEY_HOMEPAGE, but thats based on a sample of 1 usb
> > keyboard. Input on what other usb keyboards send for the key with the
> > homepage iocn is very much welcome.
> 
> You seem to be of the opinion that "usb behaviour is correct", but don't
> give any motivation why usb should take precedence.  Offhand, I would
> expect there to be fewer translation layers for PS/2 and would therefore
> assume PS/2 is more inherently correct.

KEY_HOMEPAGE seems to better fit the description of how the key looks.
Microsoft calls it "WWW Home", and it's supposed to be e0 32. 

-- 
Vojtech Pavlik
Director SuSE Labs
