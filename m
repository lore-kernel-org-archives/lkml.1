Return-Path: <linux-kernel-owner+w=401wt.eu-S965529AbXCLK63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965529AbXCLK63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965538AbXCLK63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:58:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55628 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965529AbXCLK62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:58:28 -0400
Date: Mon, 12 Mar 2007 11:58:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, npiggin@suse.de, drepper@redhat.com,
       oleg@tv-sign.ru, sebastien.dugue@bull.net, linux-kernel@vger.kernel.org
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312105826.GB11864@one.firstfloor.org>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu> <p73bqiyaehp.fsf@bingen.suse.de> <1173697220.13341.84.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173697220.13341.84.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 12:00:20PM +0100, Thomas Gleixner wrote:
> On Mon, 2007-03-12 at 12:27 +0100, Andi Kleen wrote:
> > Ingo Molnar <mingo@elte.hu> writes:
> > > 
> > > the only correct approach is the use of hrtimers, and a patch exists for 
> > > that - see below. This has been included in -rt for quite some time.
> > 
> > But isn't that bad for power management? You'll likely get more
> > idle wakeups, won't you?
> 
> Why so ? It comes more precise, but only once.

When it's clustered around the jiffies interval then wakeups from
multiple processes will be somewhat batched. With a precise wakeup you'll
get wakeups all over the jiffies period, won't you?

-Andi
