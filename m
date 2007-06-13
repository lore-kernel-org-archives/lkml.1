Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbXFMNa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbXFMNa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbXFMNaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:30:13 -0400
Received: from styx.suse.cz ([82.119.242.94]:38517 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753138AbXFMNaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:30:11 -0400
Date: Wed, 13 Jun 2007 15:02:08 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Jiri Kosina <jikos@jikos.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stanislav Brabec <sbrabec@suse.cz>
Subject: Re: Proposal: change keycode for scancode e0 32 from 150 to 172
Message-ID: <20070613130208.GG19888@suse.cz>
References: <466F1462.5090008@hhs.nl> <466F1E5C.5090002@zytor.com> <Pine.LNX.4.64.0706131113400.23280@twin.jikos.cz> <466FB80E.7050902@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466FB80E.7050902@hhs.nl>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 11:25:34AM +0200, Hans de Goede wrote:
> Jiri Kosina wrote:
> >On Tue, 12 Jun 2007, H. Peter Anvin wrote:
> >
> >>In PS/2 mode it reports E0 32 which gets converted to keycode 150. In 
> >>USB mode it reports E0 02 which gets converted to keycode 172.
> >>I don't know if it's the keyboard itself that's being inconsistent, or 
> >>if it is the table in usbkbd.c that's broken (in which case it should be 
> >>fixed to be consistent with the keyboard in PS/2 mode.)
> >
> >Hi Peter,
> >
> >First, usbkbd.c has very probably zero business with this - the mappings 
> >are being done in hid-input.c, usbkdb.c is only for embedded/debugging 
> >cases, and is almost never used on modern systems (see the corresponding 
> >Kconfig help text).
> >
> >>You seem to be of the opinion that "usb behaviour is correct", but don't 
> >>give any motivation why usb should take precedence.  Offhand, I would 
> >>expect there to be fewer translation layers for PS/2 and would therefore 
> >>assume PS/2 is more inherently correct.
> >
> >For USB, we have Hid Usage Pages, which define this to be KEY_HOMEPAGE. 
> >There is no such specification for PS/2 though, so what Hans is proposing 
> >is to make it consistent with behavior of USB HID devices, which I agree 
> >with.
> 
> Good to hear, so as everyone smees to agree, shall I write a (massive, 
> complex, intrusive) patch to fix this, or are there until now silent 
> parties that object?

Just don't forget to update the char/keyboard.c scancode synthesis table
to generate e0 32 for keycode 172 instead for the current 150.

-- 
Vojtech Pavlik
Director SuSE Labs
