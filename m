Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbXEJUyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbXEJUyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbXEJUyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:54:36 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2733 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbXEJUyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:54:35 -0400
Date: Thu, 10 May 2007 21:54:27 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: cw@f00f.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
Message-ID: <20070510205427.GF29713@flint.arm.linux.org.uk>
Mail-Followup-To: David Miller <davem@davemloft.net>, cw@f00f.org,
	linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <20070510203417.GA23019@tuatara.stupidest.org> <20070510.135147.55726615.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510.135147.55726615.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 01:51:47PM -0700, David Miller wrote:
> From: Chris Wedgwood <cw@f00f.org>
> Date: Thu, 10 May 2007 13:34:18 -0700
> 
> > MODPOST seems to be spewing bogus warnings.  It's not clear how best
> > to fix it so perhaps we should silence it for now?
> 
> Most of them are legitimate, the only one that needs sorting
> is the mm/slab.c case and people are working on that.
> 
> The rest are useful and I've been working to fix things up
> on sparc64 and the networking, and in fact I'm very happy
> about these notifications.
> 
> Please don't apply a sledgehammer to this issue, thanks.

I've not had one accurate one on ARM yet.

Here's another example:

WARNING: init/built-in.o - Section mismatch: reference to .init.text:
 from .text between 'rest_init' (at offset 0x4c) and 'run_init_process'

from init/main.c:

static void noinline rest_init(void)
        __releases(kernel_lock)

static void run_init_process(char *init_filename)

Clearly, it just does _not_ work.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
