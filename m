Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbXFQT7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbXFQT7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760584AbXFQT7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:59:08 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:10272 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759045AbXFQT7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:59:05 -0400
Date: Sun, 17 Jun 2007 21:59:01 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070617195901.GA5689@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com
References: <1181721735.4418.10.camel@malory> <20070613162925.GG3875@redhat.com> <20070614011506.GA30566@alinoe.com> <20070617162235.GA5486@alinoe.com> <20070617190714.GA18115@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617190714.GA18115@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 03:07:14PM -0400, Dave Jones wrote:
> Sometimes things fall through the cracks..
> I haven't heard any similar problems, which makes it somewhat odd.

Ok. Well, the lockup is all to real here :p

I suspect a memory corruption going on, as under certain circumstances
there is printed more after the "agpgart: Detected an Intel 965G
Chipset." -- that is, the kernel *sometimes* doesn't hang silently,
but either reboots by itself (hard reset) or prints something
that looks like a total crash to me. Often, this is prefixed by
the name of running process. I am sorry, I never wrote any of that
down. Only the last time, it then went like:

agpgart: Detected an Intel 965G Chipset.
modprobe: Corrupt page table at address 20
PGD 178c6c067 PUD 201000c0049c04f BAD

This very same kernel (I boot it several times to see how
reproducable things were) always prints "agpgart: Detected an Intel 965G
Chipset." but then either hangs (two times), prints the above
and hangs (one time) or hard resets (one time).

Then I also booted the other kernels several times, and kernels
that booted fine ALWAYS boot fine - while kernels that locked
up (that I tested by booting them three times) only printed
the agpgart line and locked up three times.

>  > The patch causes my machine to lock up and/or crash
>  > in various ways (depending on the exact version of the kernel),
>  > very shortly after printing: agpgart: Detected an Intel 965G Chipset.
>  > 
>  > The first kernel version that stops doing that is 2.6.22-rc5.
>  > I used git bisect once more to find the patch that fixes this bug:
>  > I am mailing this mostly because the comment doesn't seem to indicate
>  > that the author is aware that this patch fixes an existing regression
>  > (it worked fine for me with 2.6.18).
> 
> Indeed, it was unknown to me too, this should have just been
> a clean-up.

I hope you saw my later post too? I sent it to you too - but also to the
list, so I don't know if you'll notice it.

The Subject of that post is: 2.6.22-rc5 regression

I concluded too soon that 2.6.22-rc5 was working :(.
I just really tested it and it doesn't! Same error.

Please have a look at that other post of me and lets continue this
thread there.

> Out of curiousity, I'd like to see your lspci
> (not -v or anything, just run with no args)

I'll add that to that other thread.

-- 
Carlo Wood <carlo@alinoe.com>
