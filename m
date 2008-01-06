Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbYAFXpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbYAFXpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 18:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbYAFXpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 18:45:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45706 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbYAFXpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 18:45:30 -0500
Date: Sun, 6 Jan 2008 23:45:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Berthold Cogel <cogel@uni-koeln.de>
Cc: linux-kernel@vger.kernel.org, nigel@nigel.suspend2.net, dtor@mail.ru,
       jikos@jikos.cz, akpm@linux-foundation.org,
       linux-usb-owner@vger.kernel.org
Subject: Re: Oops in evdev_disconnect for kernel 2.6.23.12
Message-ID: <20080106234528.GV27894@ZenIV.linux.org.uk>
References: <477A93CD.9030707@rrz.uni-koeln.de> <20080105065233.GE27894@ZenIV.linux.org.uk> <47801D70.8020504@uni-koeln.de> <20080106001756.GP27894@ZenIV.linux.org.uk> <47812E5B.6080000@uni-koeln.de> <20080106201559.GU27894@ZenIV.linux.org.uk> <478144E4.501@uni-koeln.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478144E4.501@uni-koeln.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 10:15:16PM +0100, Berthold Cogel wrote:
> I did that and got this in 'make modules':
> 
>   CC [M]  drivers/input/joydev.o
>   CC [M]  drivers/input/evdev.o
> drivers/input/evdev.c: In function 'evdev_do_ioctl':
> drivers/input/evdev.c:749: error: 'struct input_dev' has no member named 
> 'event_lock'
> drivers/input/evdev.c:757: error: 'struct input_dev' has no member named 
> 'event_lock'
> make[2]: *** [drivers/input/evdev.o] Fehler 1
> make[1]: *** [drivers/input] Fehler 2
> make: *** [drivers] Fehler 2
> 
> 
> The next piece of the puzzle:
> 
> No oops with 2.6.24-rc6 vanilla and the same kernel patched with 
> TuxOnIce 3.0-rc3 for kernel 2.6.24-rc3. A minor nit was that I had to 
> rebuild the xorg driver for the tablet to get it working.

No puzzle at all - the changeset in question is present in -rc3.  As for
the errors - looks like it does indeed depend on the previous changeset.
After poking a bit in the archived thread, http://lkml.org/lkml/2007/7/24/19
appears to contain the previous one.
