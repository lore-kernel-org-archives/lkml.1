Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab0BCI6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 03:58:52 -0500
Received: from verein.lst.de ([213.95.11.210]:55313 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab0BCI6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 03:58:50 -0500
Date: Wed, 3 Feb 2010 09:56:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, roland@redhat.com, oleg@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, mattst88@gmail.com,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, vapier@gentoo.org, starvik@axis.com,
       jesper.nilsson@axis.com, ysato@users.sourceforge.jp,
       takata@linux-m32r.org, gerg@uclinux.org, monstr@monstr.eu,
       ralf@linux-mips.org, jdike@addtoit.com, chris@zankel.net
Subject: Re: [PATCH 1/14] move user_enable_single_step & co prototypes to linux/ptrace.h
Message-ID: <20100203085655.GA29945@lst.de>
References: <20100202185755.GA3630@lst.de> <8bd0f97a1002030042t5cdc1a88oe9e273e7d6ec4269@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a1002030042t5cdc1a88oe9e273e7d6ec4269@mail.gmail.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 03:42:05AM -0500, Mike Frysinger wrote:
> On Tue, Feb 2, 2010 at 13:57, Christoph Hellwig wrote:
> > While in theory user_enable_single_step/user_disable_single_step/
> > user_enable_blockstep could also be provided as an inline or macro there's no
> > good reason to do so, and having the prototype in one places keeps code size
> > and confusion down.
> 
> the only annoying thing here is that we currently have to enable both
> user_disable_single_step() and ptrace_disable() that do exactly the
> same thing.  i avoided this somewhat on Blackfin by cheating:
> #define user_disable_single_step(child) ptrace_disable(child)
> 
> so now there's no code bloat.  perhaps this could be moved into common
> linux/ptrace.h too ?

What is done by most architectures is ptrace_disable simply
calling user_disable_single_step.  Long-term I expect ptrace_disable to
go away entirely.  While a few architectures do more than just
user_disable_single_step in it that seems at least fishy to me, but
I'll wait with the audit until we have everyone actually using
ptrace_resume.
