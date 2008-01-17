Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYAQN0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYAQN0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbYAQN0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:26:38 -0500
Received: from twin.jikos.cz ([213.151.79.26]:50080 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbYAQN0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:26:37 -0500
Date: Thu, 17 Jan 2008 14:26:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Adolfo R. Brandes" <arbrandes@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote
 Control
In-Reply-To: <b4292e150712280848h36a5bbf5k76e121168e8bfd12@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801171420400.15647@twin.jikos.cz>
References: <b4292e150712280848h36a5bbf5k76e121168e8bfd12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2007, Adolfo R. Brandes wrote:

> 1) The power button, which is actually a Sleep or Suspend button, when
> pressed repeats endlessly.  One must disconnect the receiver for it to
> stop.  I suspect this is because the key press event registers
> correctly, but not the key release.
> 
> 2) Four of the buttons ("TV", "SETUP MENU", "LAST", and "INPUT") are
> not recognized and do not register any events.
> * "SETUP MENU", "LAST", and "INPUT" keys do absolutely nothing.

Hi Adolfo,

this is really weird, that the keys do not produce any debugging output at 
all. Do you think you could use usbmon to see what data is coming from 
they keyboard through USB bus? Details are explained at 
Documentation/usb/usbmon.txt.

> * "TV" registers something, but apparently not enough for an event.

>From the debugging output, it seems that the HID report arrives, but all 
bits are set to zero, which is also strange. Could you please also capture 
usbmon output for this event? It could be that the HID report descriptor 
of this device is wrong, and the report is in fact longer than two bytes.

> * "Power" correctly registers a Sleep event, but repeats endlessly.

The keyboard is buggy and doesn't handle "Power" as a button for which 
EV_REP should be set. This will be trivial to fix by keyboard-specific 
quirk, I will send it to you together with other changes, when we collect 
any interesting information from usbmon.

Thanks for great and detailed bugreport,

-- 
Jiri Kosina
