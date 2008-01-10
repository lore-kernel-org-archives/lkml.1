Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYAJCei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYAJCei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYAJCeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:34:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41575 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbYAJCea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:34:30 -0500
Date: Thu, 10 Jan 2008 03:37:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, andi@firstfloor.org,
       harvey.harrison@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: uml and -regparm=3
Message-ID: <20080110023701.GB20813@one.firstfloor.org>
References: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu> <p734pdmput0.fsf@bingen.suse.de> <E1JCiLx-0006lI-HR@pomaz-ex.szeredi.hu> <20080109213258.GC15612@one.firstfloor.org> <E1JCioy-0006os-6i@pomaz-ex.szeredi.hu> <20080110021404.GA11287@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110021404.GA11287@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 09:14:04PM -0500, Jeff Dike wrote:
> On Wed, Jan 09, 2008 at 10:50:48PM +0100, Miklos Szeredi wrote:
> > > FASTCALL is useless and should not make a difference. It enables
> > > regparm on specific functions, but that should not make a difference
> > > if it works or not.
> > 
> > __down_write() in include/asm-x86/rwsem.h seems to assume, that the
> > semaphore pointer is passed in %eax down to rwsem_down_write_failed(),
> > so regparm does make a difference there.
> 
> And rwsem_down_write_failed seems to think it's getting the pointer in
> %eax:

That's a left over from when it was called by magic inline assembly.
I suspect it would be better to switch it just over to stack args
for consistent and then declare it asmlinkage

-Andi
