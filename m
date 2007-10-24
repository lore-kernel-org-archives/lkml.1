Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbXJXLkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbXJXLkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756434AbXJXLjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:39:54 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:19026 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341AbXJXLjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:39:52 -0400
Date: Wed, 24 Oct 2007 15:39:09 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Bogus KERN_ALERT on oops
Message-ID: <20071024113909.GA6214@localhost.sw.ru>
References: <20071022115704.GA6271@localhost.sw.ru> <84144f020710220606o2e52afbfu66a2146c5433d96f@mail.gmail.com> <20071024103318.GB18741@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024103318.GB18741@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 12:33:18PM +0200, Ingo Molnar wrote:
> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > > -                       printk(KERN_ALERT "*pde = %016Lx ", page);
> > > +                       printk("*pde = %016Lx ", page);
> > 
> > Use the new KERN_CONT annotation here?
> 
> indeed - i changed the patch to do that.

Might as well change comment around KERN_CONT -- for starters it lied
about "early bootup" phase since day one.

Proposed text:

	/*
	 * Annotation for a "continued" line of log printout (only done
	 * after a line that had no enclosing \n).
	 *
	 * Introduced because checkpatch.pl couldn't be arsed to learn C
	 * and distinguish continued printk() from the one that starts
	 * new line.
	 *
	 * Caveat #1: Empty string-literal, so compiler can't check for
	 *            KERN_CONT misuse.
	 * Caveat #2: Empty string-literal, so it can't be used in
	 *            printk(var); situations.
	 * Caveat #3: takes characters on the screen, so code is harder
	 *            to read.
	 * Caveat #4: checkpatch.pl doesn't know C, so it can't check
	 *            for KERN_CONT misuse, anyway.
	 */

