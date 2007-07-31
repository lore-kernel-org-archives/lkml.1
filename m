Return-Path: <linux-kernel-owner+w=401wt.eu-S939921AbXGaBYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939921AbXGaBYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbXGaBYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:24:44 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49845 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123AbXGaBYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:24:43 -0400
Date: Mon, 30 Jul 2007 18:23:40 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2.6.23-rc1 REGRESSION] CPU hotplug totally broken on HPC
	nx6325 (x86_64)
Message-ID: <20070731012340.GD3673@sequoia.sous-sol.org>
References: <200707261440.50649.rjw@sisk.pl> <alpine.LFD.0.999.0707260924150.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707260924150.3442@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Thu, 26 Jul 2007, Rafael J. Wysocki wrote:
> > On my Turion64-based HPC nx6325 with the 2.6.23-rc1 x86_64 kernel doing
> > 
> > # echo 0 > /sys/devices/system/cpu/cpu1/online
> > 
> > causes the system to crash in a spectacular fashion (call traces going
> > continuously on the console, no reaction to anything except for the power
> > button).  For this reason, suspend and hibernation don't work as well.
> 
> Yeah, I really shouldn't have applied that patch. I didn't notice that it 
> not only cleaned up the direct memcpy's, it also re-introduced the damn 
> broken code that we fixed once already.

This also fixes paravirt patching which was broken when text_poke()
tried to patch the various pv ops in lookup_address.

thanks,
-chris
