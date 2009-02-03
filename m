Return-Path: <linux-kernel-owner+w=401wt.eu-S1752418AbZBCBr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbZBCBr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZBCBrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:47:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:46445 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbZBCBrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:47:19 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0902021729510.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <200902030045.19416.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021551050.3247@localhost.localdomain>
	 <200902030115.32659.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021622350.3247@localhost.localdomain>
	 <1233623525.18767.151.camel@pasglop>
	 <alpine.LFD.2.00.0902021729510.3247@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 12:46:46 +1100
Message-Id: <1233625606.18767.157.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Note how the PCI layer (currently) only saves the low _16_ dwords of 
> config space (64 bytes). The radeonfb code that did it by hand saved the 
> whole 64 dwords (256 bytes). It _probably_ doesn't matter, but..
> 
> The reason the PCI layer only does 64 bytes is that that was the really 
> old PCI config space model - the rest was undefined and apparently a few 
> cards reportedly even crashed when accessing it (but who knows, that may 
> be urban folklore).
> 
> But if that patch works for you, it's clearly already better than _not_ 
> applying the patch, so..

Radeons don't do much with config space... the worst we may miss I
suppose is subsystem vendor/device... Maybe I'll add something to
explicitely save and restore it or X might get upset. I'll have a look.

At some point, that whole code will migrate out of radeonfb into the new
radeon DRM with kernel mode setting in which case even X should stop
caring ... mostly.

Cheers,
Ben.


