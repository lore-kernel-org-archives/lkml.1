Return-Path: <linux-kernel-owner+w=401wt.eu-S1946267AbXBPV0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946267AbXBPV0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946270AbXBPV0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:26:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946267AbXBPV0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:26:38 -0500
Date: Fri, 16 Feb 2007 16:26:31 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeff Muizelaar <jeff@infidigm.net>, linux-kernel@vger.kernel.org
Subject: Re: Using sched_clock for mmio-trace
Message-ID: <20070216212630.GC27135@redhat.com>
References: <20070216013024.GA32287@infidigm.net> <y0mr6sq2hfj.fsf@ton.toronto.redhat.com> <p73fy95g99w.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73fy95g99w.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Feb 16, 2007 at 09:03:23PM +0100, Andi Kleen wrote:
> > We in systemtap land have the same problem, and so far made do with
> > slightly postprocessed per-cpu TSC values.
> 
> 90+% likely you're not solving your problem correctly this way.

Yes, it was done as a last resort.

We need facility that we can call from even more demanding contexts
than interrupt handlers, considering that kprobes can be placed nearly
anywhere.  This is one of the reasons why we don't just use good old
do_gettimeofday(), since it takes locks and can lead to lock recursion
if parts of itself are probed.

- FChE
