Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbZLZMhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbZLZMhL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 07:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZLZMhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 07:37:09 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:36385 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZLZMhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 07:37:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=FPnUkyg0KRwxiBh+WbW/XeYHZGveuoQH7YCB5YY7x76fa6XZ1Gw240+N6jmlOv7LxR
         5KdrZw93p0/BIL1F02AysIQy5LW8H0m1d4ZOYoLE2IyK0RBih2x4hBiFIko9egvVAFwX
         vSVLF0M55i7wsiYpbPXJFOQGj3stGp3IrAE4c=
Date: Sat, 26 Dec 2009 14:36:17 +0200
From: Dan Carpenter <error27@gmail.com>
To: BuraphaLinux Server <buraphalinuxserver@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: strange stuff in dmesg
Message-ID: <20091226123617.GA6075@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	BuraphaLinux Server <buraphalinuxserver@gmail.com>,
	linux-kernel@vger.kernel.org
References: <5d75f4610912240203x61a45505s213f29809824a854@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d75f4610912240203x61a45505s213f29809824a854@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 05:03:58PM +0700, BuraphaLinux Server wrote:
> On my Dell OptiPlex 330 machines with kernel 2.6.32.2 I get a strange
> WARNING.  Do I need to worry?  Here is the warning:
> 
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at mm/page_alloc.c:1805
> __alloc_pages_nodemask+0x1b6/0x730()

Memory allocations are failing because your scrollback
size is set to high (65 Mb).

In your config you have:
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=65536

The default in 2.6.32 is 64.

regards,
dan carpenter

> [    0.000000] Hardware name: OptiPlex 330
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.32.2 #1
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff8108e806>] ? __alloc_pages_nodemask+0x1b6/0x730
> [    0.000000]  [<ffffffff81043f68>] warn_slowpath_common+0x78/0xd0
> [    0.000000]  [<ffffffff81043fcf>] warn_slowpath_null+0xf/0x20
> [    0.000000]  [<ffffffff8108e806>] __alloc_pages_nodemask+0x1b6/0x730
> [    0.000000]  [<ffffffff810b4e28>] alloc_pages_current+0x78/0xf0
> [    0.000000]  [<ffffffff8108da69>] __get_free_pages+0x9/0x50
> [    0.000000]  [<ffffffff810bb912>] __kmalloc+0x112/0x120
> [    0.000000]  [<ffffffff8146e773>] vgacon_scrollback_startup+0x13/0x70
> [    0.000000]  [<ffffffff811d29b3>] vgacon_startup+0x2a3/0x420
> [    0.000000]  [<ffffffff816fc556>] con_init+0x1b/0x230
> [    0.000000]  [<ffffffff816fba00>] console_init+0x22/0x42
> [    0.000000]  [<ffffffff816d4b8f>] start_kernel+0x240/0x3be
> [    0.000000]  [<ffffffff816d4289>] x86_64_start_reservations+0x99/0xb9
> [    0.000000]  [<ffffffff816d4389>] x86_64_start_kernel+0xe0/0xf2
> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
> 
> I also got it on 2.6.31.9, but had waited to ask hoping 2.6.32.2 would fix it.
> 
> Attached is my config


