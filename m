Return-Path: <linux-kernel-owner+w=401wt.eu-S1031499AbXD3Jdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031499AbXD3Jdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 05:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031512AbXD3Jdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 05:33:40 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4569 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031485AbXD3Jdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 05:33:39 -0400
Date: Mon, 30 Apr 2007 10:33:31 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@infradead.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: utrace comments
Message-ID: <20070430093331.GB11345@flint.arm.linux.org.uk>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,
	Christoph Hellwig <hch@infradead.org>,
	Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <20061127165138.GA2991@lst.de> <20070430040213.BF9901801A4@magilla.sf.frob.com> <20070430090840.GB31397@infradead.org> <20070430091808.GA11345@flint.arm.linux.org.uk> <20070430092200.GA15773@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430092200.GA15773@lst.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 11:22:00AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 30, 2007 at 10:18:09AM +0100, Russell King wrote:
> > Roland's idea of single-stepping is that it *must* be supported by
> > hardware for utrace to use it.  There are a number of architectures
> > which can only do single-stepping by modifying the text of the
> > program being single stepped.  ARM is one such example.
> > 
> > As such, even when utrace is complete, some architectures will never
> > support in-kernel single step with utrace.  I believe Roland's idea
> > is to have single step supported on these via some vapourware userspace
> > library.
> 
> Does the current arm ptrace code support single stepping in kernelspace?
> If yes we absolutely need to continue to support it.

single stepping of user space code via standard ptrace calls, yes.

> > I'd also like to see utrace become *optional*
> > for architectures to support, rather than as it currently stands as
> > a *mandatory* requirement when merged.
> 
> No way we'd keep both the old ptrace mess and utrace in the same tree.

Given the stated arguments from yourself and Roland, that only leaves
one solution to that.

I have no real problem with a decision being made to drop kernel-based
single stepping _provided_ we have some replacement strategy in place
and readily available.  At the moment I've not seen such a strategy.

I'm not sure if Roland's expecting architecture maintainers to
create such a strategy themselves - which would probably turn out to
being far worse since you could end up with different implementations
for each architecture.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
