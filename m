Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYJFOYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYJFOYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 10:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYJFOYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 10:24:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:52434 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYJFOYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 10:24:42 -0400
Date: Mon, 6 Oct 2008 07:24:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: banning device driver reserved resources from /dev/mem
Message-ID: <20081006072437.5d1360dd@infradead.org>
In-Reply-To: <20081006151411.05ed5f50@lxorguk.ukuu.org.uk>
References: <20081005180154.7cc12486@infradead.org>
	<20081006102739.16d1a434@lxorguk.ukuu.org.uk>
	<48EA1540.8060409@gmail.com>
	<20081006144835.6e58f73a@lxorguk.ukuu.org.uk>
	<20081006065213.76dc729a@infradead.org>
	<20081006150122.3860cae1@lxorguk.ukuu.org.uk>
	<20081006070543.23b14828@infradead.org>
	<20081006151411.05ed5f50@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008 15:14:11 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > no argument, except that the kernel doesn't do request_region() on
> > it to expect exclusivity (so the patch doesn't do anything on this
> > region)
> 
> Its on the TODO list for the vt fixes
> 
> > Now having said that, if the DRM layer does request_region on the
> > MMIO bars, we might need a flag that explicitly says "this is
> > intended for sharing with userspace" for this known case; not too
> > hard, I'll check with Dave Airlie.
> 
> DRM isn't the problem. In the DRM case the DRM can provide the
> mappings and manage them. In the non DRM case its messier but for the
> moment probably happens by luck to be ok

I'll add a "share resource with userland" option to allow us to make
this desire explicit for the cases we want this (and can tolerate
concurrent accesses)

> 
> I still think your restrictive /dev/mem model is wrong. I think it
> comes about because your /dev/mem restrictions are for multiple
> conflicting purposes.

for me it is a goal to have /dev/mem do as little as possible while
allowing the "normal" uses. This is to help SELinux to have sane policy
rather than "X still has perms to own the whole box" etc.

> 
> The root of that is the 'vaguely annoy root kit writers for 5 minutes'
> reasoning which erroneously leads to trying to a compile time option,
> combined some would argue with a 'screw people hacking hardware in
> userspace who should provide drivers' view.

this patch absolutely has nothing to do with rootkits; really.
it came out of chasing e1000e with the "eh who maps our e1000e bar from
userspace" scare. Followed by thinking "if the driver requests
exclusivity the kernel should try to grant that".

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
