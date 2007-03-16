Return-Path: <linux-kernel-owner+w=401wt.eu-S965969AbXCPVnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965969AbXCPVnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965970AbXCPVnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:43:49 -0400
Received: from waste.org ([66.93.16.53]:35141 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965969AbXCPVnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:43:49 -0400
Date: Fri, 16 Mar 2007 16:29:48 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>, Daniel Walker <dwalker@mvista.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] Sched clock paravirt op fix.patch
Message-ID: <20070316212948.GH10459@waste.org>
References: <200703020254.l222sOaM009656@zach-dev.vmware.com> <20070313140129.GB92373@muc.de> <45F6C2A3.4040305@goop.org> <20070313160709.GH10574@sequoia.sous-sol.org> <20070313161656.GA12128@muc.de> <45F6D361.8080106@redhat.com> <20070313205628.GB46469@muc.de> <45F71207.8050605@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F71207.8050605@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 02:05:11PM -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > It depends -- under heavy network load you can spend a long time
> > just processing interrupts.
> 
> Well, in that case you probably don't want to charge them to the process
> which happens to be running at the time.

It's actually a good first-order approximation of the right thing to
do, as it will generally correlate with the userspace process
servicing that network load.

If not (for instance, with routing loads), then you'd basically expect
the charge to get spread around evenly in proportion to an
application's CPU usage.

The -rt kernel pushes most of the interrupt work off to threads, which
of course follow the same scheduling and accounting rules as
everything other thread.

-- 
Mathematics is the supreme nostalgia of our time.
