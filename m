Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0BOJzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 04:55:32 -0500
Received: from mail.bitdefender.com ([91.199.104.2]:47627 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab0BOJza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 04:55:30 -0500
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: Pedro Ribeiro <pedrib@gmail.com>
Subject: Re: slow resume from suspend to disk
Date: Mon, 15 Feb 2010 11:54:48 +0200
Cc: linux-kernel@vger.kernel.org
References: <201002110140.16122.mihai.dontu@gmail.com> <74fd948d1002101611i7486e700gbbaf420d95203394@mail.gmail.com>
In-Reply-To: <74fd948d1002101611i7486e700gbbaf420d95203394@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201002151154.49299.mihai.dontu@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
X-BitDefender-Spam: No (0)
X-BitDefender-SpamStamp: v1, build 2.8.84.86064, bayes score: 500(0),
 pbayes score: 241(0), neunet score: 0(0), flags: [NN_VALID_REPLY;
 NN_LEGIT_SUMM_400_WORDS], SQMD:
 6e1301f6a1af00edf381fae37c80e795.fuzzy.fzrbl.org, total: 0(775)
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.1.0 on
 elfie.dsd.hq, sigver: 7.30392
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 February 2010 02:11:00 Pedro Ribeiro wrote:
> On 10 February 2010 23:40, Mihai Donțu <mihai.dontu@gmail.com> wrote:
> > Hi,
> > 
> > Is there any way to speed up the resume from suspend to disk? Currently,
> > on my laptop it suspends in ~15s (wrote about 360MB) but resumes in
> > ~120s and after that I'm still left with ~361MB in swap:
> > 
> >             total       used       free     shared    buffers     cached
> > Mem:       3333472    1139332    2194140          0      12808     473084
> > -/+ buffers/cache:     653440    2680032
> > Swap:      2104472     369428    1735044
> > 
> > Right now I'm better off with a cold boot.
> > 
> > Although I did not study the kernel code to see how things really work, I
> > suspect on resume only necessary kernel data is loaded from swap and the
> > userland tasks are left with the page fault mechanism to bring back their
> > own data, which leads to an I/O storm on the swap device. Maybe changing
> > the I/O scheduler from CFQ would help? or better yet, is there any way
> > to tell the kernel to bring back all the pages from swap in one quick
> > move? That would be something I want to put in my resume scripts.
> > 
> > $ uname -a
> > Linux mdontu-dell 2.6.32-gentoo-r3 #1 SMP PREEMPT Mon Feb 1 02:36:01 EET
> > 2010 x86_64 Intel(R) Core(TM)2 CPU T5500 @ 1.66GHz GenuineIntel
> > GNU/Linux
> > 
> > I've installed Windows XP just for a test, started a few apps (like
> > visual studio, mplayer, etc.) and then suspended/hibernated (~15s). It
> > took roughly 15s to come back.
> > 
> > Thanks,
> > 
> > PS: I'm editing this e-mail as I do tests and I just noticed that my
> > /sbin directory is empty. rmmod is there and I needed it to reload the
> > b43 driver which generally does not feel well after a suspend/resume. A
> > reboot fixed it. Weird ...
> 
> If you know how to patch and compile a kernel, try http://www.tuxonice.net/
> I find it way faster and more reliable than the in-kernel hibernation.

Luckily, Gentoo has en ebuild for this. ;)

> You also need to install at least the hibernate script, since it is
> way better for hibernation that pm-utils which most distros use.
> 
> Ubuntu and some other distros have binary kernels already patched and
> the hibernate script packaged.

I have tested tuxonice for the past three days. It turns out it's the real 
deal when it comes to suspend to disk and the devices "feel" better after the 
tuxonice resume than after the built-in swsusp. Mm.

Thanks,

-- 
Mihai Donțu
