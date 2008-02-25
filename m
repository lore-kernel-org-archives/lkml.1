Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbYBYAVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbYBYAVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYBYAVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:21:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:65473 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYBYAVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:21:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=YZHMVEQkjNfbeiBMF15cBMKrtwKGYj/qfLcWgrjhzfeumcuAZJFqHWYptChAdtP+2dCz/9C3jbUh40LCbc9WtrW3t1JCOJUhw9gKX7f1rQeR2jzWNXBcapn5mocI99Ix+CcSTClg4MRp7PLJucmL/z9lAMqf5Tm+2zSraLjSk9Q=
Date: Mon, 25 Feb 2008 02:18:16 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, lguest@ozlabs.org,
       akpm <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [BUG + PATCH/Bugfix] x86/lguest: fix pgdir pmd index
	calculation
Message-ID: <20080225001816.GA2933@ubuntu>
References: <20080224155515.GA24831@ubuntu> <20080224161814.GA29556@elte.hu> <20080224162653.GA30364@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224162653.GA30364@ubuntu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 06:26:53PM +0200, Ahmed S. Darwish wrote:
> On Sun, Feb 24, 2008 at 05:18:14PM +0100, Ingo Molnar wrote:
> 
> > I've picked up your patch into x86.git#testing (until Rusty picks it 
> > up), you can track it the following way:
> > 
> >     http://people.redhat.com/mingo/x86.git/README
> > 
> > it has other lguest fixes as well - could you double-check that 
> > x86.git#testing works fine for you as-is? (i've just updated the git 
> > tree so it includes your fix as well)
> > 
> 
> Ofcourse. I'll send you the results by GMT night.
> 

This thread's main bug no longer appears. There's a new bug though,
but it looks nicer than the original ugly bug!. 

The new bug does *not* appear in mainline with the same patch. It's
a panic, but this time on the _guest_ side (which is the same host's
kernel).

[    0.023996] CPU: Intel(R) Pentium(R) M processor 1500MHz stepping 05
[    0.023996] Kernel panic - not syncing: Kernel compiled for Pentium+, requires TSC feature!
[    0.023996] Pid: 0, comm: swapper Not tainted 2.6.25-rc2-00815-g3db3a05 #64
[    0.024996]  [<c011bbc7>] panic+0x47/0x120
[    0.024996]  [<c0101b30>] lguest_power_off+0x0/0x20
[    0.024996]  [<c02a88c5>] check_bugs+0x155/0x170
[    0.024996]  [<c02a2b1f>] start_kernel+0x22f/0x2d0
[    0.024996]  [<c02a2390>] unknown_bootoption+0x0/0x1f0
[    0.024996]  [<c0101450>] lguest_restart+0x0/0x20
[    0.024996]  [<c0101450>] lguest_restart+0x0/0x20
[    0.024996]  [<c02a5e22>] lguest_init+0x282/0x290
[    0.024996]  =======================

I'll track it further in my first free time slot.

It seems lguest is very sensitive to x86 tree changes. Could it be 
included in a sort of automatic guest-boot testing, please ?

Thank you,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

