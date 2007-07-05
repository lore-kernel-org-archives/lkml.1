Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbXGEIwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbXGEIwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757163AbXGEIwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:52:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58302 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbXGEIwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:52:40 -0400
Date: Thu, 05 Jul 2007 17:52:13 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: nigel@suspend2.net
Subject: Re: x86_64 memory hotplug simulation support?
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200707051644.55191.nigel@nigel.suspend2.net>
References: <20070705145527.2798.Y-GOTO@jp.fujitsu.com> <200707051644.55191.nigel@nigel.suspend2.net>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070705161700.279A.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks for your reply. Please, just call me Nigel :).

Haha. Okay. Nigel.
(Though, San is useful for even friendly/frank situation in Japanese :) )

> I saw a patch that Dave 
> Hansen had posted, back around the time of 2.6.11 iirc. It was for x86, and 
> (so far as I understand) allowed a person who doesn't really have 
> hotpluggable memory to make their computer pretend that it does.
>
> Just in case I'm not being clear enough, let me get more concrete. I have had 
> some code for a while that uses bitmaps to simulate page flags, without 
> needing to take up those precious bits in page->flags. I've begun to add 
> support for memory hotplugging, in the hope that I can make it general enough 
> that it will be useful for more than just suspend2. To do that, I'd like to 
> be able to test the memory hotplugging paths, without needing to actually 
> have hotpluggable memory. I do have an x86 desktop I could work on, but would 
> prefer to do it on my x86_64 laptop if I can.

Current memory hot-add code expects special hardware which allows
memory hot-unplug physically. Yes, these is no way to use it on 
normal PC without emulation. And I don't have emulation code for
x86-64. Usually, I'm using ia64 box for test it.

These are 2 ideas to use memory hotplug with normal x86-64 box.

- Make emulation code for x86-64.
  To add memory, some of memory have to be ignored at boot time.
  And add memory after boot up.
  This way may need fake BIOS information. And if memory is added once,
  reboot is necessary for next hot-add test.

- Bootup normaly. Unplug some memory at first, then hot-add them
  later.  You can try hot-plug code many times after bootup.

  Unplug code must is not merged yet. Followings are the newest one.
      http://marc.info/?l=linux-mm&m=118180415304117&w=2
  But the 6th patch of them is only for ia64.
      http://marc.info/?l=linux-mm&m=118180483715610&w=2
  So, same role patch for x86-64 is still necessary.

  In addition, some of route of hot-add code can't be tested.
  Because, current hot-add has 2 phase.
    1. Physically hot-add.
         - Accept notification from firmware.
         - Make sysfs file for new memory.
         - register SPARSEMEM and allocate memmap/pgdat/zone.
    2. logically online
         - free each pages of new memory to use them.
         - rebuild zonelist.

  But, unplug code just do logical offline. physicall hot-unplug
  must be necessary for test phase 1.


Hmm. I don't know what is necessary for suspend2.
But, some works looks still necessary for each way. 

Thanks.

-- 
Yasunori Goto 


