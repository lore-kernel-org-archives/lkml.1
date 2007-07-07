Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbXGGVrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbXGGVrG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 17:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXGGVq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 17:46:56 -0400
Received: from 1wt.eu ([62.212.114.60]:3303 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbXGGVqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 17:46:55 -0400
Date: Sat, 7 Jul 2007 23:46:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
Message-ID: <20070707214648.GA28342@1wt.eu>
References: <Pine.LNX.4.58.0707060318160.26869@be1.lrz> <468DA42D.7050309@zytor.com> <Pine.LNX.4.64.0707072030230.1536@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.58.0707072255260.3562@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0707072255260.3562@be1.lrz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 11:18:59PM +0200, Bodo Eggert wrote:
> On Sat, 7 Jul 2007, Jan Engelhardt wrote:
> > On Jul 5 2007 19:08, H. Peter Anvin wrote:
> 
> > >> BTW: Is it possible to mount a tmpfs on / before extracting the cpio?
> > >
> > >Not in the stock kernel.  There have been some patches floating around
> > >for that, I think.
> > 
> > What would it buy? rootfs is a tmpfs, is not it?
> 
> As far as I understand, it is a ramfs aka. non-swappable tmpfs without any 
> limit and including a chance of DoSing the system.
> 
> Since I'm toying with root-on-initcpio, I'm looking for things that might 
> make the task some easier.
> 
> Currently I'm thinking about changing the root=initramfs to root=tmpfs and
> additionally mounting a tmpfs on / before unpacking the cpios. OTOH, this 
> seems to be a little bit messy. OTOH again, in _that_ boot code, nobody
> should complain :)

Well, maybe it would be time to assign limits to ramfs. I have a patch for
this in all my own 2.4 kernels that I use on appliances, network boot and
bootable CDs. It was a bit tricky to get the limits to work well in 2.4
because it was not easy to track which pages were used by whom. But I presume
that rmap in 2.6 should help a lot.

If someone is willing to give this a try, here's the 2.4 patch :

  http://linux.1wt.eu/kernel/patches-2.4.34-wt1/pool/2.4.32-ramfs-limits-5

Regards,
Willy
 
