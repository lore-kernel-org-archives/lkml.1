Return-Path: <linux-kernel-owner+w=401wt.eu-S1030351AbXDCXtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351AbXDCXtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030361AbXDCXtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:49:25 -0400
Received: from mail.nagafix.co.uk ([194.145.196.85]:57299 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030351AbXDCXtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:49:24 -0400
Message-ID: <4612E802.7000302@nagafix.co.uk>
Date: Wed, 04 Apr 2007 00:49:22 +0100
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 1.5.0.10 (X11/20070304)
MIME-Version: 1.0
To: Antoine Martin <antoine@nagafix.co.uk>
CC: Jeff Dike <jdike@addtoit.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Blaisorblade <blaisorblade@yahoo.it>, devzero@web.de,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kraxel@suse.de
Subject: Re: [uml-devel] [RFC] UML kernel & rootfs bundle with every kernel
 release ?
References: <1712880100@web.de> <200704012108.14597.blaisorblade@yahoo.it> <46100EF5.7040802@nagafix.co.uk> <20070402020530.GA589@c2.user-mode-linux.org> <4610D937.20002@nagafix.co.uk> <Pine.LNX.4.64.0704021318410.1276@anakin> <20070402145300.GA6179@c2.user-mode-linux.org> <461124A9.7080609@nagafix.co.uk>
In-Reply-To: <461124A9.7080609@nagafix.co.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antoine Martin wrote:
> Jeff Dike wrote:
>> On Mon, Apr 02, 2007 at 01:22:00PM +0200, Geert Uytterhoeven wrote:
>>> There are patches floating around for a UML frame buffer device.
>>> Gerd Kraxel^H^H^H^H^H^HHoffmann did one using plain X11, which worked
>>> great when I gave it a try.
>>>
>>> I suggest taking a look at Gerd's patches. IIRC, he posted them to lkml
>>> last year.
>>
>> I have Gerd's patch sitting in my tree, but it's never really worked
>> for me, so I haven't pushed it.
> Yep, I tried them and it didn't work for me either, I'll try again though.
I did try again, and I found this patch:
http://dl.bytesex.org/patches/uml-2.6.11/uml-x11-fb
Which applied (2 rejects by hand), but failed with
"Mapping memory: Cannot allocate memory"
in mmap64:
os_map_memory [...]
   at arch/um/os-Linux/process.c:164

and this one:
http://www.suse.de/~kraxel/uml/patches/2.6.18-rc4/uml-x11-fb
which applied cleanly, but is not letting me set the option - Kconfig is 
beyond me:

arch/um/Kconfig:144:warning: 'select' used by config symbol 'X11_FB' 
refer to undefined symbol 'FB_CFB_FILLRECT'
arch/um/Kconfig:145:warning: 'select' used by config symbol 'X11_FB' 
refer to undefined symbol 'FB_CFB_COPYAREA'
arch/um/Kconfig:146:warning: 'select' used by config symbol 'X11_FB' 
refer to undefined symbol 'FB_CFB_IMAGEBLIT'

So that's a non-starter for me...

Antoine
