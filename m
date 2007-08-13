Return-Path: <linux-kernel-owner+w=401wt.eu-S937436AbXHMPlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937436AbXHMPlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S945885AbXHMNxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:53:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45629 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762424AbXHMNxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:53:39 -0400
Subject: Re: min_free_kbytes documentation, /proc/sys/vm docs
From: Peter Zijlstra <peterz@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       andrea@suse.de, npiggin@suse.de
In-Reply-To: <20070813134626.GA7305@atrey.karlin.mff.cuni.cz>
References: <20070813134626.GA7305@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 15:53:00 +0200
Message-Id: <1187013180.20108.59.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 15:46 +0200, Pavel Machek wrote:
> Hi!
> 
> min_free_kbytes documentation says:
> 
> min_free_kbytes:
> 
> This is used to force the Linux VM to keep a minimum number 
> of kilobytes free.  The VM uses this number to compute a pages_min
> value for each lowmem zone in the system.  Each lowmem zone gets 
> a number of reserved free pages based proportionally on its size.
> 
> ....which is not too helpful :-(. In particular, should kernel survive
> setting this to 0 and still work reliably? IOW is this
> performance-only tweak, or does it correctness implications?

correctness

sort-of, since PF_MEMALLOC usage is currently un-bounded.

> I guess it should also say something like "do not set this to more
> than half of your physical RAM (or half of lowmem?) or you get an
> instant OOM".

yeah, lowmem, not sure on the oom part, it should work with quite high
limits, although I've never tried it with ridiculous numbers.

