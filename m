Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbZBCLH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbZBCLH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZBCLHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:07:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbZBCLHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:07:15 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <20090203050648.GA14076@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
	 <1233614927.18767.121.camel@pasglop> <200902030000.18049.rjw@sisk.pl>
	 <1233620590.18767.138.camel@pasglop>
	 <alpine.LFD.2.00.0902021635240.3247@localhost.localdomain>
	 <20090203050648.GA14076@elte.hu>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 12:06:55 +0100
Message-Id: <1233659215.10184.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 06:06 +0100, Ingo Molnar wrote:
> 
> Mutexes should work just fine in irqs-off sections - they'll safely 
> save/restore interrupts, even the debug variants.

mutex_lock() has might_sleep() which will generate a splat in atomic
contexts.

That said, afaik the acpi code uses semaphores.

