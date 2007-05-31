Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbXEaOK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbXEaOK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbXEaOKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:10:19 -0400
Received: from lucifer.nerdfest.org ([216.243.209.218]:34024 "EHLO
	lucifer.nerdfest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbXEaOKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:10:17 -0400
X-Greylist: delayed 3808 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2007 10:10:16 EDT
Subject: Re: Add INPUT support to toshiba_acpi
From: Bastien Nocera <hadess@hadess.net>
To: Richard Hughes <hughsient@gmail.com>
Cc: John Belmonte <john@neggie.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
In-Reply-To: <1180614979.2693.26.camel@localhost.localdomain>
References: <1180614979.2693.26.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 31 May 2007 13:53:13 +0100
Message-Id: <1180615994.3030.166.camel@cookie.hadess.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-31 at 13:36 +0100, Richard Hughes wrote:
> Attached patch adds a kernel thread to do polling on Toshiba hardware.
> 
> Toshiba hardware is a little oddball, and does not provide ACPI events
> on some key presses, typically Fn hotkey buttons. The key interface is
> now polled, and events now matched to a list of toshiba specific
> scancodes, and are squirted to userspace using the INPUT subsystem.
> 
> This means that toshiba laptops buttons "just work" without any
> userspace daemon (using uinput) such as fnfx or bodges such as using a
> userspace hal addon. Doing the polling in kernel is more efficient, and
> makes stuff just work out of the box. You can assign the keys using
> standard X keymaps, or using tools such as gnome-keybinding-properties.
> 
> This is similar to other patches sent for the thinkpad_acpi driver, and
> is part of the "Unf*ck my keyboard" initiative to make multimedia keys
> just work.
> 
> Changes from the first patch involve switching to a workqueue for the
> polling, not breaking the spaces in "hotkeys_via_input" and also masking
> out the fn key button up.

A couple of things:
- use a switch statement in toshiba_deliver_button_event(), would look a
bit cleaner.
- make the magic number #defines
- not sure if it's possible, but you should disable the workqueue
altogether if nothing has the input device opened.

Hopefully we'll find a way to receive an interrupt, or some kind of
event when the keys are pressed in the future, and completely avoid the
polling. In the meantime, it should be minimised.

Cheers

-- 
Bastien Nocera <hadess@hadess.net> 

