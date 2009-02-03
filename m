Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbZBCBdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbZBCBdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZBCBdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:33:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:44682 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbZBCBdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:33:13 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0902021635240.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
	 <1233614927.18767.121.camel@pasglop>  <200902030000.18049.rjw@sisk.pl>
	 <1233620590.18767.138.camel@pasglop>
	 <alpine.LFD.2.00.0902021635240.3247@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 12:32:41 +1100
Message-Id: <1233624761.18767.155.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Why do you think this improves on anything?
> 
> Basically, it turns the mutex into a non-entity - but if your whole 
> argument is that it might as well be a non-entity because nobody else can 
> take it anyway, then why not just leave it around?
> 
> IOW, if your argument boils down to "there can be no contention", then you 
> might as well say "just use the mutex, it will never block".

Oh sure, you all argument is fine, there's just one little nit for which
I think it made sense to take the mutex that way...

The possible problem I see is on the "boundary" when you are about to
get interrupts off. You want to make sure that any other kernel thread /
process that was inside ACPI is completed before you do that.

Taking the mutex will do that for you.

Then you can disable interrupts and just ignore the mutex until you
re-enable them.

Now, of course, in a perfect world, anything that can poke ACPI would have
got some suspend calls before hand and won't be around touching it but
I wouldn't bet my life on this.

Cheers,
Ben.


