Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbYDIUtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbYDIUtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYDIUt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:49:27 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:52967 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942AbYDIUt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:49:26 -0400
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] e1000=y && e1000e=m regression fix (was: Re: [regression] e1000e broke e1000)
Date: Wed, 9 Apr 2008 22:49:20 +0200
User-Agent: KMail/1.9.9
Cc: jeff@garzik.org, matthew@wil.cx, auke-jan.h.kok@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, linux-pci@atrey.karlin.mff.cuni.cz,
       akpm@linux-foundation.org, davem@davemloft.net,
       torvalds@linux-foundation.org, jesse.brandeburg@intel.com,
       john.ronciak@intel.com, bruce.w.allan@intel.com, greg@kroah.com,
       arjan@linux.intel.com, rjw@sisk.pl
References: <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu> <20080408193245.GG11962@parisc-linux.org> <20080408195123.GA28148@elte.hu> <47FBCE00.2020309@garzik.org> <20080408200652.GC28148@elte.hu> <47FBD34A.6080508@garzik.org> <20080408203314.GA28952@elte.hu> <47FBDBE9.9040700@garzik.org> <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu>
In-reply-To: <20080409193850.GA11763@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804092249.23111.elendil@planet.nl>
X-OriginalArrivalTime: 09 Apr 2008 20:49:23.0835 (UTC) FILETIME=[314974B0:01C89A83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Subject: e1000=y && e1000e=m regression fix
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed Apr 09 21:09:35 CEST 2008
> 
> fix a regression from v2.6.24: do not transfer the e1000e PCI IDs from
> e1000 to e1000e if e1000 is built-in and e1000e is a module.
> 
> Built-in drivers take precedence over modules in many ways - and in this
> case it's clear that the user intended the e1000 driver to be the
> primary one. "Silently change behavior and break existing configs" is
> never a good migration strategy. Most users will use distro kernels that
> are not affected by this problem at all - nor are they affected by this
> patch - but this problem can hit users and developers who build their
> kernels themselves and migrate from v2.6.24 to v2.6.25.
> 
> this fixes: http://bugzilla.kernel.org/show_bug.cgi?id=10427
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Speaking as someone who's mostly (guestimated at 97% ;-) a user, I'd be in 
favor of a patch like this.

The scenario I have in mind that would lead to exactly the situation Ingo is 
trying to solve is this:
Fairly experienced user wants a kernel which supports his hardware without 
having to load modules, but wants other modules available "just in case".
So he takes his distro kernel and selectively changes some modules to 
built-ins, including e1000.
Next he upgrades to 2.6.25 and finds his NIC no longer works. Files bug 
reports all over the place and loads of people waste valuable time trying 
to help him. I doubt any of the people trying to help (who are trying to do 
so without access to the hardware) will soon think of this scenario. It's 
much more likely they'll get stuck on "but e1000e is available as a module, 
so it should get loaded, right".
Maybe, just very maybe, someone, in an act of desperation will say "ok, try 
compiling in the module, see if that works".

Or maybe they will stumble on this thread at some point. Anyway, I 
completely agree with Ingo that it would be really nice if all the wasted 
time and frustration could just be avoided.

Cheers,
FJP
