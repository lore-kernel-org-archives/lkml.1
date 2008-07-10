Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbYGJNYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbYGJNYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYGJNYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:24:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382AbYGJNYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:24:39 -0400
Date: Thu, 10 Jul 2008 06:18:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Sustrik <sustrik@fastmq.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Martin Lucina <mato@kotelna.sk>,
       linux-kernel@vger.kernel.org
Subject: Re: Higher than expected disk write(2) latency
Message-Id: <20080710061822.38975133.akpm@linux-foundation.org>
In-Reply-To: <48760BFB.90007@fastmq.com>
References: <20080628121131.GA14181@nodbug.moloch.sk>
	<20080709222701.8eab4924.akpm@linux-foundation.org>
	<4875C45C.2010901@fastmq.com>
	<20080710093109.46db7c40@the-village.bc.nu>
	<48760BFB.90007@fastmq.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 15:17:47 +0200 Martin Sustrik <sustrik@fastmq.com> wrote:

> Hi Alan,
> 
> >> What we see is that AIO performs rather bad while we are still 
> >> enqueueing more writes (it misses right position on the disk and has to 
> >> do superfluous disk revolvings), however, once we stop enqueueing new 
> >> write request, those already in the queue are processed swiftly.
> > 
> > Which disk scheduler are you using - some of the disk schedulers
> > intentionally delay writes to try and get better block merging.
> 
> It's CFQ. Does it delay writes? And if so, what should we use instead?
> 

noop is the simplest scheduler.  deadline is the simplest real scheduler,
and deadline doesn't have any delaying logic.

If CFQ or anticipatory _are_ putting delays into this workload, that'd be
a bug.
