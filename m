Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbXFMJSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbXFMJSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 05:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbXFMJSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 05:18:09 -0400
Received: from twin.jikos.cz ([213.151.79.26]:44811 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798AbXFMJSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 05:18:07 -0400
Date: Wed, 13 Jun 2007 11:18:03 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stanislav Brabec <sbrabec@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: Proposal: change keycode for scancode e0 32 from 150 to 172
In-Reply-To: <466F1E5C.5090002@zytor.com>
Message-ID: <Pine.LNX.4.64.0706131113400.23280@twin.jikos.cz>
References: <466F1462.5090008@hhs.nl> <466F1E5C.5090002@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007, H. Peter Anvin wrote:

> In PS/2 mode it reports E0 32 which gets converted to keycode 150. In 
> USB mode it reports E0 02 which gets converted to keycode 172.
> I don't know if it's the keyboard itself that's being inconsistent, or 
> if it is the table in usbkbd.c that's broken (in which case it should be 
> fixed to be consistent with the keyboard in PS/2 mode.)

Hi Peter,

First, usbkbd.c has very probably zero business with this - the mappings 
are being done in hid-input.c, usbkdb.c is only for embedded/debugging 
cases, and is almost never used on modern systems (see the corresponding 
Kconfig help text).

> You seem to be of the opinion that "usb behaviour is correct", but don't 
> give any motivation why usb should take precedence.  Offhand, I would 
> expect there to be fewer translation layers for PS/2 and would therefore 
> assume PS/2 is more inherently correct.

For USB, we have Hid Usage Pages, which define this to be KEY_HOMEPAGE. 
There is no such specification for PS/2 though, so what Hans is proposing 
is to make it consistent with behavior of USB HID devices, which I agree 
with.

-- 
Jiri Kosina
