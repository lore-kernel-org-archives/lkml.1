Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbYKDQv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbYKDQv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756703AbYKDQrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:47:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:14652 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbYKDQrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:47:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hd22RQFTRn44Eza1mCtC5DOkm7m2e1atfGguH0bb1Z/cYJwZ1XGiUVPsn54vDqHw5U
         Sod8/hq++1gXjKFM+f9ULa65RKSlPuxHvHwfgyraJXeTo5NdkuWwKPtfiYLhhBzA3JZt
         Ni65mFErQ/Tx1vh9LitRtAVrBAySihQ/h2b/U=
Date: Tue, 4 Nov 2008 19:47:17 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081104164717.GD21470@localhost>
References: <20081104122839.GA22864@mailshack.com> <20081104124242.GA6795@elte.hu> <1225805399.25337.1282903253@webmail.messagingengine.com> <20081104140030.GA16178@elte.hu> <1225815789.30706.1282936457@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225815789.30706.1282936457@webmail.messagingengine.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Alexander van Heukelum - Tue, Nov 04, 2008 at 05:23:09PM +0100]
...
| 
| I did some timings using the little program below (32-bit only), doing
| 1024 times the same sequence. TEST1 is just pushing a constant onto
| the stack; TEST2 is pushing the cs register; TEST3 is the sequence
| from the patch to extract the vector number from the cs register.
| 
| Opteron    (cycles): 1024 / 1157 / 3527
| Xeon E5345 (cycles): 1092 / 1085 / 6622
| Athlon XP  (cycles): 1028 / 1166 / 5192

Xeon is defenitely out of luck :-)

| 
| I'ld say that the cost of the push %cs itself is negligible.
| 
| > ( another advantage is that the 6 bytes GDT descriptor is more 
| >   compressed and hence uses up less L1/L2 cache footprint than the 
| >   larger (~7 byte) trampolines we have at the moment. )
| 
| A GDT descriptor has to be read and processed anyhow... It might
| just not be in cache. But at least it is aligned. The trampolines
| are 7 bytes (irq#<128) or 10 bytes (irq#>127) on i386 and x86_64.
| And one is data, and the other is code, which might also cause
| different behaviour. It's just a bit too complicated to decide by
| just reasoning about it ;).
| 
| > plus it's possible to observe the typical cost of irqs from user-space 
| > as well: run a task on a single CPU and save away all the RDTSC deltas 
| > that are larger than ~10 cycles - these will be the IRQ entry costs. 
| > Print out these deltas after 60 seconds of runtime (or something like 
| > that), and look at the histogram.
| 
| I'll see if I can do that. Maybe in a few days...
| 
| Thanks,
|     Alexander
| 
| > 	Ingo
...

		- Cyrill -
