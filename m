Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZBZTcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZBZTcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:32:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZBZTbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:31:52 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:51522 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbZBZTbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:31:52 -0500
Message-ID: <49A6EE17.4070102@krogh.cc>
Date: Thu, 26 Feb 2009 20:31:35 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Woodhouse <David.Woodhouse@intel.com>, Dave Olsen <dolsen@lnxi.com>,
       Ryan Jackson <rjackson@lnxi.com>, linux-mtd@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain> <49A679E8.1010301@krogh.cc> <alpine.LFD.2.00.0902260941090.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902260941090.3111@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Dave Olsen <dolsen@lnxi.com>,
>     Ryan Jackson <rjackson@lnxi.com>, David.Woodhouse@intel.com, 
> linux-mtd@lists.infradead.org
> 
> 
> On Thu, 26 Feb 2009, Jesper Krogh wrote:
>>
>> Booting up 2.6.29-rc6 gave me this one in dmesg...
>>
>> [   21.136149] ck804xrom ck804xrom_init_one(): Unable to register resource 0x00000000ff000000-0x00000000ffffffff - kernel bug?
> 
> Well, it _is_ a kernel bug, but it's in that stupid driver. It does 
> everything wrong, including printing out a scary message.

I've seen that before.. (even reported it before). It just "slipped" 
into the cut'n'paste It was the following stuff that I intended to report.

>> [   21.136269] WARNING: at arch/x86/mm/ioremap.c:208 __ioremap_caller+0x359/0x390()
> 
> This is a different, but related warning, since the driver is doing an 
> ioremap across different resources. The warning is directly related to the 
> fact that the resource wasn't actually valid to begin with.
> 
> What does "cat /proc/iomem" say?

http://krogh.cc/~jesper/iomem.txt

>> System is fully operational, but I didnt get it in 2.6.26.8 (most recent
>> kernel tried on this hardware).
> 
> The ioremap() warning is newish, and may be what made you notice the 
> previous (just one-line) crappy warning.
> 
> Quite frankly, having looked at that horrible driver, I would seriously 
> consider disabling it. Stuff like that should not be allowed to exist.

Being a "stupid" user, I pick the easy way to build a fresh kernel:
1) pick the distro .config
2) make oldconfig
3) Let the kernel load what it think it needs.
4) Report if I see and strange stuff (warnings / bugs / oops) or 
misbehaviour.

So I dont know if I need that driver for anything vital. Should I care? 
Or shouldn't it "just work"?

-- 
Jesper
