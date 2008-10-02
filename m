Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYJBXUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYJBXUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYJBXUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:20:39 -0400
Received: from smtp3.ono.com ([62.42.230.176]:53901 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753019AbYJBXUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:20:38 -0400
Date: Fri, 3 Oct 2008 01:20:36 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
Message-ID: <20081003012036.28c00fd7@werewolf.home>
In-Reply-To: <86802c440810021539y6cdff33dh9df3e04eba85a9df@mail.gmail.com>
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com>
	<1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com>
	<20081003003237.04469201@werewolf.home>
	<86802c440810021539y6cdff33dh9df3e04eba85a9df@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0cvs144 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 15:39:34 -0700, "Yinghai Lu" <yinghai@kernel.org> wrote:

> On Thu, Oct 2, 2008 at 3:32 PM, J.A. Magallón <jamagallon@ono.com> wrote:
> > On Mon, 29 Sep 2008 18:54:12 -0700, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> > Also, on a 64 bit box with 4Gb, it gives this:
> >
> > cicely:~# cat /proc/mtrr
> > reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> > reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> > reg02: base=0x140000000 (5120MB), size= 512MB: write-back, count=1
> > reg03: base=0x160000000 (5632MB), size= 256MB: write-back, count=1
> > reg04: base=0x80000000 (2048MB), size=2048MB: uncachable, count=1
> >
> boundary handling may have problem...
> 
> should have
> > reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1

should not this                           ^^^^^  be 4096MB ??

> > reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> > reg02: base=0x140000000 (5120MB), size= 512MB: write-back, count=1
> > reg03: base=0x160000000 (5632MB), size= 256MB: write-back, count=1
> 
> can you post /proc/mtrr with disable_mtrr_cleanup?
> 

Oops, sorry, this is without cleanup. This is a distro kernel and is built
but not enable by deafult. As it is rc7, I will use 'enble_mtrr_cleanup' ;):

cicely:~# cat /proc/mtrr
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
reg02: base=0x140000000 (5120MB), size= 512MB: write-back, count=1
reg03: base=0x160000000 (5632MB), size= 256MB: write-back, count=1

I have lost 2Gb ?

cicely:~# free
             total       used       free     shared    buffers     cached
Mem:       3755568     182348    3573220          0      14024      72716
-/+ buffers/cache:      95608    3659960

I can't easily try your patch, this is a distro kernel.
I will get the src.rpm...

Ahhhhh....

This is a dual opteron board. dmidecode says:

Handle 0x0026, DMI type 16, 15 bytes
Physical Memory Array
    Location: System Board Or Motherboard
    Use: System Memory
    Error Correction Type: Single-bit ECC
    Maximum Capacity: 8 GB
    Error Information Handle: Not Provided
    Number Of Devices: 8

So it maps one Opteron memory in first 4Gb and the other on the second 4Gb.
So I should have 2Gb@0 and 2Gb@4Gb.
What I don't know is why the bios eats up 256Mb.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
