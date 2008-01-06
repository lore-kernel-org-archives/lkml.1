Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbYAFVQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbYAFVQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 16:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbYAFVQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 16:16:07 -0500
Received: from smtp-out.rrz.uni-koeln.de ([134.95.19.53]:43710 "EHLO
	smtp-out.rrz.uni-koeln.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbYAFVQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 16:16:06 -0500
Message-ID: <478144E4.501@uni-koeln.de>
Date: Sun, 06 Jan 2008 22:15:16 +0100
From: Berthold Cogel <cogel@uni-koeln.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org, nigel@nigel.suspend2.net, dtor@mail.ru,
       jikos@jikos.cz, akpm@linux-foundation.org,
       linux-usb-owner@vger.kernel.org
Subject: Re: Oops in evdev_disconnect for kernel 2.6.23.12
References: <477A93CD.9030707@rrz.uni-koeln.de> <20080105065233.GE27894@ZenIV.linux.org.uk> <47801D70.8020504@uni-koeln.de> <20080106001756.GP27894@ZenIV.linux.org.uk> <47812E5B.6080000@uni-koeln.de> <20080106201559.GU27894@ZenIV.linux.org.uk>
In-Reply-To: <20080106201559.GU27894@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro schrieb:
> On Sun, Jan 06, 2008 at 08:39:07PM +0100, Berthold Cogel wrote:
>>>> If I'm able to reproduce the oops with my patched kernel, I will gladly 
>>>> follow your advice.
>>> AFAICS, lkml.org/lkml/2007/7/24/20 is the same patch...
>> Ok! It happened again....
>>
>> I was able to reproduce the Oops twice. Once with my patched kernel
>> (2.6.23.12 patched with tuxonice-3.0-rc3-for-2.6.23.9 on Debian
>> stable/testing/unstable) and the second time with a vanilla 2.6.23.12
>> kernel. So this isn't related to Tuxonice.
> 
> Apply the patch in aforementioned posting and see if it fixes the things?

I did that and got this in 'make modules':

   CC [M]  drivers/input/joydev.o
   CC [M]  drivers/input/evdev.o
drivers/input/evdev.c: In function 'evdev_do_ioctl':
drivers/input/evdev.c:749: error: 'struct input_dev' has no member named 
'event_lock'
drivers/input/evdev.c:757: error: 'struct input_dev' has no member named 
'event_lock'
make[2]: *** [drivers/input/evdev.o] Fehler 1
make[1]: *** [drivers/input] Fehler 2
make: *** [drivers] Fehler 2


The next piece of the puzzle:

No oops with 2.6.24-rc6 vanilla and the same kernel patched with 
TuxOnIce 3.0-rc3 for kernel 2.6.24-rc3. A minor nit was that I had to 
rebuild the xorg driver for the tablet to get it working.


Berthold




