Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbYJBJGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbYJBJGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYJBJG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:06:28 -0400
Received: from www.tglx.de ([62.245.132.106]:49447 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYJBJG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:06:26 -0400
Date: Thu, 2 Oct 2008 11:05:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>, jeff@garzik.org,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: [PATCH] e1000e: write protect ICHx NVM to prevent malicious
 write/erase
In-Reply-To: <48E424EB.1000204@linux.intel.com>
Message-ID: <alpine.LFD.1.10.0810021102000.5549@apollo.tec.linutronix.de>
References: <20081002001830.5951.3123.stgit@jbrandeb-bw.jf.intel.com> <20081002001835.5951.82533.stgit@jbrandeb-bw.jf.intel.com> <alpine.LFD.2.00.0810011731350.3341@nehalem.linux-foundation.org> <48E424EB.1000204@linux.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008, Arjan van de Ven wrote:

> Linus Torvalds wrote:
> > 
> > On Wed, 1 Oct 2008, Jesse Brandeburg wrote:
> > > From: Bruce Allan <bruce.w.allan@intel.com>
> > > 
> > > Set the hardware to ignore all write/erase cycles to the GbE region in
> > > the ICHx NVM.  This feature can be disabled by the WriteProtectNVM module
> > > parameter (enabled by default) only after a hardware reset, but
> > > the machine must be power cycled before trying to enable writes.
> > 
> > Thanks, applied.
> > 
> > One thing that I did notice when I looked at the driver is that I don't see
> > any serialization what-so-ever around a lot of the special accesses.
> > 
> 
> there's quite a few of that yes.
> These are all fixed afaik but these fixes are being queued for 2.6.28 rather
> than being snuck in late into .27
> (the patches have been posted to lkml a few times the last week)

Hmm. The mutex around the nvram acquire catched at least a couple of
problems and IMHO they are serious enough to go into .27. At least to
make sure that we do not accidentaly reenter the nvram functions under
any circumstances.

Thanks,

	tglx
