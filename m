Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbXLaSFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbXLaSFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbXLaSFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:05:39 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35014 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXLaSFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:05:38 -0500
Date: Mon, 31 Dec 2007 20:05:26 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, devzero@web.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
Message-ID: <20071231180526.GB2360@does.not.exist>
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz> <20071231122419.GA13803@does.not.exist> <alpine.LSU.0.999.0712311335210.3761@be1.lrz> <20071231144255.GB13803@does.not.exist> <alpine.LSU.0.999.0712311553530.4211@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.0.999.0712311553530.4211@be1.lrz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 04:19:23PM +0100, Bodo Eggert wrote:
> On Mon, 31 Dec 2007, Adrian Bunk wrote:
> > On Mon, Dec 31, 2007 at 02:26:42PM +0100, Bodo Eggert wrote:
> > > On Mon, 31 Dec 2007, Adrian Bunk wrote:
> > > > On Mon, Dec 31, 2007 at 01:09:43PM +0100, Bodo Eggert wrote:
> 
> > > > > As suggested by Adrian Bunk, UNIX domain sockets should always be built in 
> > > > > on normal systems. This is especially true since udev needs these sockets
> > > > > and fails to run if UNIX=m.
> > > > > 
> > > > > Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
> > > > > 
> > > > > ---
> > > > > Last minute change: I decided against making it a bool because embedded 
> > > > > folks might depend on a small kernel image. Edited in the patch below.
> > > > >...
> > > > 
> > > > Is this just a purely theoretical thought or is this a reasonable use 
> > > > case people actually use in practice?
> > >  
> > > For now, it's a theoretical thought, but having an embedded device, I can 
> > > see the reason for $EVERYTHING=m there.
> > 
> > The only advantage I see is that the kernel image you have to flash 
> > can be made smaller - with the disadvantage that the running kernel
> > is bigger by more than 10%.
> > 
> > If you don't believe me, try it yourself:
> > Build all drivers statically into your kernel, and then compare the 
> > vmlinux sizes with CONFIG_MODULES=n and CONFIG_MODULES=y.
> 
> If you'd aim for a small kernel image, you would build anything as a module 
> that is not requred for booting.
>...

Small kernel image to flash (e.g. due to a size limit there), if you 
would aim for a small running kernel you wouldn't use modules.

And I'm not so sure about the image size without seeing actual numbers, 
e.g. for your device.

Especially comparing your all-modular approach with a CONFIG_MODULES=n 
kernel using Denys' section garbage collection patches in both cases 
would be interesting.

I'm not claiming you are wrong, all I say is that I'm not convinced 
without actual numbers that you are right.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

