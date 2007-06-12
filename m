Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbXFLTVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbXFLTVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 15:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbXFLTVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 15:21:42 -0400
Received: from host.infinivid.com ([64.119.179.76]:59454 "EHLO
	host.infinivid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbXFLTVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 15:21:42 -0400
Subject: Re: allocation failed: out of vmalloc space - use vmalloc=<size>
	to increase size.
From: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <466EE115.9030805@zytor.com>
References: <6278d2220706121001r38a1752axba90de1b4e315f75@mail.gmail.com>
	 <466EE115.9030805@zytor.com>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 15:21:29 -0400
Message-Id: <1181676094.8164.26.camel@microwave.infinitevideocorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wasn't completely honest. It is one bar that has 512 MB, however it is
being mapped at 4 128 MB chunks. However, I would like them all mapped
at once through the lifetime of the driver.

Is there still no chance?

Thanks,
Jon

On Tue, 2007-06-12 at 11:08 -0700, H. Peter Anvin wrote:
> Daniel J Blueman wrote:
> > On 12 Jun, 14:30, Jon Dufresne
> > <jon.dufresne@infinitevideocorporation.com> wrote:
> >> I am writing a linux kernel driver for a custom pci device. I am
> >> developing against the stock fedora 6 kernel on an x86. This device has
> >> 512 MB of IO memory reserved by BAR 3. Whenever I try to ioremap this
> >> space I get the error:
> 
> You don't have a prayer mapping 512 MB at once on an x86-32 machine.
> The kernel only has 1 GB of address space *total*.  You either need to
> map it in chunks or restrict yourself to 64-bit machines.
> 
> >> allocation failed: out of vmalloc space - use vmalloc=<size> to increase
> >> size.
> >>
> >> I think I understand why this is happening. I obviously don't have
> >> enough vmalloc space to map such a large chunk of memory. I have been
> >> using Corbet's et el's "Linux Device Drivers", Love's "Linux Kernel
> >> Development", and many websites as a guide in this development process
> >> but have yet to come across information that will help me.
> >>
> >> I'm curious if there is a way around this issue. Or a better way of
> >> handling it so that I can properly map the entire io memory space.
> 
> No chance.
> 
> > You can boot with kernel parameter vmalloc=384M or so. I have
> > experienced problems with booting with other values, but YMMV.
> 
> The vmalloc= option conflicts with the booting protocol, so it's
> basically a crapshoot if it's going to work or not, at least if you're
> using an initrd, which pretty much everyone does hese days.
> 
> 	-hpa

